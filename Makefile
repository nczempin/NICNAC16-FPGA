# Modern NICNAC16 Build System
# Uses OSS EDA tools: iverilog, verilator, yosys
SHELL := /bin/bash
.RECIPEPREFIX := >

# Include file lists for organized src/ structure
-include src/filelist.mk

# Legacy sources from vivado_proj
VIVADO_SOURCES := $(shell find vivado_proj -name '*.v' 2>/dev/null)

# Tool settings
IVERILOG_FLAGS = -g2012 -Wall
VERILATOR_FLAGS = --lint-only --Wall -Wno-UNOPTFLAT

# Build outputs
BUILD_DIR = build
SIM_DIR = $(BUILD_DIR)/sim

.PHONY: all test lint package clean help test-memory

all: lint test package

help:
>@echo "NICNAC16 Build System"
>@echo "Targets:"
>@echo "  all          - Run lint, test, and package"
>@echo "  test         - Test memory subsystem"
>@echo "  test-memory  - Test memory (modern src/)"
>@echo "  lint         - Lint HDL sources"
>@echo "  package      - Create build artifacts"
>@echo "  clean        - Remove build artifacts"

# Create build directories
$(BUILD_DIR) $(SIM_DIR):
>mkdir -p $@

# Modern memory test using src/ structure
test-memory: $(SIM_DIR)/memory_tb | $(SIM_DIR)
>@echo "=== Testing Memory Subsystem (Modern) ==="
>cd $(SIM_DIR) && vvp memory_tb
>@echo "✓ Memory test passed"

$(SIM_DIR)/memory_tb: | $(SIM_DIR)
>@if [ -f src/testbench/Memory_tb.v ] && [ -n "$(MEMORY_TEST_SRC)" ]; then \
>  iverilog $(IVERILOG_FLAGS) -o $@ $(MEMORY_TEST_SRC); \
>else \
>  echo "Modern src/ structure not available, using legacy path"; \
>  iverilog $(IVERILOG_FLAGS) -o $@ \
>    vivado_proj/Basys-3-GPIO.srcs/sim_1/new/Memory_tb.v \
>    vivado_proj/Basys-3-GPIO.srcs/sources_1/new/Memory.v \
>    vivado_proj/Basys-3-GPIO.srcs/sources_1/new/ROM.v \
>    vivado_proj/Basys-3-GPIO.srcs/sources_1/imports/NICNAC16-FPGA/RAM.v; \
>fi

# Legacy memory test for compatibility
test: Memory_tb.out
>@echo "=== Testing Memory Subsystem (Legacy) ==="
>@if command -v iverilog >/dev/null 2>&1; then \
>  vvp Memory_tb.out; \
>else \
>  echo "iverilog not installed"; \
>fi

Memory_tb.out:
>@if command -v iverilog >/dev/null 2>&1; then \
>  iverilog $(IVERILOG_FLAGS) -o $@ \
>    vivado_proj/Basys-3-GPIO.srcs/sim_1/new/Memory_tb.v \
>    vivado_proj/Basys-3-GPIO.srcs/sources_1/new/Memory.v \
>    vivado_proj/Basys-3-GPIO.srcs/sources_1/new/ROM.v \
>    vivado_proj/Basys-3-GPIO.srcs/sources_1/imports/NICNAC16-FPGA/RAM.v; \
>else \
>  echo "iverilog not installed"; \
>fi

lint:
>@if [ -n "$(MEMORY_SRC)" ] && [ -n "$(UTILS_SRC)" ]; then \
>  echo "=== Linting Modern Sources ==="; \
>  if command -v verilator >/dev/null 2>&1; then \
>    verilator $(VERILATOR_FLAGS) $(UTILS_SRC) $(MEMORY_SRC); \
>  elif command -v iverilog >/dev/null 2>&1; then \
>    iverilog -tnull $(UTILS_SRC) $(MEMORY_SRC); \
>  fi; \
>elif [ -n "$(VIVADO_SOURCES)" ]; then \
>  echo "=== Linting Legacy Sources ==="; \
>  if command -v verilator >/dev/null 2>&1; then \
>    verilator $(VERILATOR_FLAGS) $(VIVADO_SOURCES); \
>  elif command -v iverilog >/dev/null 2>&1; then \
>    iverilog -tnull $(VIVADO_SOURCES); \
>  fi; \
>else \
>  echo "No HDL sources found"; \
>fi

package:
>bash scripts/build.sh

clean:
>rm -f Memory_tb.out *.out *.vcd *.log
>rm -rf $(BUILD_DIR)
>rm -f build_artifacts.zip
