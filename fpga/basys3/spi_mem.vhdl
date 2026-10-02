-- SPI memory in FPGA block RAM, standing in for one chip of the Tiny Tapeout QSPI Pmod
-- (W25Q128 flash or APS6404L PSRAM) so the CPU runs on the Basys 3 without the Pmod.
--
-- It speaks what cupu_spi uses: SPI mode 0, command 0x03 (read) or 0x02 (write), a 24-bit
-- address, then data bytes MSB first at consecutive addresses. The memory has 2**G_ABITS
-- bytes and repeats over the 24-bit address range.
--
-- It runs on the CPU's clock and watches SCK, which cupu_spi toggles once per clock.
-- cupu_spi samples MISO on the clock edge where it lowers SCK, so after each falling edge
-- this model puts the next data bit out within one clock. That only works with the
-- controller on the same clock; for a real chip use the Pmod (G_MEM = 1 in basys3_top).

library ieee;
use ieee.std_logic_1164.all;

package spi_mem_pkg is
  type byte_array is array (natural range <>) of std_logic_vector(7 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spi_mem_pkg.all;
use work.prog_pkg.all;

entity spi_mem is
  generic (
    G_ABITS    : positive := 16;    -- 2**G_ABITS bytes
    G_WRITABLE : boolean  := true;  -- false: a flash, 0x02 writes are ignored
    G_LOAD     : boolean  := true   -- start with the program image from prog_pkg
  );
  port (
    clk  : in  std_logic;
    cs_n : in  std_logic;
    sck  : in  std_logic;
    mosi : in  std_logic;
    miso : out std_logic           -- '0' while not selected, so the chips can be or-ed
  );
end entity;

architecture rtl of spi_mem is
  subtype addr_t is unsigned(G_ABITS - 1 downto 0);

  -- the program image, little endian: the byte at address 4i is bits 7..0 of PROG(i)
  function initial return byte_array is
    variable m : byte_array(0 to 2 ** G_ABITS - 1) := (others => (others => '0'));
  begin
    if G_LOAD then
      for i in PROG'range loop
        for k in 0 to 3 loop
          if 4 * i + k < m'length then
            m(4 * i + k) := PROG(i)(8 * k + 7 downto 8 * k);
          end if;
        end loop;
      end loop;
    end if;
    return m;
  end function;

  signal mem   : byte_array(0 to 2 ** G_ABITS - 1) := initial;
  signal dout  : std_logic_vector(7 downto 0) := (others => '0');

  signal sck_d : std_logic := '0';
  signal hdr   : std_logic_vector(30 downto 0) := (others => '0');  -- command and address bits
  signal n     : unsigned(5 downto 0) := (others => '0');            -- header bits received, to 32
  signal cmd   : std_logic_vector(7 downto 0) := (others => '0');
  signal ptr   : addr_t := (others => '0');
  signal dbit  : unsigned(2 downto 0) := (others => '0');            -- bit within the data byte
  signal rbyte : std_logic_vector(6 downto 0) := (others => '0');    -- read byte, bits still to send
  signal wbyte : std_logic_vector(6 downto 0) := (others => '0');    -- write byte, bits so far
  signal first : std_logic := '0';                                   -- next byte read is the first

  signal rise, fall : std_logic;
  signal addr_in    : addr_t;      -- the address, the moment its last bit arrives
  signal raddr      : addr_t;
  signal we         : std_logic;
begin
  rise <= sck and not sck_d;
  fall <= sck_d and not sck;

  addr_in <= unsigned(hdr(G_ABITS - 2 downto 0) & mosi);

  -- the first byte is read on the very edge the address completes: the controller wants its
  -- first bit two clocks later
  raddr <= addr_in when rise = '1' and n = 31 else ptr;
  we    <= '1' when G_WRITABLE and cs_n = '0' and rise = '1' and n = 32 and cmd = x"02" and dbit = 7
           else '0';

  process (clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        mem(to_integer(ptr)) <= wbyte & mosi;
      end if;
      dout <= mem(to_integer(raddr));
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      sck_d <= sck;
      if cs_n = '1' then
        n    <= (others => '0');
        dbit <= (others => '0');
        miso <= '0';
      elsif rise = '1' then
        if n < 32 then
          hdr <= hdr(29 downto 0) & mosi;
          n   <= n + 1;
          if n = 7 then
            cmd <= hdr(6 downto 0) & mosi;
          end if;
          if n = 31 then
            first <= '1';
            if cmd = x"02" then
              ptr <= addr_in;                -- the first write goes here
            else
              ptr <= addr_in + 1;            -- addr_in itself is being read right now
            end if;
          end if;
        elsif cmd = x"02" then
          wbyte <= wbyte(5 downto 0) & mosi;
          dbit  <= dbit + 1;
          if dbit = 7 then
            ptr <= ptr + 1;                  -- the byte is written this clock (we)
          end if;
        end if;
      elsif fall = '1' and n = 32 and cmd = x"03" then
        -- put the next data bit out; the controller samples it on its next falling edge
        if dbit = 0 then
          miso  <= dout(7);
          rbyte <= dout(6 downto 0);
          first <= '0';
          if first = '0' then
            ptr <= ptr + 1;
          end if;
        else
          miso  <= rbyte(6);
          rbyte <= rbyte(5 downto 0) & '0';
        end if;
        dbit <= dbit + 1;
      end if;
    end if;
  end process;
end architecture;

-------------------------------------------------------------------------------

-- Listens to the SPI bus of one chip and keeps the last 32-bit word written at G_ADDR
-- (little endian, like the CPU stores it). The board shows that word on its display.
-- It only watches the pins, so it works with the emulated chips and with the real Pmod.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_tap is
  generic (
    G_ADDR : natural := 16#00FFFC#   -- word aligned
  );
  port (
    clk  : in  std_logic;
    cs_n : in  std_logic;
    sck  : in  std_logic;
    mosi : in  std_logic;
    word : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of spi_tap is
  signal sck_d : std_logic := '0';
  signal hdr   : std_logic_vector(30 downto 0) := (others => '0');
  signal n     : unsigned(5 downto 0) := (others => '0');
  signal wr    : std_logic := '0';
  signal ptr   : unsigned(23 downto 0) := (others => '0');
  signal dbit  : unsigned(2 downto 0) := (others => '0');
  signal byte  : std_logic_vector(6 downto 0) := (others => '0');
  signal w     : std_logic_vector(31 downto 0) := (others => '0');
begin
  word <= w;

  process (clk)
  begin
    if rising_edge(clk) then
      sck_d <= sck;
      if cs_n = '1' then
        n    <= (others => '0');
        dbit <= (others => '0');
      elsif sck = '1' and sck_d = '0' then
        if n < 32 then
          hdr <= hdr(29 downto 0) & mosi;
          n   <= n + 1;
          if n = 31 then
            ptr <= unsigned(hdr(22 downto 0) & mosi);
            if hdr(30 downto 23) = x"02" then wr <= '1'; else wr <= '0'; end if;
          end if;
        elsif wr = '1' then
          byte <= byte(5 downto 0) & mosi;
          dbit <= dbit + 1;
          if dbit = 7 then
            if ptr(23 downto 2) = to_unsigned(G_ADDR / 4, 22) then
              w(8 * to_integer(ptr(1 downto 0)) + 7 downto 8 * to_integer(ptr(1 downto 0))) <= byte & mosi;
            end if;
            ptr <= ptr + 1;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;
