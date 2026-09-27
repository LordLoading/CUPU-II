-- Stand-alone FPU testbench: reads fpu_vectors.txt, writes fpu_results.txt.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_fpu is
end entity;

architecture sim of tb_fpu is
  signal clk   : std_logic := '0';
  signal rst   : std_logic := '1';
  signal start : std_logic := '0';
  signal op    : unsigned(3 downto 0);
  signal a, b  : std_logic_vector(31 downto 0);
  signal res   : std_logic_vector(31 downto 0);
  signal done  : std_logic;
  signal fin   : boolean := false;
begin
  clk <= not clk after 5 ns when not fin;

  dut : entity work.cupu_fpu port map (clk, rst, start, op, a, b, res, done);

  process
    file fi, fo : text;
    variable li, lo     : line;
    variable vop        : std_logic_vector(3 downto 0);
    variable va, vb, ve : std_logic_vector(31 downto 0);
    variable n          : natural;
  begin
    file_open(fi, "fpu_vectors.txt", read_mode);
    file_open(fo, "fpu_results.txt", write_mode);
    wait until rising_edge(clk);
    rst <= '0';
    while not endfile(fi) loop
      readline(fi, li);
      hread(li, vop);
      hread(li, va);
      hread(li, vb);
      hread(li, ve);
      op    <= unsigned(vop);
      a     <= va;
      b     <= vb;
      start <= '1';
      wait until rising_edge(clk);
      start <= '0';
      n := 0;
      loop
        wait until rising_edge(clk);
        n := n + 1;
        exit when done = '1';
        assert n < 5000 report "FPU hung" severity failure;
      end loop;
      hwrite(lo, vop);
      write(lo, ' ');
      hwrite(lo, va);
      write(lo, ' ');
      hwrite(lo, vb);
      write(lo, ' ');
      hwrite(lo, ve);
      write(lo, ' ');
      hwrite(lo, res);
      writeline(fo, lo);
    end loop;
    file_close(fo);
    fin <= true;
    wait;
  end process;
end architecture;
