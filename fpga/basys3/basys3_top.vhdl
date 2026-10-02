-- CUPU-II on the Digilent Basys 3 (XC7A35T). The chip's own top level, tt_um_zonlykroks_cupu
-- from src/project.vhdl, is used unchanged; this file only stands in for the Tiny Tapeout
-- board around it.
--
--   clock      100 MHz -> 20 MHz (basys3_clk), the chip's design frequency
--   btnC       reset (held while pressed); the FPGA also resets itself after configuration
--   sw(7:0)    ui_in: the gpio inputs. sw(0) during reset: 1 = boot from the flash
--   led(7:0)   uo_out: the gpio outputs
--   led(14)    SPI busy (dark: the CPU has halted)    led(15) running (out of reset)
--   7-segment  sw(15) off: the word the program stores at 0x00FFFC (spi_tap): four decimal
--                          digits in bits 15..0, leftmost in 15..12, and the number of digits
--                          after the decimal point in bits 17..16. The program does the
--                          conversion (see mkprog.py); leading zeros are left dark.
--              sw(15) on : uo_out drives the right digit's segments directly, like the
--                          7-segment display on the Tiny Tapeout demo board
--   G_MEM = 0  flash and both PSRAMs emulated in block RAM (spi_mem), preloaded with the
--              program from prog_pkg (mkprog.py)
--   G_MEM = 1  a real Tiny Tapeout QSPI Pmod in JB (uio pins 0-7 on JB1-4, JB7-10)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity basys3_top is
  generic (
    G_MEM       : natural  := 0;
    G_RAM_ABITS : positive := 16    -- emulated RAM A: 64 KiB, repeating over its 8 MiB
  );
  port (
    clk  : in    std_logic;
    btnC : in    std_logic;
    sw   : in    std_logic_vector(15 downto 0);
    led  : out   std_logic_vector(15 downto 0);
    seg  : out   std_logic_vector(6 downto 0);
    dp   : out   std_logic;
    an   : out   std_logic_vector(3 downto 0);
    JB   : inout std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of basys3_top is
  signal clk20, locked : std_logic;

  signal lock_s, btn_s : std_logic_vector(1 downto 0) := "00";
  signal por           : unsigned(3 downto 0) := (others => '0');
  signal rst_n         : std_logic := '0';

  signal ui_in, uo_out          : std_logic_vector(7 downto 0);
  signal uio_in, uio_out, uio_oe : std_logic_vector(7 downto 0);
  signal cs_f, cs_a, cs_b        : std_logic;

  signal disp    : std_logic_vector(31 downto 0);
  signal refresh : unsigned(16 downto 0) := (others => '0');

  -- segments a..g in bits 0..6, active high
  function seg7(d : std_logic_vector(3 downto 0)) return std_logic_vector is
  begin
    case d is
      when x"0" => return "0111111";
      when x"1" => return "0000110";
      when x"2" => return "1011011";
      when x"3" => return "1001111";
      when x"4" => return "1100110";
      when x"5" => return "1101101";
      when x"6" => return "1111101";
      when x"7" => return "0000111";
      when x"8" => return "1111111";
      when x"9" => return "1101111";
      when x"A" => return "1110111";
      when x"B" => return "1111100";
      when x"C" => return "0111001";
      when x"D" => return "1011110";
      when x"E" => return "1111001";
      when others => return "1110001";
    end case;
  end function;
begin
  u_clk : entity work.basys3_clk
    port map (clk100 => clk, clk => clk20, locked => locked);

  -- reset: until the clock is locked, while btnC is pressed, and 15 clocks after
  process (clk20)
  begin
    if rising_edge(clk20) then
      lock_s <= lock_s(0) & locked;
      btn_s  <= btn_s(0) & btnC;
      if lock_s(1) = '0' or btn_s(1) = '1' then
        por   <= (others => '0');
        rst_n <= '0';
      elsif por /= 15 then
        por   <= por + 1;
        rst_n <= '0';
      else
        rst_n <= '1';
      end if;
    end if;
  end process;

  ui_in <= sw(7 downto 0);

  u_cupu : entity work.tt_um_zonlykroks_cupu
    generic map (G_CLK_HZ => 20_000_000)
    port map (
      ui_in   => ui_in,
      uo_out  => uo_out,
      uio_in  => uio_in,
      uio_out => uio_out,
      uio_oe  => uio_oe,
      ena     => '1',
      clk     => clk20,
      rst_n   => rst_n
    );

  -- chip selects as the chips see them: pulled up while the pins are inputs
  cs_f <= uio_out(0) when uio_oe(0) = '1' else '1';
  cs_a <= uio_out(6) when uio_oe(6) = '1' else '1';
  cs_b <= uio_out(7) when uio_oe(7) = '1' else '1';

  g_bram : if G_MEM = 0 generate
    signal miso_f, miso_a, miso_b : std_logic;
  begin
    u_flash : entity work.spi_mem
      generic map (G_ABITS => 16, G_WRITABLE => false, G_LOAD => true)
      port map (clk => clk20, cs_n => cs_f, sck => uio_out(3), mosi => uio_out(1), miso => miso_f);
    u_ram_a : entity work.spi_mem
      generic map (G_ABITS => G_RAM_ABITS, G_WRITABLE => true, G_LOAD => true)
      port map (clk => clk20, cs_n => cs_a, sck => uio_out(3), mosi => uio_out(1), miso => miso_a);
    u_ram_b : entity work.spi_mem
      generic map (G_ABITS => 14, G_WRITABLE => true, G_LOAD => false)
      port map (clk => clk20, cs_n => cs_b, sck => uio_out(3), mosi => uio_out(1), miso => miso_b);

    uio_in <= (2 => miso_f or miso_a or miso_b, others => '0');
    JB     <= (others => 'Z');
  end generate;

  g_pmod : if G_MEM = 1 generate
    pins : for i in 0 to 7 generate
      JB(i) <= uio_out(i) when uio_oe(i) = '1' else 'Z';
    end generate;
    uio_in <= JB;
  end generate;

  -- the display word the program stores at 0x00FFFC (in RAM A)
  u_tap : entity work.spi_tap
    generic map (G_ADDR => 16#00FFFC#)
    port map (clk => clk20, cs_n => cs_a, sck => uio_out(3), mosi => uio_out(1), word => disp);

  led(7 downto 0)  <= uo_out;
  led(13 downto 8) <= (others => '0');
  led(14)          <= not (cs_f and cs_a and cs_b);
  led(15)          <= rst_n;

  -- 7-segment display: four digits multiplexed, about 1.6 ms each
  process (clk20)
  begin
    if rising_edge(clk20) then
      refresh <= refresh + 1;
    end if;
  end process;

  process (refresh, disp, uo_out, sw)
    variable i, pt : natural range 0 to 3;
    variable sel   : std_logic_vector(3 downto 0);
    variable lead  : boolean;               -- this digit and all left of it are 0
  begin
    i  := to_integer(refresh(16 downto 15));
    pt := to_integer(unsigned(disp(17 downto 16)));
    sel    := (others => '1');
    sel(i) := '0';
    lead := true;
    for k in 0 to 3 loop
      if k >= i and disp(4 * k + 3 downto 4 * k) /= x"0" then
        lead := false;
      end if;
    end loop;
    if sw(15) = '1' then
      an  <= "1110";                  -- right digit only, segments straight from uo_out
      seg <= not uo_out(6 downto 0);
      dp  <= not uo_out(7);
    else
      an  <= sel;
      if lead and i > pt then
        seg <= (others => '1');       -- leading zero: dark
      else
        seg <= not seg7(disp(4 * i + 3 downto 4 * i));
      end if;
      if pt /= 0 and i = pt then dp <= '0'; else dp <= '1'; end if;
    end if;
  end process;
end architecture;
