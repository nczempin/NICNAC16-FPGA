#!/usr/bin/env bash
# Run NICNAC16 smoke tests at available design levels
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PASS=0
FAIL=0
SKIP=0

run_rtl_smoke() {
    echo "=== RTL Smoke Test ==="
    if ! command -v iverilog >/dev/null 2>&1; then
        echo "SKIP: iverilog not installed"
        SKIP=$((SKIP + 1))
        return
    fi

    local RTL_DIR="$PROJECT_ROOT/rtl/core/cpu"
    local OUT="$SCRIPT_DIR/rtl_smoke_tb.out"

    # Compile: testbench + CPU core modules
    iverilog -g2012 -o "$OUT" \
        -I "$RTL_DIR" \
        "$SCRIPT_DIR/rtl_smoke_tb.v" \
        "$RTL_DIR/nicnac16_cpu.v" \
        "$RTL_DIR/datapath/datapath.v" \
        "$RTL_DIR/control/control_unit.v" \
        "$RTL_DIR/control/system_timing.v" \
        "$RTL_DIR/control/Stages.v" \
        "$RTL_DIR/alu/"*.v \
        "$RTL_DIR/components/"*.v \
        2>&1

    # Run simulation
    local result
    result=$(vvp "$OUT" 2>&1)
    echo "$result"

    if echo "$result" | grep -q "^PASS:"; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi

    rm -f "$OUT" rtl_smoke.vcd
}

run_synthesis_smoke() {
    echo ""
    echo "=== Synthesis Smoke Test ==="
    # Gate-level simulation requires synthesized netlist from OpenLane
    local SYNTH="$PROJECT_ROOT/asic_flow/results/synthesis/nicnac16_cpu.v"
    if [ ! -f "$SYNTH" ]; then
        echo "SKIP: No synthesized netlist found at $SYNTH"
        echo "  Run OpenLane synthesis first: ./run_openlane_docker.sh"
        SKIP=$((SKIP + 1))
        return
    fi
    echo "SKIP: Gate-level simulation not yet implemented"
    SKIP=$((SKIP + 1))
}

run_layout_smoke() {
    echo ""
    echo "=== Place & Route Smoke Test ==="
    echo "SKIP: SDF-annotated simulation not yet implemented"
    SKIP=$((SKIP + 1))
}

run_gdsii_smoke() {
    echo ""
    echo "=== GDSII Verification ==="
    local GDS="$PROJECT_ROOT/asic_flow/results/final/gds/nicnac16_cpu.gds"
    if [ ! -f "$GDS" ]; then
        echo "SKIP: No GDSII file found at $GDS"
        SKIP=$((SKIP + 1))
        return
    fi
    echo "SKIP: DRC/LVS verification not yet implemented"
    SKIP=$((SKIP + 1))
}

# Run all available smoke tests
echo "NICNAC16 Multi-Level Smoke Tests"
echo "================================"
echo ""

run_rtl_smoke
run_synthesis_smoke
run_layout_smoke
run_gdsii_smoke

echo ""
echo "================================"
echo "Results: $PASS passed, $FAIL failed, $SKIP skipped"

if [ $FAIL -gt 0 ]; then
    exit 1
fi
