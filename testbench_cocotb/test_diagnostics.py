import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def debug_signals(dut):
    """Debug test to see what signals are available"""
    
    # Print the top-level module name
    cocotb.log.info(f"Top-level module: {dut._name}")
    
    # Print all available signals/ports
    cocotb.log.info("Available signals:")
    for name in dir(dut):
        if not name.startswith('_'):
            try:
                signal = getattr(dut, name)
                cocotb.log.info(f"  {name}: {type(signal)}")
            except:
                cocotb.log.info(f"  {name}: (error accessing)")
    
    # If there's a Memory module instance, check its signals too
    try:
        if hasattr(dut, 'uut'):
            cocotb.log.info("UUT signals:")
            for name in dir(dut.uut):
                if not name.startswith('_'):
                    try:
                        signal = getattr(dut.uut, name)
                        cocotb.log.info(f"  uut.{name}: {type(signal)}")
                    except:
                        cocotb.log.info(f"  uut.{name}: (error accessing)")
    except:
        pass
