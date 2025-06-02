#!/usr/bin/env bash
set -e

echo "ASIC Flow Setup Script"
echo "====================="
echo ""
echo "This script sets up OpenLane and SKY130 PDK for ASIC synthesis."
echo "Note: These tools are not required for basic FPGA development."
echo ""

# Check if running in CI environment
if [ -n "$CI" ]; then
  echo "Skipping ASIC setup in CI environment"
  exit 0
fi

# OpenLane installation instructions
echo "OpenLane Installation:"
echo "---------------------"
if ! command -v openlane >/dev/null 2>&1; then
  echo "OpenLane is not installed. Please follow the installation guide at:"
  echo "https://github.com/The-OpenROAD-Project/OpenLane"
  echo ""
else
  echo "✓ OpenLane is installed"
fi

# SKY130 PDK installation instructions
echo "SKY130 PDK Installation:"
echo "------------------------"
if [ ! -d "/usr/share/pdk/sky130A" ]; then
  echo "SKY130 PDK is not installed. Please follow the installation guide at:"
  echo "https://skywater-pdk.readthedocs.io/en/main/contents/getting-started.html"
  echo ""
else
  echo "✓ SKY130 PDK is installed at /usr/share/pdk/sky130A"
fi

echo ""
echo "For ASIC flow development, both OpenLane and SKY130 PDK must be installed."
echo "These are large downloads and require significant disk space."