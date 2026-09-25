package tui

import (
	"github.com/charmbracelet/bubbles/table"
	tea "github.com/charmbracelet/bubbletea"
)

var targetCyclesPerSecond uint32 = 1e+2

type model struct {
	regTable table.Model
}

func NewModel() model {
	return model{
		regTable: regs,
	}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	if keyMsg, ok := msg.(tea.KeyMsg); ok {
		switch keyMsg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m model) View() string {
	return m.regTable.View()
}

// func (m model) View() string {
// 	info := fmt.Sprintf("Clock: %.0f Hz  |  PC: 0x%08x  |  IR: 0x%08x  |  Press 'c' to set clock  |  Press 'k' to keyboard", m.measuredFreq, cpu.ProgramCounter, cpu.InstReg)
// 	clockRow := lipgloss.JoinHorizontal(lipgloss.Top, m.clockInput.View())
// 	keyboardRow := lipgloss.JoinHorizontal(lipgloss.Top, m.keyboardInput.View())
// 	return lipgloss.JoinVertical(lipgloss.Top, info, clockRow, keyboardRow, lipgloss.JoinHorizontal(lipgloss.Top, m.regTable.View(), ramView()))
// }
//
// func Run() error {
// 	p := tea.NewProgram(initialModel(), tea.WithAltScreen())
// 	_, err := p.Run()
// 	return err
// }
