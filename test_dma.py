import os
import time
import subprocess

def send_cmd(command):
    # Runs the command quietly in the background
    os.system(command + " > /dev/null 2>&1")

def read_cmd(command):
    # Runs the command and captures the output back into Python
    return subprocess.check_output(command, shell=True).decode('utf-8').strip()

print("Starting DMA Test")

# 1. Soft Reset the DMA
send_cmd("devmem 0x41E00030 32 0x4")
send_cmd("devmem 0x41E00000 32 0x4")
time.sleep(0.5)

# 2. Setup Filter Mode to Invert (Mode 1)
send_cmd("devmem 0x44A10000 32 0x1")

# 3. Setup Memory (Pure Red -> Source, Clear Destination)
input_color = "0x00FF0000"
print(f"Input Color hex value: {input_color}")

send_cmd(f"devmem 0x81000000 32 {input_color}")
send_cmd("devmem 0x82000000 32 0x00000000")

# 4. START both DMA channels
send_cmd("devmem 0x41E00030 32 0x1")
send_cmd("devmem 0x41E00000 32 0x1")

# 5. Set Source and Destination Addresses
send_cmd("devmem 0x41E00048 32 0x82000000")
send_cmd("devmem 0x41E00018 32 0x81000000")

# 6. Trigger Transfer
send_cmd("devmem 0x41E00058 32 0x4")
send_cmd("devmem 0x41E00028 32 0x4")

time.sleep(0.2)

# 7. Read and Print Result
result_color = read_cmd("devmem 0x82000000")
print(f"Result Color hex value: {result_color}")