.RECIPEPREFIX := >
SHELL := /bin/bash
SOURCES := $(shell find vivado_proj -name '*.v')

.PHONY: all test lint package clean

all: lint test package

test:
>@if command -v iverilog >/dev/null 2>&1; then \
>iverilog -g2012 -o Memory_tb.out \
>vivado_proj/Basys-3-GPIO.srcs/sim_1/new/Memory_tb.v \
>vivado_proj/Basys-3-GPIO.srcs/sources_1/new/Memory.v \
>vivado_proj/Basys-3-GPIO.srcs/sources_1/new/ROM.v \
>vivado_proj/Basys-3-GPIO.srcs/sources_1/imports/NICNAC16-FPGA/RAM.v && \
>vvp Memory_tb.out; \
>else \
>echo "iverilog not installed"; \
>fi

lint:
>@if command -v verilator >/dev/null 2>&1; then \
>verilator --lint-only $(SOURCES); \
>elif command -v iverilog >/dev/null 2>&1; then \
>iverilog -tnull $(SOURCES); \
>else \
>echo "No HDL linter available"; \
>fi

package:
>bash scripts/build.sh

clean:
>rm -f Memory_tb.out build_artifacts.zip
