#!/usr/bin/env bash
set -e

# Compile Memory testbench using iverilog and run with vvp
# Output is stored in test.log

echo "Running HDL tests"

# Check if iverilog is available
if ! command -v iverilog >/dev/null 2>&1; then
    echo "iverilog not available - skipping HDL tests"
    echo "To install iverilog: sudo apt-get install iverilog (Ubuntu) or similar for your platform"
    exit 0
fi

echo "Using iverilog to compile testbench..."
iverilog -o memory_tb \
  vivado_proj/Basys-3-GPIO.srcs/sources_1/new/Memory.v \
  vivado_proj/Basys-3-GPIO.srcs/sources_1/new/ROM.v \
  vivado_proj/Basys-3-GPIO.srcs/sources_1/imports/NICNAC16-FPGA/RAM.v \
  vivado_proj/Basys-3-GPIO.srcs/sim_1/new/Memory_tb.v

echo "Running simulation..."
vvp memory_tb > test.log

echo "Test run completed. See test.log for details."
