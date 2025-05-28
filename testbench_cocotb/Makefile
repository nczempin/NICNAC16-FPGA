# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/Memory.v $(PWD)/ROM.v $(PWD)/RAM.v

# Include CPU core modules for testing
VERILOG_SOURCES += $(PWD)/../cpu_core/memory/*.v
VERILOG_SOURCES += $(PWD)/../cpu_core/components/*.v
VERILOG_SOURCES += $(PWD)/../cpu_core/alu/*.v
VERILOG_SOURCES += $(PWD)/../cpu_core/control/*.v
VERILOG_SOURCES += $(PWD)/../cpu_core/datapath/*.v
VERILOG_SOURCES += $(PWD)/../cpu_core/nicnac16_cpu.v 

# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = Memory

# MODULE is the basename of the Python test file
MODULE = test_diagnostics

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
