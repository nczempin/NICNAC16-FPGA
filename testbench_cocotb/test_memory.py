import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.binary import BinaryValue

@cocotb.test()
async def memory_test(dut):
    """Test the Memory module"""
    
    # Create a 10ns clock (20ns period, same as original #10 half period)
    cocotb.start_soon(Clock(dut.clk, 20, units="ns").start())
    
    # Initialize inputs
    dut.mem_address.value = 0
    dut.mem_write.value = 0
    dut.en_write.value = 0
    
    # Wait for first rising edge
    await RisingEdge(dut.clk)
    
    # Test sequence 1: Write to ROM area (should not work)
    dut.mem_write.value = 0xdead
    dut.mem_address.value = 0x01cd
    dut.en_write.value = 1
    
    await RisingEdge(dut.clk)
    dut.mem_write.value = 0xbeef
    dut.mem_address.value = 0x01ce
    dut.en_write.value = 1
    
    await RisingEdge(dut.clk)
    dut.en_write.value = 0
    
    await RisingEdge(dut.clk)
    dut.mem_address.value = 0x01cd
    
    await RisingEdge(dut.clk)
    
    # Test sequence 2: More ROM writes
    dut.mem_write.value = 0xdead
    dut.mem_address.value = 0x00cd
    dut.en_write.value = 1
    
    await RisingEdge(dut.clk)
    dut.mem_write.value = 0xbeef
    dut.mem_address.value = 0x00ce
    dut.en_write.value = 1
    
    await RisingEdge(dut.clk)
    dut.en_write.value = 0
    
    await RisingEdge(dut.clk)
    dut.mem_address.value = 0x00cd
    
    # Wait 2 clock cycles
    for _ in range(2):
        await RisingEdge(dut.clk)
    
    dut.mem_address.value = 0x01cd
    await RisingEdge(dut.clk)
    
    dut.mem_address.value = 0x0100
    
    # Read sequence from 0x0100 to 0x0107
    for i in range(8):
        await RisingEdge(dut.clk)
        dut.mem_address.value = dut.mem_address.value + 1
    
    await RisingEdge(dut.clk)
    
    # Write sequence: Write 0xc5c5 to addresses 0x0000-0x0007
    dut.mem_address.value = 0x0000
    dut.mem_write.value = 0xc5c5
    dut.en_write.value = 1
    
    for i in range(8):
        await RisingEdge(dut.clk)
        dut.mem_address.value = dut.mem_address.value + 1
    
    await RisingEdge(dut.clk)
    
    # Read sequence: Read from addresses 0x0000-0x0007
    dut.mem_address.value = 0x0000
    dut.mem_write.value = 0x1234
    dut.en_write.value = 0
    
    for i in range(8):
        await RisingEdge(dut.clk)
        # Log the output for verification
        cocotb.log.info(f"Address 0x{dut.mem_address.value:04x}: OUT = 0x{dut.mem_read.value:04x}")
        dut.mem_address.value = dut.mem_address.value + 1
