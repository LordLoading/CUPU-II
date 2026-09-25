package tui

import (
	"emulator/hardware/cpu"
	"fmt"

	"github.com/charmbracelet/bubbles/table"
)

var regs = table.New(
	table.WithColumns([]table.Column{
		{Title: "reg", Width: 3},
		{Title: "hex", Width: 10},
	}), table.WithRows(buildRegRows()),
	table.WithFocused(false),
	table.WithHeight(32),
)

func buildRegRows() []table.Row {
	rows := make([]table.Row, 0)
	for i, v := range cpu.Regs {
		rows = append(rows, []string{fmt.Sprintf("$%02d", i), fmt.Sprintf("0x%08x", v)})
	}
	return rows
}
