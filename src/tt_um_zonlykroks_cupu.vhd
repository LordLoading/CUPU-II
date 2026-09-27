-- Tiny Tapeout top level for CUPU-II.
--
-- ui_in   : keyboard byte, read at 0x20000004
-- uo_out  : gpio register, written/read at 0x20000008
-- uio     : TT QSPI Pmod in plain SPI mode (CS0 flash held high, CS1 RAM A, CS2 RAM B)
--
-- While rst_n is low every uio pin is an input, so the demo board's RP2040 can
-- preload a program into the PSRAM before releasing reset. Execution starts at 0.

library ieee;
use ieee.std_logic_1164.all;

entity tt_um_zonlykroks_cupu is
  port (
    ui_in   : in  std_logic_vector(7 downto 0);
    uo_out  : out std_logic_vector(7 downto 0);
    uio_in  : in  std_logic_vector(7 downto 0);
    uio_out : out std_logic_vector(7 downto 0);
    uio_oe  : out std_logic_vector(7 downto 0);
    ena     : in  std_logic;
    clk     : in  std_logic;
    rst_n   : in  std_logic
  );
end entity;

architecture rtl of tt_um_zonlykroks_cupu is
  signal rst : std_logic;

  signal mem_req, mem_we, mem_done : std_logic;
  signal mem_size  : std_logic_vector(1 downto 0);
  signal mem_addr  : std_logic_vector(23 downto 0);
  signal mem_wdata : std_logic_vector(31 downto 0);
  signal mem_rdata : std_logic_vector(31 downto 0);

  signal sck, mosi : std_logic;
  signal cs_n      : std_logic_vector(1 downto 0);
begin
  rst <= not rst_n;

  core : entity work.cupu_core
    generic map (G_CLK_HZ => 25_000_000)
    port map (
      clk       => clk,
      rst       => rst,
      mem_req   => mem_req,
      mem_we    => mem_we,
      mem_size  => mem_size,
      mem_addr  => mem_addr,
      mem_wdata => mem_wdata,
      mem_rdata => mem_rdata,
      mem_done  => mem_done,
      kbd_in    => ui_in,
      gpio_out  => uo_out,
      halted    => open
    );

  spi : entity work.cupu_spi
    port map (
      clk   => clk,
      rst   => rst,
      req   => mem_req,
      we    => mem_we,
      size  => mem_size,
      addr  => mem_addr,
      wdata => mem_wdata,
      rdata => mem_rdata,
      done  => mem_done,
      sck   => sck,
      mosi  => mosi,
      miso  => uio_in(2),
      cs_n  => cs_n
    );

  uio_out(0) <= '1';      -- flash CS, keep deselected
  uio_out(1) <= mosi;
  uio_out(2) <= '0';      -- MISO (input)
  uio_out(3) <= sck;
  uio_out(4) <= '0';      -- SD2, unused
  uio_out(5) <= '0';      -- SD3, unused
  uio_out(6) <= cs_n(0);  -- RAM A
  uio_out(7) <= cs_n(1);  -- RAM B

  uio_oe <= x"00" when rst_n = '0' else "11001011";
end architecture;
