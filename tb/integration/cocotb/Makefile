# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Local copies removed - using RTL sources only

# Include CPU core modules for testing
VERILOG_SOURCES += $(PWD)/../../../rtl/core/cpu/memory/*.v
VERILOG_SOURCES += $(PWD)/../../../rtl/core/cpu/components/*.v
VERILOG_SOURCES += $(PWD)/../../../rtl/core/cpu/alu/*.v
VERILOG_SOURCES += $(PWD)/../../../rtl/core/cpu/control/*.v
VERILOG_SOURCES += $(PWD)/../../../rtl/core/cpu/datapath/*.v
VERILOG_SOURCES += $(PWD)/../../../rtl/core/cpu/nicnac16_cpu.v 

# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = Memory

# MODULE is the basename of the Python test file
MODULE = test_memory

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
