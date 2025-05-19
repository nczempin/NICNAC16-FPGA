#!/usr/bin/env bash
set -e

# Compile Memory testbench using iverilog and run with vvp
# Output is stored in test.log

iverilog -o memory_tb \
  vivado_proj/Basys-3-GPIO.srcs/sources_1/new/Memory.v \
  vivado_proj/Basys-3-GPIO.srcs/sources_1/new/ROM.v \
  vivado_proj/Basys-3-GPIO.srcs/sources_1/imports/NICNAC16-FPGA/RAM.v \
  vivado_proj/Basys-3-GPIO.srcs/sim_1/new/Memory_tb.v

vvp memory_tb > test.log

echo "Test run completed. See test.log for details."
