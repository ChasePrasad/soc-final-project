/*
 * cool_filter.c — Standalone PNG filter add-on for the SoC final project
 *
 * Adds a separate executable that loads a PNG, applies a Neon Duotone
 * effect, and writes the result back as a PNG.
 *
 * Build:
 *   gcc -O2 -o cool_filter cool_filter.c -lm
 *
 * Usage:
 *   ./cool_filter <input.png> <output.png>
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image.h"
#include "stb_image_write.h"

static unsigned char clamp_u8(float x)
{
    if (x < 0.0f) {
        return 0;
    }
    if (x > 255.0f) {
        return 255;
    }
    return (unsigned char)(x + 0.5f);
}

static float clamp01(float x)
{
    if (x < 0.0f) {
        return 0.0f;
    }
    if (x > 1.0f) {
        return 1.0f;
    }
    return x;
}

int main(int argc, char *argv[])
{
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input.png> <output.png>\n", argv[0]);
        return 1;
    }

    const char *input_path = argv[1];
    const char *output_path = argv[2];

    int width = 0;
    int height = 0;
    int channels_in_file = 0;

    unsigned char *rgb = stbi_load(input_path, &width, &height, &channels_in_file, 3);
    if (!rgb) {
        fprintf(stderr, "Error loading image: %s\n", stbi_failure_reason());
        return 1;
    }

    int total_pixels = width * height;

    for (int i = 0; i < total_pixels; i++) {
        float r = (float)rgb[i * 3 + 0];
        float g = (float)rgb[i * 3 + 1];
        float b = (float)rgb[i * 3 + 2];

        float lum = (0.299f * r + 0.587f * g + 0.114f * b) / 255.0f;
        float shaped = powf(clamp01(lum), 0.85f);
        float edge_hint = fabsf(r - b) / 255.0f;
        float glow = 0.25f * edge_hint;
        float t = clamp01(shaped + glow);

        float shadow_r = 20.0f;
        float shadow_g = 35.0f;
        float shadow_b = 120.0f;

        float highlight_r = 255.0f;
        float highlight_g = 70.0f;
        float highlight_b = 220.0f;

        float out_r = shadow_r + (highlight_r - shadow_r) * t;
        float out_g = shadow_g + (highlight_g - shadow_g) * t;
        float out_b = shadow_b + (highlight_b - shadow_b) * t;

        float source_mix = 0.22f;
        out_r = out_r * (1.0f - source_mix) + r * source_mix;
        out_g = out_g * (1.0f - source_mix) + g * source_mix;
        out_b = out_b * (1.0f - source_mix) + b * source_mix;

        float contrast = 1.10f;
        out_r = (out_r - 128.0f) * contrast + 128.0f;
        out_g = (out_g - 128.0f) * contrast + 128.0f;
        out_b = (out_b - 128.0f) * contrast + 128.0f;

        rgb[i * 3 + 0] = clamp_u8(out_r);
        rgb[i * 3 + 1] = clamp_u8(out_g);
        rgb[i * 3 + 2] = clamp_u8(out_b);
    }

    if (!stbi_write_png(output_path, width, height, 3, rgb, width * 3)) {
        fprintf(stderr, "Error writing image: %s\n", output_path);
        stbi_image_free(rgb);
        return 1;
    }

    stbi_image_free(rgb);

    printf("Wrote Neon Duotone output to %s\n", output_path);
    return 0;
}
