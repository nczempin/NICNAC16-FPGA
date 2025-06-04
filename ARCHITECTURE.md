# NICNAC16 Architecture and Design Heritage

## Design Lineage

The NICNAC16 CPU follows a prestigious lineage of accumulator-based computers spanning six decades:

**DEC PDP-8 (1965)** → **TM-16/SC-16 educational machines (Langdon, 1982)** → **NICNAC16 modern implementation**

### Historical Foundation
- **PDP-8 Heritage**: Single accumulator, simple instruction set, memory-reference operations
- **Educational Adaptation**: 16-bit extension preserving architectural clarity
- **Modern Implementation**: FPGA/ASIC design demonstrating timeless principles

### Technical Specifications
- **16-bit accumulator architecture** with 4-bit opcodes
- **8/10 instructions implemented**: NOP, JMP, LDA, STA, ADD, BAZ, BAN, DIO
- **Missing**: BL (branch with link), RET (return) - the function calling mechanism
- **Four-phase execution**: t0, t1, t2, t3 timing control

## NICNAC16 Project Architecture

## Professional FPGA Design Organization

This project follows industry-standard practices for FPGA design organization:

### Core Design Structure

```
rtl/                    # RTL source code (Register Transfer Level)
├── core/              # Hardware-independent CPU core
│   ├── cpu/           # Main CPU modules
│   ├── alu/           # Arithmetic Logic Unit
│   ├── memory/        # Memory controllers
│   └── peripherals/   # Standard peripherals
├── platform/          # Platform-specific adaptations
│   ├── basys3/        # Digilent Basys-3 platform
│   ├── generic/       # Generic/simulation platform
│   └── template/      # Template for new platforms
└── common/            # Shared utilities and components

tb/                     # Testbenches
├── unit/              # Unit tests for individual modules
├── integration/       # Integration and system tests
└── formal/            # Formal verification (future)

tools/                  # Build and development tools
├── scripts/           # Build and automation scripts
├── constraints/       # Platform-specific timing/pin constraints
└── config/            # Tool configuration files

docs/                   # Documentation
├── architecture/      # System architecture docs
├── user_guide/        # User and programming guides
└── reference/         # Reference materials

examples/               # Example designs and demos
├── programs/          # Example NICNAC16 programs
└── tutorials/         # Step-by-step tutorials
```

### Key Principles

1. **Hardware Independence**: Core RTL is platform-agnostic
2. **Platform Abstraction**: Platform-specific code isolated in `platform/`
3. **Verification-Driven**: Comprehensive testbench structure
4. **Tool Agnostic**: Support for multiple toolchains (Vivado, Quartus, open-source)
5. **Documentation**: Architecture and usage docs alongside code

### Platform Support Pattern

Each platform provides:
- **Top-level wrapper** - Instantiates core + platform-specific I/O
- **Constraints** - Timing and pin assignment files
- **Build scripts** - Platform-specific synthesis/implementation
- **Documentation** - Platform-specific usage notes

### Core Interface Contract

The CPU core exposes a clean, documented interface that platforms must implement:
- Clock and reset management
- Memory interface
- Control/status signals
- Optional peripherals interface