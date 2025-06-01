#!/usr/bin/env bash
set -e

missing=()

# Ensure git submodules (if any) are initialized
git submodule update --init --recursive

# Commands required for the FPGA and ASIC flows
required_cmds=(g++ make cppcheck iverilog openlane)

# Check for command line tools
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

# Check for the SKY130 PDK installation
if [ ! -d "/usr/share/pdk/sky130A" ]; then
  missing+=(sky130-pdk)
fi

if [[ ${#missing[@]} -ne 0 ]]; then
  echo "Installing packages: ${missing[*]}"
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
