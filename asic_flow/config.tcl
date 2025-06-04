# OpenLane configuration for NICNAC16 CPU ASIC flow

# Design Information
set ::env(DESIGN_NAME) "nicnac16_cpu"
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "20.0"

# PDK Configuration
set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"
set ::env(PDK_ROOT) "/root/.volare/volare/sky130/versions/bdc9412b3e468c102d01b7cf6337be06ec6e9c9a"

# Synthesis Configuration
set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(SYNTH_BUFFERING) 1
set ::env(SYNTH_SIZING) 1

# Floorplan Configuration
set ::env(FP_CORE_UTIL) 35
set ::env(FP_ASPECT_RATIO) 1
set ::env(FP_PDN_VPITCH) 25.0
set ::env(FP_PDN_HPITCH) 25.0

# Placement Configuration
set ::env(PL_TARGET_DENSITY) 0.5
set ::env(PL_BASIC_PLACEMENT) 1

# Clock Tree Synthesis
set ::env(CTS_TARGET_SKEW) 200

# Routing Configuration
set ::env(RT_MAX_LAYER) "met4"

# DRC/LVS Configuration
set ::env(RUN_KLAYOUT_XOR) 0
set ::env(RUN_KLAYOUT_DRC) 1

# Output Configuration
set ::env(MAGIC_ZEROIZE_ORIGIN) 0
set ::env(MAGIC_WRITE_FULL_LEF) 1
