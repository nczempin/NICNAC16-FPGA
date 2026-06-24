# Smoke Tests

Multi-level smoke tests for the NICNAC16 CPU, validating design integrity from RTL through GDSII.

## Test Levels

### 1. RTL (Behavioral)

**File**: `rtl_smoke_tb.v`

Runs a basic instruction sequence (LDA, ADD, STA, JMP) in pure behavioral simulation using iverilog. Verifies:
- CPU starts and runs without hanging
- No X/Z values in accumulator (all signals properly driven)
- CPU does not halt unexpectedly

**Requires**: iverilog

### 2. Synthesis (Gate-level) — planned

Will simulate the same instruction sequence on the synthesized netlist from OpenLane, verifying that synthesis preserves functional behavior.

**Requires**: iverilog + Sky130 cell library + synthesized netlist

### 3. Place & Route (Timing) — planned

Will run SDF-annotated simulation with real wire delays to verify timing constraints are met.

**Requires**: iverilog + SDF extraction from OpenLane P&R

### 4. GDSII (Physical) — planned

Will run DRC and LVS verification on the final layout.

**Requires**: Magic or KLayout + GDSII from OpenLane

## Running

```sh
# Run all available smoke tests
bash tests/smoke/run_smoke_tests.sh

# Or compile and run RTL test manually
iverilog -g2012 -o rtl_smoke.out tests/smoke/rtl_smoke_tb.v rtl/core/cpu/*.v rtl/core/cpu/**/*.v
vvp rtl_smoke.out
```

## Adding New Tests

1. Create a new testbench in `tests/smoke/`
2. Add a `run_*_smoke()` function in `run_smoke_tests.sh`
3. Follow the PASS/FAIL/SKIP output convention
