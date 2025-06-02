# NICNAC16 Project Makefile
# Professional build system for FPGA development

.PHONY: all clean help test docs lint generic basys3 unit-test integration-test setup

# Default target
all: help

# Platform builds
generic:
	@echo "Building for generic platform (open-source tools)..."
	@tools/scripts/build_generic.sh generic

basys3:
	@echo "Building for Basys-3 platform..."
	@echo "Basys-3 build script not yet implemented. See issue #123 for details on the planned implementation."

# Testing
test:
	@echo "Running comprehensive test suite..."
	@cd tb/integration/cocotb && ./run_all_tests.sh

unit-test:
	@echo "Running unit tests..."
	@cd tb/unit && make

integration-test:
	@echo "Running integration tests..."
	@cd tb/integration/cocotb && make

# Development tools
lint:
	@echo "Running linting checks..."
	@if command -v verilator >/dev/null 2>&1; then \
		verilator --lint-only rtl/core/cpu/*.v rtl/core/alu/*.v rtl/core/memory/*.v rtl/common/*.v; \
	else \
		echo "Verilator not found, skipping lint"; \
	fi

docs:
	@echo "Generating documentation..."
	@echo "Documentation generation not yet implemented"

# Setup and maintenance
setup:
	@echo "Setting up development environment..."
	@tools/scripts/setup.sh

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf tb/*/sim_build/
	@rm -rf tb/*/*.log
	@rm -rf tb/*/*.vcd

# Help
help:
	@echo "NICNAC16 FPGA Project Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  generic     - Build for generic platform (simulation/open-source)"
	@echo "  basys3      - Build for Digilent Basys-3 board"
	@echo "  test        - Run all tests"
	@echo "  unit-test   - Run unit tests only"
	@echo "  integration-test - Run integration tests only"
	@echo "  lint        - Run code linting"
	@echo "  docs        - Generate documentation"
	@echo "  setup       - Set up development environment"
	@echo "  clean       - Clean build artifacts"
	@echo "  help        - Show this help message"
	@echo ""
	@echo "Example usage:"
	@echo "  make setup     # First time setup"
	@echo "  make test      # Run tests"
	@echo "  make generic   # Build for simulation"