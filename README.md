NICNAC16
========
[![CI](https://github.com/nczempin/NICNAC16-FPGA/actions/workflows/ci.yml/badge.svg)](https://github.com/nczempin/NICNAC16-FPGA/actions/workflows/ci.yml)

Learning FPGAs and ASIC design with a complete 16-bit accumulator-based CPU

Inspired by the classic **DEC PDP-8** lineage, demonstrating how timeless computer architecture principles translate to modern FPGA and ASIC implementation.

See [instruction_set.md](docs/instruction_set.md) for details on the instruction set and [ARCHITECTURE.md](ARCHITECTURE.md) for design heritage and technical background.

## Setup

Install the required build tools using the provided script, which supports both FPGA and ASIC workflows:

```sh
./tools/scripts/setup.sh
```

**FPGA Development**: Installs iverilog, gtkwave, and build tools for simulation and synthesis
**ASIC Development**: Installs Docker and OpenLane for complete RTL-to-GDSII flow

For quick chip visualization:
```sh
./view_chip.sh  # Installs KLayout and opens the synthesized GDSII layout
```


## Build and Test

### FPGA Workflow
```sh
make          # Lint HDL, run testbench, create build artifacts
make test     # Run Memory testbench with iverilog
make lint     # Lint HDL sources
```

### ASIC Workflow (RTL-to-GDSII)
```sh
./run_openlane_docker.sh  # Complete ASIC synthesis using OpenLane + Sky130 PDK
./view_chip.sh            # View the synthesized chip layout in KLayout
```

## Current Status

### ✅ Completed Features
- **CPU Core**: 8/10 instructions implemented and working in simulation:
  - `NOP` (0x0) - No operation
  - `JMP` (0x1) - Jump to address
  - `LDA` (0x4) - Load accumulator from memory
  - `STA` (0x5) - Store accumulator to memory
  - `ADD` (0x6) - Add memory value to accumulator
  - `BAZ` (0x7) - Branch if accumulator zero
  - `BAN` (0x8) - Branch if accumulator negative
  - `DIO` (0xF) - Device input/output
- **Not Yet Implemented**: `BL` (0x2) - Branch with link, `RET` (0x3) - Return from subroutine
- **Memory System**: ROM/RAM subsystem with passing testbenches
- **FPGA Integration**: Basys-3 board support with I/O interfaces
- **ASIC Synthesis**: Complete RTL-to-GDSII flow with 0 DRC violations
- **Physical Layout**: 110.4μm × 108.8μm chip design for Sky130 130nm process
- **Verification**: LVS clean, timing constraints met, manufacturable design

## Development Workflows

### Instruction Set Architecture
- 16-bit accumulator-based CPU with 4-bit opcodes
- Memory-mapped I/O through DIO instruction
- Four-phase execution cycle (t0, t1, t2, t3)

### Verification Approaches
- **Unit Testing**: Individual module testbenches
- **Integration Testing**: cocotb-based Python test framework
- **System Testing**: Complete CPU simulation with instruction sequences
- **Physical Verification**: Post-layout timing and DRC checks

## Architecture Overview

### Core Components
- **nicnac16_cpu**: Top-level CPU module with clean interface
- **datapath**: Arithmetic operations, register file, data movement
- **control_unit**: Instruction decode and control signal generation
- **system_timing**: Four-phase timing control (t0, t1, t2, t3)
- **Memory**: Unified ROM/RAM interface

### Platform Support
- **Generic**: Hardware-independent CPU core
- **Basys-3**: FPGA development board integration
- **ASIC**: Sky130 130nm process synthesis

### File Organization
- **rtl/core/cpu/**: Hardware-independent CPU modules
- **rtl/platform/**: Platform-specific integration
- **asic_flow/**: OpenLane ASIC synthesis configuration
- **tb/**: Comprehensive test framework
- **tools/scripts/**: Development automation

## Educational Objectives

This project demonstrates a complete digital design flow from concept to silicon:

1. **HDL Design**: Verilog implementation of a custom CPU architecture
2. **Simulation**: Behavioral verification with comprehensive testbenches
3. **FPGA Synthesis**: Real hardware implementation on development boards
4. **ASIC Flow**: Professional chip design using industry-standard tools
5. **Physical Design**: Layout optimization and timing closure
6. **Verification**: DRC, LVS, and timing analysis

**Learning Focus**: Understanding the complete digital design ecosystem from RTL to manufacturable silicon.

## Visual Documentation

### CPU Architecture
![CPU schematics showing main processing units](dunc16%20main_unit%20schematics%20.png)

### Simulation Results
![Simulation waveforms with NOP, LDA, ADD and JMP instructions working](pictures/dunc16sim003.png)

### Physical Implementation
![ASIC physical layout (GDSII) in KLayout showing the synthesized CPU](terrible_GDS.png)

*Complete design flow: From schematic design → functional simulation → physical chip layout*
