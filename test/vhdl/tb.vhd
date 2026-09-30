-- Testbench: TT top level + SPI models of the Pmod's flash and two PSRAMs (mode 0,
-- commands 0x02/0x03; a write to the flash is an error). Loads prog.hex into RAM A and the
-- flash at 0 (result area poisoned), drives the boot strap (G_BOOT), releases reset, plays the
-- keyboard protocol from cupu.py, waits for gpio = DONE, checks the CPU stays halted
-- and dumps G_NRES words from 0x100000 to results.txt.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb is
  generic (G_NRES : natural := 1; G_TIMEOUT_MS : natural := 4000; G_CLK_HZ : natural := 20_000_000;
           G_BOOT : natural := 0);
end entity;

architecture sim of tb is
  constant T_CLK   : time    := 50 ns;       -- 20 MHz
  constant MEMSIZE : natural := 2 ** 21;     -- per chip, wraps

  type mem_t is array (0 to MEMSIZE - 1) of natural range 0 to 255;
  shared variable ram_a, ram_b, ram_f : mem_t;

  signal clk     : std_logic := '0';
  signal rst_n   : std_logic := '0';
  signal ui_in   : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(G_BOOT, 8));  -- boot strap
  signal uo_out  : std_logic_vector(7 downto 0);
  signal uio_in  : std_logic_vector(7 downto 0) := (others => '0');
  signal uio_out : std_logic_vector(7 downto 0);
  signal uio_oe  : std_logic_vector(7 downto 0);
  signal miso    : std_logic_vector(0 to 2) := "000";
  signal done    : boolean := false;
begin
  clk <= not clk after T_CLK / 2 when not done;

  dut : entity work.tt_um_zonlykroks_cupu
    generic map (G_CLK_HZ => G_CLK_HZ)
    port map (ui_in, uo_out, uio_in, uio_out, uio_oe, '1', clk, rst_n);

  -- keyboard protocol, see cupu.py
  kbd : process
  begin
    wait until rst_n = '1';
    ui_in <= x"5A";
    wait for 1 us;
    ui_in <= x"DA";                                -- strobe KEY1 'Z'
    wait until uo_out = x"3C";                     -- WAIT_KEY
    wait for 200 us;                               -- the CPU has to sit blocked meanwhile
    ui_in <= x"71";
    wait for 1 us;
    ui_in <= x"F1";                                -- strobe KEY2 'q'
    wait;
  end process;

  uio_in(2) <= miso(0) when uio_out(6) = '0' else
               miso(1) when uio_out(7) = '0' else
               miso(2) when uio_out(0) = '0' and uio_oe(0) = '1' else 'Z';

  -- one process per chip; the generate keeps the model in one place
  chips : for c in 0 to 2 generate          -- 0: RAM A, 1: RAM B, 2: flash
    signal cs, sck, mosi : std_logic;
  begin
    ram_cs : if c < 2 generate
      cs <= uio_out(6 + c) when uio_oe(6 + c) = '1' else '1';
    end generate;
    flash_cs : if c = 2 generate
      cs <= uio_out(0) when uio_oe(0) = '1' else '1';
    end generate;
    sck  <= uio_out(3);
    mosi <= uio_out(1);

    process
      variable cmd  : std_logic_vector(7 downto 0);
      variable addr : unsigned(23 downto 0);
      variable n    : natural;
      variable byte : std_logic_vector(7 downto 0);
      variable a    : natural;
    begin
      wait until cs = '0';
      n := 0;
      loop
        wait until rising_edge(sck) or cs = '1';
        exit when cs = '1';
        if n < 8 then
          cmd := cmd(6 downto 0) & mosi;
        elsif n < 32 then
          addr := addr(22 downto 0) & mosi;
        elsif cmd = x"02" then
          assert c /= 2 report "the CPU sent a write command to the flash" severity failure;
          byte := byte(6 downto 0) & mosi;
          if (n - 32) mod 8 = 7 then
            a := (to_integer(addr) + (n - 32) / 8) mod MEMSIZE;
            if c = 0 then ram_a(a) := to_integer(unsigned(byte)); else ram_b(a) := to_integer(unsigned(byte)); end if;
          end if;
        end if;
        n := n + 1;
        if n >= 32 and cmd = x"03" then
          wait until falling_edge(sck) or cs = '1';
          exit when cs = '1';
          a := (to_integer(addr) + (n - 32) / 8) mod MEMSIZE;
          if c = 0 then    byte := std_logic_vector(to_unsigned(ram_a(a), 8));
          elsif c = 1 then byte := std_logic_vector(to_unsigned(ram_b(a), 8));
          else             byte := std_logic_vector(to_unsigned(ram_f(a), 8)); end if;
          miso(c) <= byte(7 - (n - 32) mod 8) after 5 ns;
        end if;
      end loop;
    end process;
  end generate;

  stim : process
    file f      : text;
    variable l  : line;
    variable w  : std_logic_vector(31 downto 0);
    variable a  : natural := 0;
    variable v  : natural;
  begin
    file_open(f, "prog.hex", read_mode);
    while not endfile(f) loop
      readline(f, l);
      hread(l, w);
      for k in 0 to 3 loop
        if G_BOOT = 0 then                         -- flash boot: code only in the flash
          ram_a(a + k) := to_integer(unsigned(w(8 * k + 7 downto 8 * k)));
        end if;
        ram_f(a + k) := to_integer(unsigned(w(8 * k + 7 downto 8 * k)));
      end loop;
      a := a + 4;
    end loop;
    file_close(f);
    for i in 16#100000# to 16#10FFFF# loop       -- a missing store must not read as a result
      ram_a(i) := 16#DD#;
    end loop;

    wait for 10 * T_CLK;
    rst_n <= '1';

    wait until uo_out = x"A5" for G_TIMEOUT_MS * 1 ms;
    assert uo_out = x"A5" report "timeout: program never finished" severity failure;
    wait for 100 us;
    assert uo_out = x"A5" report "CPU kept running after it should have halted" severity failure;

    file_open(f, "results.txt", write_mode);
    for i in 0 to G_NRES - 1 loop
      v := 16#100000# + 4 * i;
      w := std_logic_vector(to_unsigned(ram_a(v + 3), 8)) & std_logic_vector(to_unsigned(ram_a(v + 2), 8))
         & std_logic_vector(to_unsigned(ram_a(v + 1), 8)) & std_logic_vector(to_unsigned(ram_a(v), 8));
      hwrite(l, w);
      writeline(f, l);
    end loop;
    file_close(f);
    report "simulation finished at " & time'image(now);
    done <= true;
    wait;
  end process;
end architecture;
