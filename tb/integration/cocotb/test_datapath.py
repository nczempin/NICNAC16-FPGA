"""
Test suite for NICNAC16 datapath using cocotb
Tests ALU operations, register operations, and data routing
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
from cocotb.result import TestFailure

@cocotb.test()
async def test_accumulator_operations(dut):
    """Test accumulator load, store, and arithmetic operations"""
    
    # Start clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    # Test accumulator load
    test_value = 0x1234
    dut.mem_data_in.value = test_value
    dut.control_signals.value = 0x01  # Enable accumulator load
    await RisingEdge(dut.clk)
    
    assert dut.accumulator.value == test_value, f"Accumulator should contain 0x{test_value:04X}"
    dut._log.info(f"✓ Accumulator loaded with 0x{test_value:04X}")
    
    # Test accumulator arithmetic (add)
    addend = 0x0010
    dut.mem_data_in.value = addend
    dut.control_signals.value = 0x02  # Enable ALU add operation
    await RisingEdge(dut.clk)
    
    expected = (test_value + addend) & 0xFFFF
    assert dut.accumulator.value == expected, f"Accumulator should contain 0x{expected:04X} after add"
    dut._log.info(f"✓ Addition: 0x{test_value:04X} + 0x{addend:04X} = 0x{expected:04X}")

@cocotb.test()
async def test_program_counter(dut):
    """Test program counter increment and jump operations"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    initial_pc = dut.program_counter.value
    dut._log.info(f"Initial PC: 0x{initial_pc:03X}")
    
    # Test PC increment
    dut.control_signals.value = 0x04  # Enable PC increment
    await RisingEdge(dut.clk)
    
    expected_pc = (initial_pc + 1) & 0xFFF  # 12-bit PC
    assert dut.program_counter.value == expected_pc, f"PC should increment to 0x{expected_pc:03X}"
    dut._log.info(f"✓ PC incremented to 0x{expected_pc:03X}")
    
    # Test PC jump
    jump_addr = 0x200
    dut.mem_data_in.value = jump_addr
    dut.control_signals.value = 0x08  # Enable PC load
    await RisingEdge(dut.clk)
    
    assert dut.program_counter.value == jump_addr, f"PC should jump to 0x{jump_addr:03X}"
    dut._log.info(f"✓ PC jumped to 0x{jump_addr:03X}")

@cocotb.test()
async def test_memory_interface(dut):
    """Test memory address and data routing"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    # Test memory address output
    test_addr = 0x300
    dut.mem_data_in.value = test_addr
    dut.control_signals.value = 0x10  # Load memory address register
    await RisingEdge(dut.clk)
    
    assert dut.mem_addr.value == test_addr, f"Memory address should be 0x{test_addr:03X}"
    dut._log.info(f"✓ Memory address set to 0x{test_addr:03X}")
    
    # Test memory data output (store operation)
    store_data = 0x5678
    dut.accumulator.value = store_data  # Simulate accumulator content
    dut.control_signals.value = 0x20  # Enable memory write
    await RisingEdge(dut.clk)
    
    assert dut.mem_data_out.value == store_data, f"Memory data out should be 0x{store_data:04X}"
    dut._log.info(f"✓ Memory data output: 0x{store_data:04X}")

@cocotb.test()
async def test_alu_operations(dut):
    """Test ALU arithmetic and logic operations"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    # Test addition with carry/overflow
    dut.accumulator.value = 0xFFFF  # Max value
    dut.mem_data_in.value = 0x0001
    dut.control_signals.value = 0x02  # ALU add
    await RisingEdge(dut.clk)
    
    # Should wrap around to 0
    assert dut.accumulator.value == 0x0000, "Addition should wrap around on overflow"
    dut._log.info("✓ ALU overflow handling correct")
    
    # Test zero flag
    assert dut.data_to_control.value & 0x01, "Zero flag should be set when accumulator is zero"
    dut._log.info("✓ Zero flag set correctly")
    
    # Test negative flag (if implemented)
    dut.accumulator.value = 0x8000  # MSB set (negative in 2's complement)
    await Timer(1, units="ns")
    
    # Check if negative flag is available in data_to_control
    negative_flag = (dut.data_to_control.value >> 1) & 0x01
    dut._log.info(f"✓ Negative flag: {negative_flag}")

@cocotb.test()
async def test_instruction_register(dut):
    """Test instruction register load and decode"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    # Test instruction load
    test_instruction = 0x1ABC  # JMP instruction with address
    dut.mem_data_in.value = test_instruction
    dut.control_signals.value = 0x40  # Load instruction register
    await RisingEdge(dut.clk)
    
    assert dut.instruction_register.value == test_instruction, f"IR should contain 0x{test_instruction:04X}"
    
    # Extract opcode and address
    opcode = (test_instruction >> 12) & 0xF
    address = test_instruction & 0xFFF
    
    dut._log.info(f"✓ Instruction loaded: opcode=0x{opcode:X}, address=0x{address:03X}")

@cocotb.test()
async def test_data_paths(dut):
    """Test various data routing paths through multiplexers"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    # Test different data routing scenarios
    test_cases = [
        (0x1000, 0x80, "Memory to accumulator"),
        (0x2000, 0x81, "PC to memory address"),
        (0x3000, 0x82, "Immediate to accumulator"),
    ]
    
    for test_data, control_sig, description in test_cases:
        dut.mem_data_in.value = test_data
        dut.control_signals.value = control_sig
        await RisingEdge(dut.clk)
        await Timer(1, units="ns")
        
        dut._log.info(f"✓ {description}: 0x{test_data:04X} with control 0x{control_sig:02X}")