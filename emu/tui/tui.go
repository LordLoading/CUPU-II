package tui

import (
	"fmt"
	"strings"
	"time"

	"emulator/hardware"
	"emulator/hardware/cpu"
	"github.com/charmbracelet/bubbles/table"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var targetCyclesPerSecond uint32 = 1e+8

type model struct {
	regTable       table.Model
	clockInput     textinput.Model
	lastTime       time.Time
	accumulator    float64
	tickCount      int
	lastFreqUpdate time.Time
	measuredFreq   float64
}

type frameMsg struct{}

func initialModel() model {
	regColumns := []table.Column{
		{Title: "Register", Width: 10},
		{Title: "Value", Width: 18},
		{Title: "Dec", Width: 12},
	}
	regTable := table.New(
		table.WithColumns(regColumns),
		table.WithRows(buildRegRows()),
		table.WithFocused(true),
	)
	regStyles := table.DefaultStyles()
	regStyles.Header = regStyles.Header.
		BorderStyle(lipgloss.NormalBorder()).
		BorderForeground(lipgloss.Color("240")).
		BorderBottom(true).
		Bold(false)
	regStyles.Selected = regStyles.Selected.
		Foreground(lipgloss.Color("229")).
		Background(lipgloss.Color("57")).
		Bold(false)
	regTable.SetStyles(regStyles)

	ti := textinput.New()
	ti.Placeholder = fmt.Sprintf("%d", targetCyclesPerSecond)
	ti.CharLimit = 20
	ti.Width = 20

	now := time.Now()
	return model{
		regTable:       regTable,
		clockInput:     ti,
		lastTime:       now,
		accumulator:    0,
		tickCount:      0,
		lastFreqUpdate: now,
		measuredFreq:   0,
	}
}

func buildRegRows() []table.Row {
	rows := make([]table.Row, 0, 32)
	for i, reg := range cpu.Regs {
		rows = append(rows, table.Row{fmt.Sprintf("$%d", i), fmt.Sprintf("%08x", reg), fmt.Sprintf("%d", reg)})
	}
	return rows
}

func (m model) Init() tea.Cmd {
	return tea.Tick(16*time.Millisecond, func(time.Time) tea.Msg { return frameMsg{} })
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case frameMsg:
		now := time.Now()
		dt := now.Sub(m.lastTime).Seconds()
		m.lastTime = now
		m.accumulator += dt

		step := 1.0 / float64(targetCyclesPerSecond)
		running := true
		for m.accumulator >= step {
			running = cpu.Tick()
			m.accumulator -= step
			m.tickCount++
			if !running {
				break
			}
		}

		elapsed := time.Since(m.lastFreqUpdate).Seconds()
		if elapsed >= 1.0 {
			m.measuredFreq = float64(m.tickCount) / elapsed
			m.tickCount = 0
			m.lastFreqUpdate = time.Now()
		}
		if running {
			m.regTable.SetRows(buildRegRows())
		}

		return m, tea.Tick(16*time.Millisecond, func(time.Time) tea.Msg { return frameMsg{} })

	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		case "tab":
			if m.regTable.Focused() {
				m.regTable.Blur()
			} else {
				m.regTable.Focus()
			}
			return m, nil
		case "c":
			if !m.clockInput.Focused() {
				m.clockInput.Focus()
				m.regTable.Blur()
			}
			return m, nil
		case "enter":
			if m.clockInput.Focused() {
				val := 0
				if _, err := fmt.Sscanf(m.clockInput.Value(), "%d", &val); err == nil && val > 0 {
					targetCyclesPerSecond = uint32(val)
				}
				m.clockInput.Blur()
				m.regTable.Focus()
				return m, nil
			}
		}
	}

	if m.clockInput.Focused() {
		var cmd tea.Cmd
		m.clockInput, cmd = m.clockInput.Update(msg)
		return m, cmd
	}

	var cmd tea.Cmd
	m.regTable, cmd = m.regTable.Update(msg)
	return m, cmd
}

func ramView() string {
	highlight := lipgloss.NewStyle().
		Foreground(lipgloss.Color("229")).
		Background(lipgloss.Color("57")).
		Bold(false)

	var b strings.Builder
	for addr := 0; addr < 256; addr += 16 {
		b.WriteString(fmt.Sprintf("0x%04x  ", addr))
		for j := 0; j < 16; j++ {
			byteAddr := addr + j
			val := hardware.Ram[byteAddr]
			if (uint32(byteAddr) >= cpu.ProgramCounter) && (uint32(byteAddr) < cpu.ProgramCounter+4) {
				b.WriteString(highlight.Render(fmt.Sprintf("%02x", val)))
			} else {
				b.WriteString(fmt.Sprintf("%02x", val))
			}
			if j < 15 {
				b.WriteString(" ")
			}
		}
		b.WriteString("\n")
	}
	return b.String()
}

func (m model) View() string {
	info := fmt.Sprintf("Clock: %.0f Hz  |  PC: 0x%08x  |  IR: 0x%08x  |  Press 'c' to set clock", m.measuredFreq, cpu.ProgramCounter, cpu.InstReg)
	clockRow := lipgloss.JoinHorizontal(lipgloss.Top, m.clockInput.View())
	return lipgloss.JoinVertical(lipgloss.Top, info, clockRow, lipgloss.JoinHorizontal(lipgloss.Top, m.regTable.View(), ramView()))
}

func Run() error {
	p := tea.NewProgram(initialModel(), tea.WithAltScreen())
	_, err := p.Run()
	return err
}
