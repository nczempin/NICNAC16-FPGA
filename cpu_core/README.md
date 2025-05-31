# NICNAC16 CPU Core

This directory contains the hardware-independent NICNAC16 processor core modules.

## Directory Structure

- **`datapath/`** - CPU datapath implementation with registers, ALU, and data routing
- **`control/`** - Control unit, instruction decoding, and timing logic  
- **`memory/`** - Memory controller, ROM, and RAM modules
- **`alu/`** - Arithmetic Logic Unit components and operations
- **`components/`** - Basic building blocks (flip-flops, muxes, decoders, etc.)
- **`nicnac16_cpu.v`** - Top-level CPU core module with clean interface

## Usage

The `nicnac16_cpu.v` module provides a hardware-independent interface that can be instantiated by board-specific implementations:

```verilog
nicnac16_cpu cpu_core (
    .clk(board_clock),
    .rst(board_reset),
    .mem_addr(memory_address),
    .mem_data_in(memory_read_data),
    .mem_data_out(memory_write_data),
    .mem_write_enable(memory_write),
    .mem_read_enable(memory_read),
    .run(run_signal),
    .step(step_signal),
    .control_input(control_switches),
    .accumulator(acc_display),
    .program_counter(pc_display),
    .instruction_register(ir_display),
    .halted(halt_led),
    .cpu_state(state_display)
);
```

## Board Integration

Board-specific implementations should be placed in `boards/[board_name]/` and handle:
- Clock generation and management
- Reset circuitry  
- Memory mapping and external memory interfaces
- User interface (switches, buttons, displays)
- I/O pin assignments and constraints