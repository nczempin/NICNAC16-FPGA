#!/usr/bin/env bash
# Generic build script for open-source tools (iverilog, yosys, etc.)

set -e

PLATFORM=${1:-generic}
TOP_MODULE="nicnac16_${PLATFORM}"

echo "Building NICNAC16 for platform: $PLATFORM"

# Source directories
RTL_CORE="rtl/core"
RTL_PLATFORM="rtl/platform/$PLATFORM"
RTL_COMMON="rtl/common"

# Output directory
BUILD_DIR="build/$PLATFORM"
mkdir -p "$BUILD_DIR"

# Synthesis with yosys (if available)
if command -v yosys >/dev/null 2>&1; then
    echo "Running synthesis with yosys..."
    yosys -p "
        read_verilog $RTL_CORE/cpu/*.v
        read_verilog $RTL_CORE/alu/*.v  
        read_verilog $RTL_CORE/memory/*.v
        read_verilog $RTL_COMMON/*.v
        read_verilog $RTL_PLATFORM/*.v
        synth -top $TOP_MODULE
        write_verilog $BUILD_DIR/${TOP_MODULE}_synth.v
        stat
    "
else
    echo "yosys not found, skipping synthesis"
fi

# Simulation build with iverilog
echo "Building simulation model with iverilog..."
iverilog -o "$BUILD_DIR/${TOP_MODULE}_sim" \
    -I "$RTL_CORE/cpu" \
    -I "$RTL_CORE/alu" \
    -I "$RTL_CORE/memory" \
    -I "$RTL_COMMON" \
    "$RTL_CORE"/cpu/*.v \
    "$RTL_CORE"/alu/*.v \
    "$RTL_CORE"/memory/*.v \
    "$RTL_COMMON"/*.v \
    "$RTL_PLATFORM"/*.v

echo "Build completed: $BUILD_DIR"
echo "To simulate: vvp $BUILD_DIR/${TOP_MODULE}_sim"