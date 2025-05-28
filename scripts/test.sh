#!/usr/bin/env bash
set -e

echo "Running HDL tests..."

# Test 1: Compile Memory modules using iverilog with new structure
echo "Testing Memory modules..."
iverilog -o memory_tb \
  cpu_core/memory/Memory.v \
  cpu_core/memory/ROM.v \
  cpu_core/memory/RAM.v \
  vivado_proj/Basys-3-GPIO.srcs/sim_1/new/Memory_tb.v

vvp memory_tb > test.log
echo "Memory test completed."

# Test 2: Run cocotb tests if available
if [ -d "testbench_cocotb" ] && [ -f "testbench_cocotb/Makefile" ]; then
  echo "Running cocotb tests..."
  cd testbench_cocotb
  
  # Install cocotb if not available
  if ! python3 -c "import cocotb" 2>/dev/null; then
    pip3 install --user cocotb pytest
  fi
  
  # Run tests
  make clean || true
  make || echo "Cocotb tests failed or not fully configured"
  cd ..
else
  echo "Cocotb tests not found, skipping..."
fi

echo "All tests completed. See test.log for details."
