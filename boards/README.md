# Board-Specific Implementations

This directory contains board-specific adaptations of the NICNAC16 CPU.

## Directory Structure

- **`basys3/`** - Digilent Basys-3 FPGA board implementation
  - `top/` - Top-level modules and pin assignments
  - `display/` - 7-segment display controllers and decoders
  - `input/` - Button, switch, and rotary encoder interfaces
  - `timing/` - Board-specific clock management

## Adding New Board Support

To add support for a new FPGA board:

1. Create `boards/[board_name]/` directory structure
2. Implement top-level module that instantiates `nicnac16_cpu`
3. Add board-specific I/O handling and pin constraints
4. Create appropriate clock management for the board
5. Add build scripts and documentation

## Current Boards

### Basys-3
- **Target**: Digilent Basys-3 Artix-7 FPGA board
- **Features**: 4-digit 7-segment display, 16 switches, 5 buttons, 16 LEDs, PMOD connectors
- **Top module**: `NICNAC16.v`
- **Constraints**: See `vivado_proj/` for Vivado project files