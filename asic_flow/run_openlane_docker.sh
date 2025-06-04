#!/usr/bin/env bash
# Docker-based OpenLane flow for NICNAC16 ASIC synthesis
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Running OpenLane ASIC flow for NICNAC16 using Docker"
echo "===================================================="

# Check if Docker is available
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is not installed or not in PATH" >&2
    exit 1
fi

# Create runs directory if it doesn't exist
mkdir -p "$SCRIPT_DIR/runs"

# Check for OpenLane Docker image
echo "Checking for OpenLane Docker image..."
if ! docker images | grep -q "efabless/openlane"; then
    echo "Pulling OpenLane Docker image..."
    docker pull efabless/openlane:latest
else
    echo "OpenLane Docker image found locally"
fi

# Set up design directory structure expected by OpenLane
DESIGN_NAME="nicnac16_cpu"
DESIGN_DIR="$SCRIPT_DIR/designs/$DESIGN_NAME"
mkdir -p "$DESIGN_DIR/src"

# Copy Verilog source files to design directory
echo "Copying design sources..."
cp "$PROJECT_ROOT/rtl/core/cpu/nicnac16_cpu.v" "$DESIGN_DIR/src/"
cp -r "$PROJECT_ROOT/rtl/core/cpu/"*.v "$DESIGN_DIR/src/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/rtl/core/cpu/alu/"*.v "$DESIGN_DIR/src/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/rtl/core/cpu/components/"*.v "$DESIGN_DIR/src/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/rtl/core/cpu/control/"*.v "$DESIGN_DIR/src/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/rtl/core/cpu/datapath/"*.v "$DESIGN_DIR/src/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/rtl/core/cpu/memory/"*.v "$DESIGN_DIR/src/" 2>/dev/null || true

# Copy config file
cp "$SCRIPT_DIR/config.tcl" "$DESIGN_DIR/"

# Create PDK volume directory
mkdir -p "$SCRIPT_DIR/pdk"

# Download PDK if not already present
if [ ! -d "$SCRIPT_DIR/pdk/sky130A" ]; then
    echo "Downloading Sky130 PDK..."
    docker run --rm \
        -v "$SCRIPT_DIR/pdk:/root/.volare" \
        efabless/openlane:latest \
        volare fetch bdc9412b3e468c102d01b7cf6337be06ec6e9c9a
fi

# Fix permissions for mounted directories
chmod -R 777 "$SCRIPT_DIR/designs" "$SCRIPT_DIR/runs" "$SCRIPT_DIR/pdk" 2>/dev/null || true

# Run OpenLane Docker container
echo "Starting OpenLane Docker container..."
docker run --rm \
    -v "$SCRIPT_DIR/designs:/openlane/designs" \
    -v "$SCRIPT_DIR/runs:/openlane/runs" \
    -v "$SCRIPT_DIR/pdk:/root/.volare" \
    efabless/openlane:latest \
    flow.tcl -design /openlane/designs/$DESIGN_NAME -tag run_$(date +%Y%m%d_%H%M%S)

# Check if run completed successfully
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ OpenLane flow completed successfully!"
    echo "Results are available in: $SCRIPT_DIR/runs/"
    
    # List generated files
    echo ""
    echo "Generated files:"
    find "$SCRIPT_DIR/runs" -type f -name "*.gds" -o -name "*.def" -o -name "*.lef" -o -name "*synthesis.v" | head -10
else
    echo ""
    echo "❌ OpenLane flow failed!"
    echo "Check logs in: $SCRIPT_DIR/runs/"
    exit 1
fi