# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

The project uses a Makefile for primary build operations:

- `make` - Run full build pipeline (lint, test, package)
- `make test` - Run Memory testbench using iverilog
- `make lint` - Lint HDL sources with verilator or iverilog  
- `make package` - Create build artifacts zip
- `make clean` - Remove generated files and outputs

Alternative test execution:
- `bash scripts/test.sh` - Run Memory testbench, output to test.log
- `RUN_TESTS=1 bash scripts/build.sh` - Build artifacts and run tests

Setup toolchain:
- `./setup.sh` - Install required packages (g++, make, cppcheck, iverilog)

Vivado workflow:
- Open `vivado_proj/Basys-3-GPIO.xpr` in Vivado for synthesis and implementation
- Use Vivado for advanced timing analysis and hardware deployment

## Architecture Overview

NICNAC16 is a 16-bit accumulator-based CPU implemented in Verilog, targeting Basys-3 FPGA boards via Vivado.

### Core Components

- **NICNAC16** (`vivado_proj/Basys-3-GPIO.srcs/sources_1/new/NICNAC16.v`) - Top-level module for Basys-3 integration
- **control_unit** (`control_unit.v`) - Instruction decode and control signal generation
- **datapath** (`datapath.v`) - Data movement, ALU operations, register file
- **Memory** (`Memory.v`) - Unified memory interface wrapping ROM and RAM
- **system_timing** (`system_timing.v`) - Clock and timing control

### CPU Architecture

The CPU follows a simple accumulator machine design with:
- 16-bit instruction format: 4-bit opcode + 12-bit address/immediate
- Single accumulator register for arithmetic operations
- Memory-mapped I/O through DIO instruction
- Four execution phases controlled by timing signals (t0, t1, t2, t3)

### Instruction Set

Implemented opcodes (see `docs/instruction_set.md`):
- `NOP` (0x0), `JMP` (0x1), `BL` (0x2), `RET` (0x3)
- `LDA` (0x4), `STA` (0x5), `ADD` (0x6)
- `BAZ` (0x7), `BAN` (0x8), `DIO` (0xF)

Currently working in simulation: `NOP`, `LDA`, `ADD`, `JMP`

### File Organization

- **HDL Sources**: `vivado_proj/Basys-3-GPIO.srcs/sources_1/new/` - Main Verilog modules
- **Testbenches**: `vivado_proj/Basys-3-GPIO.srcs/sim_1/new/` - Simulation files
- **Legacy Sources**: `vivado_proj/Basys-3-GPIO.srcs/sources_1/imports/` - Imported components
- **Constraints**: `vivado_proj/Basys-3-GPIO.srcs/constrs_1/imports/constraints/` - FPGA pin assignments
- **Build Scripts**: `scripts/` - Automation scripts for testing and packaging
- **Documentation**: `docs/` - Architecture documentation and instruction set specification
- **Schematics**: Root directory contains CPU schematics (PNG files)

### Development Notes

- Primary testbench is Memory_tb.v, testing the memory subsystem
- Project uses iverilog for simulation and verilator for linting
- Build artifacts include documentation and schematics in zip format
- Test output stored in test.log for debugging
- Memory testbench validates ROM and RAM functionality independently

### Module Hierarchy

Key Verilog modules in `vivado_proj/Basys-3-GPIO.srcs/sources_1/new/`:
- **System.v** / **dunc16.v** - System-level integration
- **NICNAC16.v** - Top-level Basys-3 wrapper with I/O mapping
- **control_unit.v** - Instruction decode and control signal generation
- **datapath.v** - ALU operations and data movement
- **system_timing.v** - 4-phase timing control (t0, t1, t2, t3)
- **Memory.v** - Unified memory interface (wraps ROM.v and RAM.v)
- **console.v** - Hardware console interface for debugging

### Development Workflow

1. **Simulation**: Use `make test` for quick verification
2. **Vivado**: Open project for synthesis, implementation, and timing analysis
3. **Hardware**: Deploy to Basys-3 FPGA board for real-world testing
4. **Debugging**: Check test.log output and Vivado simulation results