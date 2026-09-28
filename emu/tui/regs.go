package tui

import (
	"emulator/hardware/cpu"
	"fmt"

	"github.com/charmbracelet/bubbles/table"
)

var regs = buildRegRows()

var regs1 = table.New(
	table.WithColumns([]table.Column{
		{Title: "use", Width: 3},
		{Title: "reg", Width: 3},
		{Title: "hex", Width: 10},
	}), table.WithRows(regs[0]),
	table.WithFocused(false),
	table.WithHeight(17),
)

var regs2 = table.New(
	table.WithColumns([]table.Column{
		{Title: "use", Width: 3},
		{Title: "reg", Width: 3},
		{Title: "hex", Width: 10},
	}), table.WithRows(regs[1]),
	table.WithFocused(false),
	table.WithHeight(17),
)


func buildRegRows() [2][]table.Row {
	rows := [2][]table.Row{}
	for i, v := range cpu.Regs {
		use := ""
		if cpu.A == (uint32)(i) && cpu.UsesA {
			use += "A"
		}
		if cpu.B == (uint32)(i) && cpu.UsesB {
			use += "B"
		}
		if cpu.Target == (uint32)(i) && cpu.UsesT {
			use += "T"
		}

		if i < len(cpu.Regs)/2 {
			rows[0] = append(rows[0], []string{use, fmt.Sprintf("$%02d", i), fmt.Sprintf("0x%08x", v)})
		} else {
			rows[1] = append(rows[1], []string{use, fmt.Sprintf("$%02d", i), fmt.Sprintf("0x%08x", v)})
		}
	}

	return rows
}
