-- Simulation of the Basys 3 build: reports every change on the LEDs (uo_out) and stops when
-- they show 0xA5 (what the test programs from `mkprog.py --test NAME` end with) or after
-- G_RUN_MS. The demo program only updates the LEDs every 8000-loop delay; for simulation
-- generate it with `mkprog.py --demo 5`.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_basys3 is
  generic (
    G_SW     : natural := 0;    -- switch settings
    G_RUN_MS : natural := 20
  );
end entity;

architecture sim of tb_basys3 is
  signal clk  : std_logic := '0';
  signal btnC : std_logic := '1';
  signal sw   : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(G_SW, 16));
  signal led  : std_logic_vector(15 downto 0);
  signal seg  : std_logic_vector(6 downto 0);
  signal dp   : std_logic;
  signal an   : std_logic_vector(3 downto 0);
  signal JB   : std_logic_vector(7 downto 0);
  signal stop : boolean := false;
begin
  clk <= not clk after 5 ns when not stop;   -- 100 MHz

  dut : entity work.basys3_top
    port map (clk => clk, btnC => btnC, sw => sw, led => led, seg => seg, dp => dp, an => an, JB => JB);

  process
  begin
    wait for 2 us;
    btnC <= '0';
    wait;
  end process;

  process
  begin
    wait on led(7 downto 0) for G_RUN_MS * 1 ms;
    if now >= G_RUN_MS * 1 ms then
      report "time limit, LEDs = 0x" & to_hstring(led(7 downto 0));
      stop <= true;
      wait;
    end if;
    report "LEDs = 0x" & to_hstring(led(7 downto 0));
    if led(7 downto 0) = x"A5" then
      report "program finished (0xA5)";
      stop <= true;
      wait;
    end if;
  end process;
end architecture;
