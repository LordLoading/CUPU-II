# SPDX-License-Identifier: Apache-2.0
"""cocotb test for CUPU-II: runs the self-checking program from gen_test.py.

RTL runs the full program; gate level (GATES=yes) runs a smaller one, since the
netlist simulates much slower.
"""

import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

from check import check
from gen_test import DONE, KEY1, KEY2, WAIT_KEY, build, write_files

GATES = os.environ.get("GATES") == "yes"
CLK_NS = 40  # 25 MHz


def byte(sig):
    try:
        return int(sig.value)
    except ValueError:  # X or Z
        return None


async def wait_gpio(dut, value, timeout_ms):
    for _ in range(timeout_ms * 25):
        if byte(dut.uo_out) == value:
            return
        await ClockCycles(dut.clk, 1000)
    assert False, f"timeout waiting for gpio = {value:#04x} (gpio = {dut.uo_out.value})"


async def strobe_key(dut, ch):
    dut.ui_in.value = ch
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0x80 | ch
    await ClockCycles(dut.clk, 10)


@cocotb.test()
async def test_program(dut):
    prog = build(seed=1, quick=GATES)
    write_files(prog, os.getcwd())
    dut._log.info(f"{len(prog.words)} instructions, {len(prog.expected)} results")

    cocotb.start_soon(Clock(dut.clk, CLK_NS, unit="ns").start())
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.rst_n.value = 0
    dut.load.value = 0
    dut.dump.value = 0
    await ClockCycles(dut.clk, 5)
    dut.load.value = 1
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    await strobe_key(dut, KEY1)
    await wait_gpio(dut, WAIT_KEY, 1000)
    dut._log.info("CPU waits for a key")
    await Timer(200, unit="us")
    await strobe_key(dut, KEY2)

    await wait_gpio(dut, DONE, 1000)
    await Timer(100, unit="us")
    assert byte(dut.uo_out) == DONE, "CPU kept running after dividing by zero"

    dut.dump.value = 1
    await ClockCycles(dut.clk, 2)
    words = [line for line in open("ram_dump.hex").read().split() if not line.startswith("//")]
    with open("results.txt", "w") as f:
        f.write("\n".join(words) + "\n")
    assert check("expected.txt", "results.txt", dut._log.info), "wrong results"
