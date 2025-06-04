#!/usr/bin/env bash
# Setup script for Ubuntu/Debian systems to install NICNAC16-FPGA prerequisites
set -e

echo "Setting up NICNAC16-FPGA development environment on Ubuntu/Debian..."

# Update package list
sudo apt-get update -y

# Install basic build tools and Verilog simulator
sudo apt-get install -y \
    build-essential \
    make \
    g++ \
    cppcheck \
    iverilog \
    gtkwave \
    python3 \
    python3-pip \
    python3-venv

# Create and activate virtual environment for Python packages
echo "Creating virtual environment for Python packages..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# Install cocotb and related Python packages
echo "Installing Python packages for cocotb testing..."
pip install cocotb pytest

# Verify installations
echo "Verifying installations..."
for cmd in g++ make cppcheck iverilog gtkwave python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not found after installation" >&2
    exit 1
  fi
done

# Check Python packages
python3 -c "import cocotb; print(f'cocotb version: {cocotb.__version__}')" || {
    echo "Warning: cocotb not properly installed"
    exit 1
}

echo "✅ All prerequisites installed successfully!"
echo "To use cocotb for testing, activate the virtual environment first:"
echo "  source venv/bin/activate"
echo "Then you can run 'make' in the testbench_cocotb/ directory to run tests."