import cocotb
from cocotb.triggers import Timer

async def test(dut):
    for _ in range(10):
        dut.clk.value = 0
        await Timer (1, unit="ns")
        dut.clk.value = 1
        await Timer (1, unit="ns")

