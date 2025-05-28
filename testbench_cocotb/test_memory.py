# testbench_cocotb/test_memory.py
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import csv

@cocotb.test()
async def test_memory_basic(dut):
    # Your existing Memory_tb logic in Python
    # But add: CSV logging, multiple test patterns
    assert dut.my_signal_2.value[0] == 0, "my_signal_2[0] is not 0!"
