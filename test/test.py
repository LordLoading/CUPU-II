# SPDX-License-Identifier: Apache-2.0
"""cocotb tests for CUPU-II: one small self-checking program per feature (see programs.py).

Gate level (GATES=yes) runs smaller versions of the same programs, since the netlist
simulates much slower.
"""

import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

import programs
from check import check
from cupu import DONE, KEY1, KEY2, WAIT_KEY, write_files

GATES = os.environ.get("GATES") == "yes"
CLK_NS = 50  # 20 MHz


def byte(sig):
    try:
        return int(sig.value)
    except ValueError:  # X or Z
        return None


async def strobe_key(dut, ch):
    dut.ui_in.value = ch
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0x80 | ch
    await ClockCycles(dut.clk, 10)


@cocotb.test()
@cocotb.parametrize(name=[cocotb.Param(n, name=n) for n in programs.PROGRAMS])
async def test_program(dut, name):
    prog = programs.build(name, quick=GATES)
    write_files(prog, os.getcwd())
    dut._log.info(f"{name}: {len(prog.words)} instructions, {len(prog.expected)} results")

    cocotb.start_soon(Clock(dut.clk, CLK_NS, unit="ns").start())
    dut.ena.value = 1
    dut.ui_in.value = 1 if prog.boot_flash else 0   # boot strap, sampled during reset
    dut.rst_n.value = 0
    dut.load.value = 0
    dut.dump.value = 0
    dut.load_ram.value = 0 if prog.boot_flash else 1   # flash boot: the code must come from the flash
    await ClockCycles(dut.clk, 5)
    dut.load.value = 1                     # clears the result area and loads prog.hex
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    await strobe_key(dut, KEY1)
    sent_key2 = False
    for _ in range(4000 * 20):             # up to 4 s of simulated time
        g = byte(dut.uo_out)
        if g == DONE:
            break
        if g == WAIT_KEY and not sent_key2:
            await Timer(200, unit="us")    # the CPU has to sit blocked meanwhile
            await strobe_key(dut, KEY2)
            sent_key2 = True
        await ClockCycles(dut.clk, 1000)
    assert byte(dut.uo_out) == DONE, f"program never finished (gpio = {dut.uo_out.value})"

    await Timer(100, unit="us")
    assert byte(dut.uo_out) == DONE, "CPU kept running after it should have halted"
    assert int(dut.flash_writes.value) == 0, "the CPU sent a write command to the flash"

    dut.dump.value = 1
    await ClockCycles(dut.clk, 2)
    with open("ram_dump.hex") as f:
        words = [w for line in f for w in line.split("//")[0].split()]
    with open("results.txt", "w") as f:
        f.write("\n".join(words) + "\n")
    assert check("expected.txt", "results.txt", dut._log.info), "wrong results"
