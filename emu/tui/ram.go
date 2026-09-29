package tui

import (
	"emulator/hardware"
	"fmt"

	"github.com/charmbracelet/lipgloss"
)

var highlight = lipgloss.NewStyle().Background(lipgloss.Color("57")).Foreground(lipgloss.Color("229"))

func buildRamTable() string {
	aRangeBase := prevPC & 0xFFFFFF00

	table := "Ram"
	for i := (int)(aRangeBase); i < (int)(aRangeBase)+16; i++ {
		rowAddr := int(aRangeBase) + (i - int(aRangeBase))*0x10
		row := "\n"
		row += fmt.Sprintf("0x%08x", rowAddr)
		for j := range 16 {
			cell := fmt.Sprintf("%02x", hardware.Ram[rowAddr+j])
			if rowAddr+j >= int(prevPC) && rowAddr+j < int(prevPC)+4 {
				cell = highlight.Render(cell)
			}
			row += " " + cell
		}
		table += row
	}

	return table
}
