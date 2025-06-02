# NICNAC16 CPU Core

## Overview

The NICNAC16 CPU core is a hardware-independent 16-bit processor design that implements a PDP-8 inspired instruction set architecture. The core is designed to be platform-agnostic and can be integrated into different FPGA platforms through a well-defined interface.

## Top-Level Module: `nicnac16_cpu`

### Interface

#### Clock and Reset
- `clk` - System clock input
- `reset` - Active-high asynchronous reset

#### Memory Interface
- `mem_address[15:0]` - Memory address bus output
- `mem_read[15:0]` - Memory data read bus input  
- `mem_write[15:0]` - Memory data write bus output
- `en_mem_write` - Memory write enable output

#### Control Interface
- `run` - CPU run/halt control input
- `step` - Single-step execution input
- `clear` - Clear/initialize CPU state input

#### Debug/Status Interface
- `PC[15:0]` - Program Counter output (for debugging)
- `AC[15:0]` - Accumulator output (for debugging)
- `IR[15:0]` - Instruction Register output (for debugging)

#### Platform Integration Points
- `console_in[15:0]` - Console input from platform
- `console_out[15:0]` - Console output to platform
- `console_write` - Console write strobe
- `halt` - CPU halt status output

## Core Architecture

### Major Components

#### Control Unit (`control_unit.v`)
- Instruction decode and execution control
- Timing state machine
- Handles fetch-decode-execute cycle
- **Location:** `rtl/core/cpu/control/`

#### Datapath (`datapath.v`) 
- Register file and data routing
- ALU integration
- Internal bus management
- **Location:** `rtl/core/cpu/datapath/`

#### Memory Subsystem
- `Memory.v` - Memory controller and address decoding
- `RAM.v` - Random Access Memory implementation
- `ROM.v` - Read-Only Memory implementation
- **Location:** `rtl/core/cpu/memory/`

#### Arithmetic Logic Unit (ALU)
- `ADSU16.v` - 16-bit Add/Subtract unit
- `ISNEG.v` - Negative detection
- `bus_nor16.v` - 16-bit NOR operation
- **Location:** `rtl/core/cpu/alu/`

#### Support Components
- Flip-flops, latches, multiplexers
- Decoders and bus selectors
- **Location:** `rtl/core/cpu/components/`

## Memory Map

The CPU supports a 16-bit address space (64KB) with the following organization:

```
0x0000 - 0x00FF: RAM (256 words)
0x0100 - 0x01FF: ROM (256 words) 
0x0200 - 0xFFFF: Extended address space (platform-dependent)
```

Memory selection is controlled by address bit 8:
- `mem_address[8] = 0`: RAM access
- `mem_address[8] = 1`: ROM access

## Integration Guide

### Platform Requirements

To integrate the NICNAC16 CPU core into a new platform:

1. **Clock Management**: Provide stable system clock
2. **Reset Circuit**: Implement proper reset sequencing
3. **Memory Implementation**: Connect to platform memory resources
4. **I/O Integration**: Connect console interface to platform I/O
5. **Control Signals**: Wire run/step/clear to platform controls

### Example Integration

```verilog
nicnac16_cpu cpu_core (
    // Clock and reset
    .clk(system_clk),
    .reset(system_reset),
    
    // Memory interface
    .mem_address(mem_addr),
    .mem_read(mem_data_out),
    .mem_write(mem_data_in),
    .en_mem_write(mem_we),
    
    // Platform controls
    .run(cpu_run),
    .step(cpu_step),
    .clear(cpu_clear),
    
    // Console interface
    .console_in(platform_console_input),
    .console_out(platform_console_output),
    .console_write(platform_console_write),
    
    // Status outputs
    .halt(cpu_halted),
    .PC(debug_pc),
    .AC(debug_ac),
    .IR(debug_ir)
);
```

## Build and Test

### Directory Structure
```
rtl/core/cpu/
├── README.md (this file)
├── nicnac16_cpu.v (top-level)
├── alu/ (arithmetic logic unit)
├── components/ (basic digital components)
├── control/ (instruction decode and timing)
├── datapath/ (registers and data routing)
└── memory/ (memory controllers)
```

### Testing
The CPU core includes comprehensive test suites:
- **Unit tests**: Located in `tb/unit/`
- **Integration tests**: Located in `tb/integration/cocotb/`
- **Platform tests**: Located in platform-specific directories

### Build Scripts
Use the provided build scripts for different toolchains:
- `tools/scripts/build_generic.sh` - Open-source tools (iverilog, yosys)
- Platform-specific build flows in `rtl/platform/`

## Supported Platforms

Current platform support:
- **Basys-3**: Digilent Basys-3 development board
- **Generic**: Hardware-independent simulation platform

Additional platforms can be added by implementing the platform interface in `rtl/platform/<platform_name>/`.

## Documentation

- **Architecture**: See `ARCHITECTURE.md` in project root
- **Instruction Set**: See `docs/instruction_set.md`
- **Platform Guides**: See `rtl/platform/<platform>/README.md`