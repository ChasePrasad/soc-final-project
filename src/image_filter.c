/*
 * image_filter.c — Hardware-accelerated image filter for the Urbana Board
 *
 * Loads a PNG, converts it to the 0x00RRGGBB pixel format expected by the
 * AXI4-Stream filter IP, transfers it through the AXI DMA, and saves the
 * result back as a PNG.
 *
 * Usage:
 *   ./image_filter <input.png> <filter_mode> <output.png>
 *
 * Filter modes (from image_filter_ip.v):
 *   0 — Passthrough
 *   1 — Invert
 *   2 — Grayscale
 *
 * Build:
 *   gcc -O2 -o image_filter image_filter.c -lm
 *
 * Requires stb_image.h and stb_image_write.h in the same directory.
 * Download from: https://github.com/nothings/stb
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <time.h>

// stb_image
#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image.h"
#include "stb_image_write.h"

// Hardware addresses
#define FILTER_IP_BASE    0x44A10000 // AXI-Lite control regs for filter IP
#define FILTER_IP_SIZE    0x00010000

#define DMA_BASE          0x41E00000 // AXI DMA register block
#define DMA_SIZE          0x00010000

// AXI DMA register offsets
#define MM2S_CTRL         0x00 // MM2S DMA Control
#define MM2S_STAT         0x04 // MM2S DMA Status
#define MM2S_SRC_ADDR     0x18 // MM2S Source Address
#define MM2S_LENGTH       0x28 // MM2S Transfer Length (bytes)
#define S2MM_CTRL         0x30 // S2MM DMA Control
#define S2MM_STAT         0x34 // S2MM DMA Status
#define S2MM_DST_ADDR     0x48 // S2MM Destination Address
#define S2MM_LENGTH       0x58 // S2MM Transfer Length (bytes)

// DMA control register bits
#define DMA_CTRL_RUN      0x1 // Start/keep running
#define DMA_CTRL_RESET    0x4 // Soft reset

// DMA status register bits
#define DMA_STAT_IDLE     (1 << 1) // Channel is idle (transfer complete)
#define DMA_STAT_HALTED   (1 << 0) // Channel is halted (error or reset)

/* Physical DDR3 addresses used as DMA pixel buffers.
 * Max supported image: 1920×1080 = 8,294,400 bytes */
#define SRC_BUF_PHYS      0x81000000
#define DST_BUF_PHYS      0x82000000
#define MAX_BUF_BYTES     (1920 * 1080 * 4) // 4 bytes per pixel

// Register access macros
#define REG_WR(base, off, val)  (*((volatile uint32_t *)((base) + (off))) = (val))
#define REG_RD(base, off)       (*((volatile uint32_t *)((base) + (off))))

// Sleep helper
static void sleep_ms(int ms)
{
    struct timespec ts = { .tv_sec = ms / 1000,
                           .tv_nsec = (ms % 1000) * 1000000L };
    nanosleep(&ts, NULL);
}

// mmap a physical address range via /dev/mem
static void *mmap_phys(int devmem_fd, uint32_t phys_addr, size_t size)
{
    void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
                     MAP_SHARED, devmem_fd, (off_t)phys_addr);
    if (ptr == MAP_FAILED) {
        fprintf(stderr, "mmap failed for 0x%08X (size 0x%zx)\n", phys_addr, size);
        return NULL;
    }
    return ptr;
}

// Reset both DMA channels
static void dma_reset(void *dma)
{
    REG_WR(dma, S2MM_CTRL, DMA_CTRL_RESET);
    REG_WR(dma, MM2S_CTRL, DMA_CTRL_RESET);
    sleep_ms(50); // wait for reset to start

    // wait for reset to finish
    int timeout = 100;
    while (timeout-- > 0) {
        uint32_t s_mm2s = REG_RD(dma, MM2S_STAT);
        uint32_t s_s2mm = REG_RD(dma, S2MM_STAT);
        if (!(s_mm2s & DMA_STAT_HALTED) && !(s_s2mm & DMA_STAT_HALTED))
            break;
        sleep_ms(10);
    }
    if (timeout <= 0)
        fprintf(stderr, "Warning: DMA did not come out of reset cleanly\n");
}

// Poll until both channels go idle
static int dma_wait_idle(void *dma, int timeout_ms)
{
    int elapsed = 0;
    while (elapsed < timeout_ms) {
        uint32_t mm2s_stat = REG_RD(dma, MM2S_STAT);
        uint32_t s2mm_stat = REG_RD(dma, S2MM_STAT);

        if ((mm2s_stat & DMA_STAT_IDLE) && (s2mm_stat & DMA_STAT_IDLE))
            return 0;   // success!

        sleep_ms(1);
        elapsed++;
    }
    fprintf(stderr, "DMA timeout! MM2S_STAT=0x%08X  S2MM_STAT=0x%08X\n",
            REG_RD(dma, MM2S_STAT), REG_RD(dma, S2MM_STAT));
    return -1;
}

// Run one full DMA transfer through the filter IP
static int dma_run(void *dma, uint32_t n_bytes)
{
    // 1. Start both channels
    REG_WR(dma, MM2S_CTRL, DMA_CTRL_RUN);
    REG_WR(dma, S2MM_CTRL, DMA_CTRL_RUN);

    // 2. Load source / destination physical addresses
    REG_WR(dma, MM2S_SRC_ADDR, SRC_BUF_PHYS);
    REG_WR(dma, S2MM_DST_ADDR, DST_BUF_PHYS);

    // 3. Write to length register to trigger the actual transfer
    REG_WR(dma, S2MM_LENGTH, n_bytes);   // set S2MM first
    REG_WR(dma, MM2S_LENGTH, n_bytes);   // Start the pixel stream

    // 4. Poll for completion (w/ 5-second timeout for large images)
    return dma_wait_idle(dma, 5000);
}

