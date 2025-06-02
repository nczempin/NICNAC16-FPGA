# NICNAC16 Project Architecture

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