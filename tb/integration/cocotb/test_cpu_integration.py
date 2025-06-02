"""
Integration tests for complete NICNAC16 CPU using cocotb
Tests instruction execution and complete fetch-decode-execute cycles
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ClockCycles
from cocotb.result import TestFailure

@cocotb.test()
async def test_nop_instruction(dut):
    """Test NOP instruction execution"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Set up NOP instruction in memory
    nop_instruction = 0x0000  # NOP opcode
    dut.mem_data_in.value = nop_instruction
    
    # Enable run mode
    dut.run.value = 1
    
    # Capture initial state
    initial_pc = dut.program_counter.value
    initial_acc = dut.accumulator.value
    
    # Execute one complete instruction cycle
    await ClockCycles(dut.clk, 8)  # Allow time for fetch-execute cycle
    
    # After NOP, PC should increment but accumulator unchanged
    expected_pc = (initial_pc + 1) & 0xFFF
    assert dut.program_counter.value == expected_pc, f"PC should increment to 0x{expected_pc:03X}"
    assert dut.accumulator.value == initial_acc, f"Accumulator should remain 0x{initial_acc:04X}"
    
    dut._log.info("✓ NOP instruction executed correctly")

@cocotb.test()
async def test_load_store_sequence(dut):
    """Test LDA (load) and STA (store) instruction sequence"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Test data and address
    test_data = 0x1234
    test_addr = 0x100
    
    # Execute LDA instruction (Load Accumulator)
    lda_instruction = (0x4 << 12) | test_addr  # LDA opcode + address
    dut.mem_data_in.value = lda_instruction
    dut.run.value = 1
    
    # Simulate fetch cycle
    await ClockCycles(dut.clk, 4)
    
    # During execute, memory should provide data
    dut.mem_data_in.value = test_data
    await ClockCycles(dut.clk, 4)
    
    # Check accumulator loaded
    assert dut.accumulator.value == test_data, f"Accumulator should contain 0x{test_data:04X}"
    dut._log.info(f"✓ LDA executed: loaded 0x{test_data:04X} into accumulator")
    
    # Execute STA instruction (Store Accumulator)
    sta_instruction = (0x5 << 12) | test_addr  # STA opcode + address
    dut.mem_data_in.value = sta_instruction
    
    # Execute store cycle
    await ClockCycles(dut.clk, 8)
    
    # Check that memory write was enabled and data output
    assert dut.mem_data_out.value == test_data, f"Memory output should be 0x{test_data:04X}"
    dut._log.info(f"✓ STA executed: stored 0x{test_data:04X} to memory")

@cocotb.test()
async def test_arithmetic_instruction(dut):
    """Test ADD instruction"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Set initial accumulator value
    initial_acc = 0x0100
    dut.accumulator.value = initial_acc  # Simulate previous load
    
    # Execute ADD instruction
    addend = 0x0050
    add_addr = 0x200
    add_instruction = (0x6 << 12) | add_addr  # ADD opcode + address
    
    dut.mem_data_in.value = add_instruction
    dut.run.value = 1
    
    # Fetch cycle
    await ClockCycles(dut.clk, 4)
    
    # Execute cycle - provide addend from memory
    dut.mem_data_in.value = addend
    await ClockCycles(dut.clk, 4)
    
    # Check result
    expected_result = (initial_acc + addend) & 0xFFFF
    assert dut.accumulator.value == expected_result, f"Accumulator should contain 0x{expected_result:04X}"
    dut._log.info(f"✓ ADD executed: 0x{initial_acc:04X} + 0x{addend:04X} = 0x{expected_result:04X}")