int main(int argc, char *argv[])
{
    if (argc != 4) {
        fprintf(stderr,
            "Usage: %s <input.png> <filter_mode> <output.png>\n"
            "\n"
            "  filter_mode:\n"
            "    0 — Passthrough\n"
            "    1 — Invert\n"
            "    2 — Grayscale\n",
            argv[0]);
        return 1;
    }

    const char *input_path  = argv[1];
    int         filter_mode = atoi(argv[2]);
    const char *output_path = argv[3];

    if (filter_mode < 0 || filter_mode > 2) {
        fprintf(stderr, "Error: filter_mode must be 0, 1, or 2\n");
        return 1;
    }

    // 1: Load PNG
    printf("Loading image: %s\n", input_path);

    int width, height, channels_in_file;
    // Force 3 channels (RGB)
    unsigned char *rgb = stbi_load(input_path, &width, &height,
                                   &channels_in_file, 3);
    if (!rgb) {
        fprintf(stderr, "Error loading image: %s\n", stbi_failure_reason());
        return 1;
    }
    printf("  %d x %d pixels (%d channel(s) in file, loaded as RGB)\n",
           width, height, channels_in_file);

    uint32_t n_pixels = (uint32_t)width * (uint32_t)height;
    uint32_t n_bytes  = n_pixels * 4;   // 4 bytes per pixel (32-bit word)

    if (n_bytes > MAX_BUF_BYTES) {
        fprintf(stderr, "Error: image too large (%u bytes, max %d)\n",
                n_bytes, MAX_BUF_BYTES);
        stbi_image_free(rgb);
        return 1;
    }

    // 2: Open /dev/mem
    int devmem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (devmem_fd < 0) {
        perror("open /dev/mem");
        stbi_image_free(rgb);
        return 1;
    }

    // 3: Map hardware regions
    void *filter_regs = mmap_phys(devmem_fd, FILTER_IP_BASE, FILTER_IP_SIZE);
    void *dma_regs    = mmap_phys(devmem_fd, DMA_BASE,       DMA_SIZE);
    void *src_buf     = mmap_phys(devmem_fd, SRC_BUF_PHYS,   MAX_BUF_BYTES);
    void *dst_buf     = mmap_phys(devmem_fd, DST_BUF_PHYS,   MAX_BUF_BYTES);

    if (!filter_regs || !dma_regs || !src_buf || !dst_buf) {
        close(devmem_fd);
        stbi_image_free(rgb);
        return 1;
    }

    // 4: Convert RGB => 0x00RRGGBB and write to source DMA buffer
    printf("Converting to hardware pixel format...\n");

    volatile uint32_t *src_pixels = (volatile uint32_t *)src_buf;
    for (uint32_t i = 0; i < n_pixels; i++) {
        uint8_t r = rgb[i * 3 + 0];
        uint8_t g = rgb[i * 3 + 1];
        uint8_t b = rgb[i * 3 + 2];
        src_pixels[i] = ((uint32_t)r << 16) |
                        ((uint32_t)g <<  8) |
                        ((uint32_t)b      );
        // Upper byte is left as 0x00
    }
    stbi_image_free(rgb);   // done with the stb buffer

    // 5: Set filter mode register (slv_reg0)
    printf("Setting filter mode: %d\n", filter_mode);
    REG_WR(filter_regs, 0x00, (uint32_t)filter_mode);

    // 6: Reset DMA, then run transfer
    printf("Running DMA transfer (%u pixels, %u bytes)...\n",
           n_pixels, n_bytes);

    dma_reset(dma_regs);

    if (dma_run(dma_regs, n_bytes) != 0) {
        fprintf(stderr, "DMA transfer failed or timed out\n");
        goto cleanup;
    }
    printf("  Transfer complete.\n");

    // 7: Convert 0x00RRGGBB result => packed RGB for stb
    printf("Converting result back to RGB...\n");

    unsigned char *out_rgb = malloc(n_pixels * 3);
    if (!out_rgb) {
        fprintf(stderr, "malloc failed\n");
        goto cleanup;
    }

    volatile uint32_t *dst_pixels = (volatile uint32_t *)dst_buf;
    for (uint32_t i = 0; i < n_pixels; i++) {
        uint32_t word    = dst_pixels[i];
        out_rgb[i*3 + 0] = (word >> 16) & 0xFF;   // R
        out_rgb[i*3 + 1] = (word >>  8) & 0xFF;   // G
        out_rgb[i*3 + 2] =  word        & 0xFF;   // B
    }

    // 8: Save output PNG
    printf("Saving result: %s\n", output_path);

    if (!stbi_write_png(output_path, width, height, 3, out_rgb, width * 3)) {
        fprintf(stderr, "Error: failed to write output PNG\n");
        free(out_rgb);
        goto cleanup;
    }
    free(out_rgb);

    printf("Done.\n");

cleanup:
    munmap(filter_regs, FILTER_IP_SIZE);
    munmap(dma_regs,    DMA_SIZE);
    munmap(src_buf,     MAX_BUF_BYTES);
    munmap(dst_buf,     MAX_BUF_BYTES);
    close(devmem_fd);
    return 0;
}