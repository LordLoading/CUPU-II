package tui

import (
	"emulator/hardware"
	"fmt"

	"github.com/charmbracelet/bubbles/table"
)

var ramTable = table.New(
	table.WithColumns([]table.Column{
		{Title: "Ram"},
		{}, {}, {}, {},
		{}, {}, {}, {},
		{}, {}, {}, {},
		{}, {}, {}, {},
	}),
	table.WithFocused(false),
	table.WithHeight(17),
	table.WithRows(buildRamRows()),
)

func buildRamRows() []table.Row {
	rows := []table.Row{}
	for i := range 16 {
		row := table.Row{}
		row = append(row, fmt.Sprintf("0x%08x", i*0x10))
		for j := range 16 {
			row = append(row, fmt.Sprintf("0x%02x", hardware.Ram[i*0x10+j]))
		}
		rows[i] = row
	}

	return rows
}
