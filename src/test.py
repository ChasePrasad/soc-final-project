import os
import time
import subprocess

# Filter mode constants (must match filter_mode[1:0] in the IP)
MODE_PASSTHROUGH = 0x0
MODE_INVERT      = 0x1
MODE_GRAYSCALE   = 0x2

def send_cmd(command):
    # Runs the command quietly in the background
    os.system(command + " > /dev/null 2>&1")

def read_cmd(command):
    # Runs the command and captures the output back into Python
    return subprocess.check_output(command, shell=True).decode('utf-8').strip()

def dma_reset():
    send_cmd("devmem 0x41E00030 32 0x4")   # S2MM soft reset
    send_cmd("devmem 0x41E00000 32 0x4")   # MM2S soft reset
    time.sleep(0.5)

def run_filter_test(filter_name, filter_mode, input_color):
    print(f"\n--- {filter_name} Test ---")
    print(f"Input Color:  {input_color}")

    dma_reset()

    # Set filter mode register (slv_reg0 at base address of filter IP)
    send_cmd(f"devmem 0x44A10000 32 {filter_mode}")

    # Write input pixel to source address, clear destination
    send_cmd(f"devmem 0x81000000 32 {input_color}")
    send_cmd( "devmem 0x82000000 32 0x00000000")

    # Start both DMA channels
    send_cmd("devmem 0x41E00030 32 0x1")   # S2MM run
    send_cmd("devmem 0x41E00000 32 0x1")   # MM2S run

    # Set source and destination addresses
    send_cmd("devmem 0x41E00048 32 0x82000000")  # S2MM destination
    send_cmd("devmem 0x41E00018 32 0x81000000")  # MM2S source

    # Trigger transfer (4 bytes = one 32-bit pixel)
    send_cmd("devmem 0x41E00058 32 0x4")   # S2MM length
    send_cmd("devmem 0x41E00028 32 0x4")   # MM2S length

    time.sleep(0.2)

    result_color = read_cmd("devmem 0x82000000")
    print(f"Result Color: {result_color}")
    return result_color

# -----------------------------------------------------------------------
# Test 1: Invert filter — pure red (0x00FF0000) should become (0x00_00FFFF)
# -----------------------------------------------------------------------
run_filter_test("Invert", MODE_INVERT, "0x00FF0000")

# -----------------------------------------------------------------------
# Test 2: Grayscale filter — pure red (0x00FF0000)
#   Expected Y = (77*255 + 150*0 + 29*0) >> 8 = 19635 >> 8 = 76 (0x4C)
#   So result should be 0x004C4C4C
# -----------------------------------------------------------------------
run_filter_test("Grayscale", MODE_GRAYSCALE, "0x00FF0000")

# -----------------------------------------------------------------------
# Test 3: Grayscale filter — pure white (0x00FFFFFF)
#   Expected Y = (77+150+29)*255 >> 8 = 65280 >> 8 = 255 (0xFF)
#   So result should be 0x00FFFFFF
# -----------------------------------------------------------------------
run_filter_test("Grayscale (white)", MODE_GRAYSCALE, "0x00FFFFFF")

# -----------------------------------------------------------------------
# Test 4: Passthrough — value should be unchanged
# -----------------------------------------------------------------------
run_filter_test("Passthrough", MODE_PASSTHROUGH, "0x00AABBCC")