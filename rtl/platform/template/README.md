# Platform Template

Use this template to create support for new FPGA development boards.

## Files to Create

1. **Top-level wrapper** (`nicnac16_[platform].v`)
   - Instantiate the CPU core
   - Connect platform-specific I/O
   - Handle clock/reset distribution

2. **Constraints file** (`[platform]_constraints.xdc/.sdc/.tcl`)
   - Pin assignments
   - Timing constraints
   - I/O standards

3. **Build script** (`build_[platform].sh/.tcl`)
   - Synthesis and implementation flow
   - Tool-specific commands

4. **Documentation** (`[platform]_guide.md`)
   - Board-specific setup instructions
   - Feature descriptions
   - Known limitations

## Platform Interface Requirements

Your platform wrapper must:
- Provide stable clock and reset to CPU core
- Implement memory interface (RAM/ROM or external)
- Handle control inputs (run, step, switches)
- Display CPU status (LEDs, 7-segment, etc.)
- Optional: Additional peripherals

## Example Platforms

- **`basys3/`** - Digilent Basys-3 with 7-segment displays
- **`generic/`** - Simulation-friendly minimal wrapper