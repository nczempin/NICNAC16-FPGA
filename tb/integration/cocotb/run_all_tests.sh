#!/usr/bin/env bash
# Script to run all cocotb tests for NICNAC16 CPU

set -e

echo "Running comprehensive NICNAC16 CPU tests..."

# Test memory subsystem
echo "=== Testing Memory Subsystem ==="
make -f Makefile clean || true
make -f Makefile

# Test control unit
echo "=== Testing Control Unit ==="
make -f Makefile.control_unit clean || true
make -f Makefile.control_unit

# Test datapath
echo "=== Testing Datapath ==="  
make -f Makefile.datapath clean || true
make -f Makefile.datapath

# Test complete CPU integration
echo "=== Testing CPU Integration ==="
make -f Makefile.cpu clean || true
make -f Makefile.cpu

echo "All tests completed successfully!"