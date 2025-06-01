# NICNAC16 File Lists for Modern Build System
# Organized by functional modules

# Utility modules (basic building blocks)
UTILS_SRC = \
	src/utils/FD.v \
	src/utils/FDCE.v \
	src/utils/FD16CE.v \
	src/utils/d_ff.v \
	src/utils/d_ff_sc.v \
	src/utils/ADSU16.v \
	src/utils/jk_ff.v \
	src/utils/mux16_2.v \
	src/utils/mux16_4.v \
	src/utils/bus_nor16.v \
	src/utils/ISNEG.v \
	src/utils/select1of4_16.v \
	src/utils/select_bus16_4.v \
	src/utils/Decoder4_16Bus.v \
	src/utils/timing_ring_counter.v \
	src/utils/Stages.v \
	src/utils/pulser.v \
	src/utils/reg5ce.v \
	src/utils/clock_divider.v \
	src/utils/multiplex_sseg.v \
	src/utils/multiplex_sseg_hex.v \
	src/utils/sseg_hex_decoder.v \
	src/utils/sseg_interface16b.v

# Memory subsystem
MEMORY_SRC = \
	src/memory/ROM.v \
	src/memory/RAM.v \
	src/memory/Memory.v

# CPU core (depends on utils and memory)
CPU_SRC = \
	src/cpu/datapath.v \
	src/cpu/control_unit.v \
	src/cpu/system_timing.v \
	src/cpu/dunc16.v

# I/O and system integration (depends on all above)
IO_SRC = \
	src/io/console.v \
	src/io/compi.v \
	src/io/NICNAC16.v

# Test benches
TESTBENCH_SRC = \
	src/testbench/Memory_tb.v \
	src/testbench/NICNAC16_tb.v

# Complete source list in dependency order
ALL_SRC = $(UTILS_SRC) $(MEMORY_SRC) $(CPU_SRC) $(IO_SRC)

# Test targets
MEMORY_TEST_SRC = $(MEMORY_SRC) src/testbench/Memory_tb.v
CPU_TEST_SRC = $(UTILS_SRC) $(MEMORY_SRC) $(CPU_SRC) src/testbench/dunc16_tb.v
SYSTEM_TEST_SRC = $(ALL_SRC) src/testbench/NICNAC16_tb.v