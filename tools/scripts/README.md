# Build Scripts

Scripts for building, testing, and setting up the NICNAC16 development environment.

## Scripts

### `setup.sh`

First-time environment setup. Installs all required tools for both FPGA and ASIC workflows:

- **FPGA tools**: g++, make, cppcheck, iverilog, gtkwave, python3
- **ASIC tools**: Docker, OpenLane Docker image
- **Python environment**: Creates `venv/` with cocotb and pytest

```sh
./tools/scripts/setup.sh
```

Requires `sudo` for package installation. Run once after cloning the repository.

### `build.sh`

Creates a `build_artifacts.zip` containing documentation and schematics. Optionally runs HDL tests.

```sh
# Package artifacts only
bash tools/scripts/build.sh

# Package artifacts and run tests
RUN_TESTS=1 bash tools/scripts/build.sh
```

### `build_generic.sh`

Builds the CPU design using open-source tools (yosys for synthesis, iverilog for simulation). Targets the hardware-independent `rtl/` source tree.

```sh
# Build for generic (simulation) platform
bash tools/scripts/build_generic.sh generic
```

Reads sources from `rtl/core/`, `rtl/common/`, and `rtl/platform/<platform>/`. Outputs to `build/<platform>/`.

Requires: iverilog (simulation), yosys (synthesis, optional).

### `test.sh`

Runs the HDL test suite:

1. **Memory testbench**: Compiles and simulates `Memory_tb.v` with iverilog, output to `test.log`
2. **cocotb tests**: Runs Python-based integration tests if `tb/integration/cocotb/` is configured

```sh
bash tools/scripts/test.sh
```

Requires: iverilog. Gracefully skips if not installed.

## Makefile Targets

The project Makefile (`Makefile` in project root) wraps these scripts:

| Target | Description | Script |
|--------|-------------|--------|
| `make` | Lint, test, package | (all below) |
| `make test` | Run Memory testbench | Direct iverilog invocation |
| `make lint` | Lint HDL sources | verilator or iverilog |
| `make package` | Create build artifacts zip | `build.sh` |
| `make setup` | Install dev environment | `setup.sh` |
| `make generic` | Build with open-source tools | `build_generic.sh` |
| `make clean` | Remove generated files | (inline) |

## Platform-Specific Notes

### FPGA (Basys-3)

For Vivado-based FPGA synthesis and deployment, open `vivado_proj/Basys-3-GPIO.xpr` directly in Vivado. The Makefile and scripts handle simulation and linting only.

### ASIC (OpenLane + Sky130)

For RTL-to-GDSII synthesis:

```sh
./run_openlane_docker.sh    # Run OpenLane in Docker
./view_chip.sh              # View synthesized layout in KLayout
```

See `asic_flow/` for ASIC-specific configuration and design files.