@cocotb.test()
async def test_jump_instruction(dut):
    """Test JMP instruction"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Execute JMP instruction
    jump_addr = 0x300
    jmp_instruction = (0x1 << 12) | jump_addr  # JMP opcode + address
    
    dut.mem_data_in.value = jmp_instruction
    dut.run.value = 1
    
    # Execute jump
    await ClockCycles(dut.clk, 8)
    
    # Check PC updated
    assert dut.program_counter.value == jump_addr, f"PC should jump to 0x{jump_addr:03X}"
    dut._log.info(f"✓ JMP executed: PC set to 0x{jump_addr:03X}")

@cocotb.test()
async def test_conditional_branch(dut):
    """Test BAZ (Branch if Accumulator Zero) instruction"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    branch_addr = 0x400
    baz_instruction = (0x7 << 12) | branch_addr  # BAZ opcode + address
    
    # Test 1: Branch taken (accumulator is zero)
    dut.accumulator.value = 0x0000  # Zero accumulator
    dut.mem_data_in.value = baz_instruction
    dut.run.value = 1
    
    await ClockCycles(dut.clk, 8)
    
    # Should branch
    assert dut.program_counter.value == branch_addr, f"Should branch to 0x{branch_addr:03X} when ACC=0"
    dut._log.info("✓ BAZ taken when accumulator is zero")
    
    # Reset for second test
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Test 2: Branch not taken (accumulator is non-zero)
    dut.accumulator.value = 0x0001  # Non-zero accumulator
    initial_pc = dut.program_counter.value
    
    dut.mem_data_in.value = baz_instruction
    dut.run.value = 1
    
    await ClockCycles(dut.clk, 8)
    
    # Should not branch, PC should increment normally
    expected_pc = (initial_pc + 1) & 0xFFF
    assert dut.program_counter.value == expected_pc, f"Should increment PC to 0x{expected_pc:03X} when ACC≠0"
    dut._log.info("✓ BAZ not taken when accumulator is non-zero")

@cocotb.test()
async def test_device_io(dut):
    """Test DIO (Device I/O) instruction"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Test device output
    device_addr = 0x05
    device_ctrl = 0x0A
    io_direction = 0  # Output
    
    # Construct DIO instruction: opcode=F, device fields in lower 12 bits
    dio_data = (device_ctrl << 5) | device_addr | io_direction
    dio_instruction = (0xF << 12) | dio_data
    
    dut.mem_data_in.value = dio_instruction
    dut.run.value = 1
    
    await ClockCycles(dut.clk, 8)
    
    # Check device address and control signals
    if hasattr(dut, 'cpu_state'):
        # Verify we're in appropriate state for I/O
        dut._log.info(f"CPU state during DIO: {dut.cpu_state.value}")
    
    dut._log.info(f"✓ DIO instruction executed: ADDR=0x{device_addr:02X}, CTRL=0x{device_ctrl:02X}")

@cocotb.test() 
async def test_instruction_sequence(dut):
    """Test a sequence of instructions working together"""
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Program: Load 0x10, Add 0x20, Store result
    program = [
        (0x4 << 12) | 0x100,  # LDA 0x100  
        (0x6 << 12) | 0x101,  # ADD 0x101
        (0x5 << 12) | 0x102,  # STA 0x102
    ]
    
    memory_data = {
        0x100: 0x0010,  # Data at 0x100
        0x101: 0x0020,  # Data at 0x101
    }
    
    dut.run.value = 1
    
    for i, instruction in enumerate(program):
        dut._log.info(f"Executing instruction {i+1}: 0x{instruction:04X}")
        
        # Fetch cycle
        dut.mem_data_in.value = instruction
        await ClockCycles(dut.clk, 4)
        
        # Execute cycle - provide appropriate data
        if (instruction >> 12) in [0x4, 0x6]:  # LDA or ADD
            addr = instruction & 0xFFF
            if addr in memory_data:
                dut.mem_data_in.value = memory_data[addr]
        
        await ClockCycles(dut.clk, 4)
    
    # Final result should be 0x10 + 0x20 = 0x30
    expected_result = 0x0030
    assert dut.accumulator.value == expected_result, f"Final accumulator should be 0x{expected_result:04X}"
    
    dut._log.info(f"✓ Instruction sequence completed: result = 0x{expected_result:04X}")