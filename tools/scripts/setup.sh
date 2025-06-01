#!/usr/bin/env bash
set -e

# Initialise submodules in case OpenLane or the PDK are provided that way
git submodule update --init --recursive || true

# Commands required for the FPGA and ASIC flows
required_cmds=(g++ make cppcheck iverilog openlane)

# Track packages that need installation
missing_pkgs=()

# Check for command line tools
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing_pkgs+=("$cmd")
  fi
done

# Check for the SKY130 PDK installation
if [ ! -d "/usr/share/pdk/sky130A" ]; then
  missing_pkgs+=(sky130-pdk)
fi

# Attempt package installation but don't fail if packages are unavailable
if [[ ${#missing_pkgs[@]} -ne 0 ]]; then
  echo "Installing packages: ${missing_pkgs[*]}"
  sudo apt-get update -y || true
  sudo apt-get install -y g++ make cppcheck iverilog openlane sky130-pdk || true
fi

# Verify command line tools
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not installed" >&2
    exit 1
  fi
done

# Verify SKY130 PDK directory
if [ ! -d "/usr/share/pdk/sky130A" ]; then
  echo "Error: SKY130 PDK not installed" >&2
  exit 1
fi

echo "All required packages are installed."
