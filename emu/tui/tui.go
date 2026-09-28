package tui

import (
	"emulator/hardware/cpu"
	"time"

	"github.com/charmbracelet/bubbles/table"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var targetCyclesPerSecond uint32 = 2

type model struct {
	regTable table.Model
}

type frameMsg struct{}

func NewModel() model {
	runCPU(targetCyclesPerSecond)
	return model{
		// model: regTables,
	}
}

func (m model) Init() tea.Cmd {
	regs1.SetCursor(-1)
	regs2.SetCursor(-1)
	styles := table.DefaultStyles()
	styles.Selected = lipgloss.NewStyle()
	regs1.SetStyles(styles)
	regs2.SetStyles(styles)
	return tea.Tick(16*time.Millisecond, func(time.Time) tea.Msg { return frameMsg{} })
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	if keyMsg, ok := msg.(tea.KeyMsg); ok {
		switch keyMsg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}

	switch msg.(type) {
	case frameMsg:
		regs = buildRegRows()
		regs1.SetRows(regs[0])
		regs2.SetRows(regs[1])
		return m, tea.Tick(16*time.Millisecond, func(time.Time) tea.Msg { return frameMsg{} })
	}

	return m, nil
}

func (m model) View() string {
	return lipgloss.JoinVertical(lipgloss.Top, 
		getState(), 
		lipgloss.JoinHorizontal(lipgloss.Top, regs1.View(), regs2.View()))
}

func runCPU(targetFreq uint32) {
	go func() {
		for {
			cpu.Tick()
			time.Sleep(time.Second / time.Duration(targetFreq))
		}
	}()
}
