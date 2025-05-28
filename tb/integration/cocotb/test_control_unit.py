"""
Test suite for NICNAC16 control unit using cocotb
Tests instruction decoding and control signal generation
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.result import TestFailure

@cocotb.test()
async def test_instruction_decode(dut):
    """Test instruction decoding for all supported opcodes"""
    
    # Start clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)
    
    # Test cases: [opcode, expected_signal]
    test_cases = [
        (0x0, "I_NOP"),
        (0x1, "I_JMP"), 
        (0x2, "I_BL"),
        (0x3, "I_RET"),
        (0x4, "I_LDA"),
        (0x5, "I_STA"),
        (0x6, "I_ADD"),
        (0x7, "I_BAZ"),
        (0x8, "I_BAN"),
        (0xF, "I_DIO"),
    ]
    
    for opcode, signal_name in test_cases:
        # Set instruction register with opcode in upper 4 bits
        instruction = (opcode << 12) | 0x123  # Add some address bits
        dut.ir_in.value = (instruction >> 12) & 0xF  # Upper 4 bits to ir_in
        
        await Timer(1, units="ns")
        
        # Check that correct decode signal is asserted
        signal = getattr(dut, signal_name)
        assert signal.value == 1, f"Expected {signal_name} to be high for opcode 0x{opcode:X}"
        
        # Check that other decode signals are low
        for other_opcode, other_signal in test_cases:
            if other_signal != signal_name:
                other = getattr(dut, other_signal)
                assert other.value == 0, f"Expected {other_signal} to be low when {signal_name} is active"
        
        dut._log.info(f"✓ Opcode 0x{opcode:X} correctly decoded as {signal_name}")

@cocotb.test()
async def test_fetch_execute_cycle(dut):
    """Test fetch/execute state machine"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    
    # Enable run mode
    dut.RUN_MODE.value = 1
    dut.RUN_CY.value = 1
    
    await RisingEdge(dut.clk)
    
    # Should start in fetch
    assert dut.fetch.value == 1, "Should be in fetch state after reset"
    assert dut.execute.value == 0, "Should not be in execute state during fetch"
    
    await RisingEdge(dut.clk)
    
    # Should transition to execute  
    assert dut.fetch.value == 0, "Should not be in fetch state during execute"
    assert dut.execute.value == 1, "Should be in execute state"
    
    dut._log.info("✓ Fetch/Execute cycle working correctly")

@cocotb.test()
async def test_timing_states(dut):
    """Test timing state generation (t0, t1, t2, t3)"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    
    # Enable run mode
    dut.RUN_MODE.value = 1
    dut.RUN_CY.value = 1
    
    timing_states = ['t0', 't1', 't2', 't3']
    
    for i in range(8):  # Test a few cycles
        await RisingEdge(dut.clk)
        
        # Check that exactly one timing state is active
        active_states = []
        for state in timing_states:
            if getattr(dut, state).value == 1:
                active_states.append(state)
        
        assert len(active_states) == 1, f"Expected exactly one timing state active, got: {active_states}"
        
        expected_state = timing_states[i % 4]
        assert expected_state in active_states, f"Expected {expected_state} to be active"
        
        dut._log.info(f"✓ Cycle {i}: {expected_state} active")

@cocotb.test()
async def test_branch_conditions(dut):
    """Test branch condition evaluation"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    
    # Test BAZ (Branch if Accumulator Zero)
    dut.ir_in.value = 0x7  # BAZ opcode
    dut.AZ.value = 1  # Accumulator zero flag set
    await Timer(1, units="ns")
    
    assert dut.I_BAZ.value == 1, "BAZ instruction should be decoded"
    # Note: do_jump logic would need to be tested with full timing
    
    # Test BAN (Branch if Accumulator Negative)  
    dut.ir_in.value = 0x8  # BAN opcode
    dut.AN.value = 1  # Accumulator negative flag set
    await Timer(1, units="ns")
    
    assert dut.I_BAN.value == 1, "BAN instruction should be decoded"
    
    dut._log.info("✓ Branch condition decoding working")

@cocotb.test()
async def test_device_io_decode(dut):
    """Test DIO instruction decoding"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    
    # Test DIO instruction with device address and control fields
    dut.ir_in.value = 0xF  # DIO opcode
    
    # Set md_out to test device address and control extraction
    test_md = 0b1010100101  # DEVCTRL=10101, DEVADDRESS=00101, IO=1
    dut.md_out.value = test_md
    
    await Timer(1, units="ns")
    
    assert dut.I_DIO.value == 1, "DIO instruction should be decoded"
    
    # Check device address and control field extraction
    expected_devaddr = test_md & 0x1F  # Lower 5 bits
    expected_devctrl = (test_md >> 5) & 0x1F  # Bits 9:5
    expected_io = test_md & 0x1  # Bit 0
    
    assert dut.DEVADDRESS.value == expected_devaddr, f"DEVADDRESS should be {expected_devaddr}"
    assert dut.DEVCTRL.value == expected_devctrl, f"DEVCTRL should be {expected_devctrl}"
    
    dut._log.info(f"✓ DIO decode: DEVADDR=0x{expected_devaddr:02X}, DEVCTRL=0x{expected_devctrl:02X}, IO={expected_io}")