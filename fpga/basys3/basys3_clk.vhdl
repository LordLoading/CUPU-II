-- 100 MHz board clock -> 20 MHz CPU clock, the frequency the chip is built for
-- (MMCM: VCO = 100 MHz * 10 = 1 GHz, / 50).

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity basys3_clk is
  port (
    clk100 : in  std_logic;
    clk    : out std_logic;
    locked : out std_logic
  );
end entity;

architecture rtl of basys3_clk is
  signal fb, clk_u : std_logic;
begin
  mmcm : MMCME2_BASE
    generic map (
      CLKIN1_PERIOD    => 10.0,
      CLKFBOUT_MULT_F  => 10.0,
      DIVCLK_DIVIDE    => 1,
      CLKOUT0_DIVIDE_F => 50.0
    )
    port map (
      CLKIN1   => clk100,
      CLKFBIN  => fb,
      CLKFBOUT => fb,
      CLKOUT0  => clk_u,
      LOCKED   => locked,
      PWRDWN   => '0',
      RST      => '0'
    );

  bufg_clk : BUFG port map (I => clk_u, O => clk);
end architecture;
