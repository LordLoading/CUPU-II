-- CUPU-II "Stollentroll" core, multi-cycle implementation of isa.txt.
--
-- Everything shares one 33-bit adder and one register-file read port; mul/div are
-- iterative (32 cycles) and shifts go one bit per cycle. Fetches over SPI take ~130
-- cycles anyway, so the extra cycles are cheap and the area savings are not.
-- Floating point ops (func 0x0E..0x17) run in cupu_fpu.
--
-- Differences from the Go emulator are listed in docs/info.md.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cupu_core is
  generic (
    G_CLK_HZ : natural := 25_000_000  -- for the seconds counter at 0x20000000
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    -- external memory (addresses below 0x01000000)
    mem_req   : out std_logic;
    mem_we    : out std_logic;
    mem_size  : out std_logic_vector(1 downto 0);
    mem_addr  : out std_logic_vector(23 downto 0);
    mem_wdata : out std_logic_vector(31 downto 0);
    mem_rdata : in  std_logic_vector(31 downto 0);
    mem_done  : in  std_logic;
    -- mmio
    kbd_in    : in  std_logic_vector(7 downto 0);
    gpio_out  : out std_logic_vector(7 downto 0);
    halted    : out std_logic
  );
end entity;

architecture rtl of cupu_core is
  subtype word is unsigned(31 downto 0);
  type regfile_t is array (0 to 31) of word;  -- entry 0 is never written

  type state_t is (
    S_FETCH, S_RA, S_RB, S_EXEC, S_MEM, S_WB, S_WBJ, S_NEXT, S_JRAL,
    S_MUL, S_DIV_NA, S_DIV_NB, S_DIV, S_DIV_FQ, S_DIV_FR, S_SHIFT, S_FPU,
    S_CLEAR, S_HALT
  );

  type op_t is (
    OP_NOP, OP_ADD, OP_SUB, OP_MUL, OP_MHI, OP_DIV, OP_DIVU, OP_REM,
    OP_OR, OP_AND, OP_XOR, OP_NOT, OP_SHL, OP_SHR, OP_OVRF, OP_UNRF, OP_FPU,
    OP_CMP, OP_LOAD, OP_STORE, OP_HLT, OP_LUI, OP_JAL, OP_JRAL
  );

  constant MMIO_BASE : unsigned(27 downto 0) := x"2000000";  -- addr(31 downto 4)

  signal regs  : regfile_t;
  signal state : state_t;
  signal pc, ir, opa, opb, acc : word;
  signal cnt   : unsigned(4 downto 0);
  signal flag, sgn_q, sgn_r    : std_logic;

  -- instruction fields
  signal f_cond : std_logic;
  signal f_opc  : unsigned(4 downto 0);
  signal f_t, f_a, f_b : unsigned(4 downto 0);
  signal f_fn   : unsigned(10 downto 0);
  signal op     : op_t;

  signal rf_idx : unsigned(4 downto 0);
  signal rf_rd  : word;
  signal wb_val : word;
  signal pc_inc : word;

  -- shared adder: add_s = x + (y xor inv) + cin, 34 bits so bit 33 is the carry
  signal add_x, add_y : unsigned(32 downto 0);
  signal add_inv, add_cin : std_logic;
  signal add_s : unsigned(33 downto 0);

  -- memory access
  signal acc_addr  : word;
  signal acc_size  : std_logic_vector(1 downto 0);
  signal acc_req   : std_logic;
  signal mmio_sel  : std_logic;
  signal mmio_rd   : word;
  signal acc_done  : std_logic;
  signal acc_rdata : word;

  -- fpu
  signal fpu_start : std_logic;
  signal fpu_op    : unsigned(4 downto 0);
  signal fpu_res   : std_logic_vector(31 downto 0);
  signal fpu_done  : std_logic;

  -- mmio devices
  signal gpio      : std_logic_vector(7 downto 0);
  signal seconds   : word;
  signal ts_we     : std_logic;
  signal kbd_sync  : std_logic_vector(2 downto 0);
  signal kbd_data  : std_logic_vector(6 downto 0);
  signal kbd_valid : std_logic;
  signal kbd_hit   : std_logic;  -- current load reads the keyboard byte
  signal kbd_take  : std_logic;
  signal prescale  : natural range 0 to G_CLK_HZ - 1;
begin
  f_cond <= ir(31);
  f_opc  <= ir(30 downto 26);
  f_t    <= ir(25 downto 21);
  f_a    <= ir(20 downto 16);
  f_b    <= ir(15 downto 11);
  f_fn   <= ir(10 downto 0);

  ---------------------------------------------------------------------------
  -- decode
  ---------------------------------------------------------------------------
  process (f_opc, f_fn)
  begin
    op <= OP_NOP;
    if f_opc = 0 then
      case to_integer(f_fn) is
        when 16#00# => op <= OP_ADD;
        when 16#01# => op <= OP_SUB;
        when 16#02# => op <= OP_MUL;
        when 16#03# => op <= OP_DIV;
        when 16#04# => op <= OP_OR;
        when 16#05# => op <= OP_AND;
        when 16#06# => op <= OP_XOR;
        when 16#07# => op <= OP_NOT;
        when 16#08# => op <= OP_SHL;
        when 16#09# => op <= OP_SHR;
        when 16#0A# => op <= OP_REM;
        when 16#0B# => op <= OP_MHI;
        when 16#0C# => op <= OP_OVRF;
        when 16#0D# => op <= OP_UNRF;
        when 16#0E# to 16#17# => op <= OP_FPU;
        when 16#20# to 16#25# => op <= OP_CMP;
        when 16#30# to 16#32# => op <= OP_LOAD;
        when 16#33# to 16#35# => op <= OP_STORE;
        when 16#40# => op <= OP_HLT;
        when others => null;
      end case;
    else
      case to_integer(f_opc) is
        when 16#08# | 16#18# => op <= OP_ADD;
        when 16#09# | 16#19# => op <= OP_SUB;
        when 16#0A# | 16#1A# => op <= OP_MUL;
        when 16#0B#          => op <= OP_DIV;
        when 16#1B#          => op <= OP_DIVU;
        when 16#0C# | 16#1C# => op <= OP_OR;
        when 16#0D# | 16#1D# => op <= OP_AND;
        when 16#0E# | 16#1E# => op <= OP_XOR;
        when 16#0F#          => op <= OP_LUI;
        when 16#10#          => op <= OP_JAL;
        when 16#11#          => op <= OP_JRAL;
        when others => null;
      end case;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- register file (one read port, $0 reads as zero and is never written)
  ---------------------------------------------------------------------------
  rf_idx <= f_a when state = S_RA else
            f_t when op = OP_STORE else
            f_b;
  process (rf_idx, regs)
  begin
    rf_rd <= (others => '0');
    if rf_idx /= 0 then
      rf_rd <= regs(to_integer(rf_idx));
    end if;
  end process;

  -- mul, div and udivi leave their result in opa; everything else in acc
  wb_val <= opa when op = OP_MUL or op = OP_DIV or op = OP_DIVU else acc;

  pc_inc <= pc + 4;

  ---------------------------------------------------------------------------
  -- shared adder
  ---------------------------------------------------------------------------
  process (state, op, opa, opb, acc, pc, cnt)
  begin
    add_x   <= '0' & opa;
    add_y   <= '0' & opb;
    add_inv <= '0';
    add_cin <= '0';
    case state is
      when S_EXEC =>
        case op is
          when OP_SUB | OP_UNRF | OP_CMP =>
            add_inv <= '1';
            add_cin <= '1';
          when OP_OVRF =>
            add_cin <= '1';
          when others => null;
        end case;
      when S_JRAL =>
        add_x <= '0' & pc;
        add_y <= '0' & opa;
      when S_MUL =>
        -- signed shift-add; the multiplier's sign bit has negative weight
        add_x <= acc(31) & acc;
        if opa(0) = '1' then
          add_y <= opb(31) & opb;
          if cnt = 31 then
            add_inv <= '1';
            add_cin <= '1';
          end if;
        else
          add_y <= (others => '0');
        end if;
      when S_DIV_NA | S_DIV_FQ =>
        add_x   <= (others => '0');
        add_y   <= '0' & opa;
        add_inv <= '1';
        add_cin <= '1';
      when S_DIV_NB =>
        add_x   <= (others => '0');
        add_y   <= '0' & opb;
        add_inv <= '1';
        add_cin <= '1';
      when S_DIV =>
        add_x   <= acc & opa(31);
        add_y   <= '0' & opb;
        add_inv <= '1';
        add_cin <= '1';
      when S_DIV_FR =>
        add_x   <= (others => '0');
        add_y   <= '0' & acc;
        add_inv <= '1';
        add_cin <= '1';
      when others => null;
    end case;
  end process;

  process (add_x, add_y, add_inv, add_cin)
    variable y : unsigned(32 downto 0);
    variable c : unsigned(33 downto 0);
  begin
    y := add_y;
    if add_inv = '1' then
      y := not add_y;
    end if;
    c := (0 => add_cin, others => '0');
    add_s <= ('0' & add_x) + ('0' & y) + c;
  end process;

  ---------------------------------------------------------------------------
  -- floating point
  ---------------------------------------------------------------------------
  fpu_op <= f_fn(4 downto 0) - 16#0E#;

  fpu : entity work.cupu_fpu
    port map (
      clk   => clk,
      rst   => rst,
      start => fpu_start,
      op    => fpu_op(3 downto 0),
      a     => std_logic_vector(opa),
      b     => std_logic_vector(opb),
      res   => fpu_res,
      done  => fpu_done
    );

  ---------------------------------------------------------------------------
  -- memory access: external SPI RAM below 0x01000000, mmio above
  ---------------------------------------------------------------------------
  acc_addr <= pc when state = S_FETCH else opa;
  acc_req  <= '1' when state = S_FETCH or state = S_MEM else '0';
  process (state, f_fn)
  begin
    if state = S_FETCH then
      acc_size <= "10";
    else
      case f_fn(2 downto 0) is
        when "000" | "011" => acc_size <= "10";  -- lw / sw
        when "001" | "100" => acc_size <= "01";  -- lh / sh
        when others        => acc_size <= "00";  -- lb / sb
      end case;
    end if;
  end process;

  mmio_sel  <= '0' when acc_addr(31 downto 24) = 0 else '1';
  mem_req   <= acc_req and not mmio_sel;
  mem_we    <= '1' when state = S_MEM and op = OP_STORE else '0';
  mem_size  <= acc_size;
  mem_addr  <= std_logic_vector(acc_addr(23 downto 0));
  mem_wdata <= std_logic_vector(opb);
  -- a load of the keyboard byte blocks until a key is there, like the emulator's channel
  acc_done  <= mem_done when mmio_sel = '0' else not (kbd_hit and not kbd_valid);
  kbd_take  <= '1' when state = S_MEM and op = OP_LOAD and kbd_hit = '1' and kbd_valid = '1' else '0';

  process (acc_addr, acc_size, state, op)
    variable off, n : natural;
  begin
    off := to_integer(acc_addr(3 downto 0));
    case acc_size is
      when "00"   => n := 1;
      when "01"   => n := 2;
      when others => n := 4;
    end case;
    kbd_hit <= '0';
    if acc_addr(31 downto 4) = MMIO_BASE and off <= 4 and off + n > 4
       and not (state = S_MEM and op = OP_STORE) then
      kbd_hit <= '1';
    end if;
  end process;

  -- mmio is read byte by byte like the emulator, so unaligned accesses behave the same
  process (acc_addr, acc_size, seconds, kbd_data, gpio)
    variable off : unsigned(4 downto 0);
    variable b   : std_logic_vector(7 downto 0);
    variable r   : std_logic_vector(31 downto 0);
  begin
    r := (others => '0');
    for k in 0 to 3 loop
      off := ('0' & acc_addr(3 downto 0)) + k;
      b   := (others => '0');
      if acc_addr(31 downto 4) = MMIO_BASE then
        case to_integer(off) is
          when 0      => b := std_logic_vector(seconds(7 downto 0));
          when 1      => b := std_logic_vector(seconds(15 downto 8));
          when 2      => b := std_logic_vector(seconds(23 downto 16));
          when 3      => b := std_logic_vector(seconds(31 downto 24));
          when 4      => b := '0' & kbd_data;
          when 8      => b := gpio;
          when others => null;
        end case;
      end if;
      r(8 * k + 7 downto 8 * k) := b;
    end loop;
    case acc_size is
      when "00"   => r(31 downto 8) := (others => '0');
      when "01"   => r(31 downto 16) := (others => '0');
      when others => null;
    end case;
    mmio_rd <= unsigned(r);
  end process;

  acc_rdata <= unsigned(mem_rdata) when mmio_sel = '0' else mmio_rd;

  gpio_out <= gpio;
  halted   <= '1' when state = S_HALT else '0';

  ---------------------------------------------------------------------------
  -- seconds counter: counts from reset; a word store to 0x20000000 sets it
  -- (e.g. to unix time, which is what the emulator returns)
  ---------------------------------------------------------------------------
  ts_we <= '1' when state = S_MEM and op = OP_STORE and acc_addr = x"20000000" and acc_size = "10" else '0';

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        prescale <= 0;
        seconds  <= (others => '0');
      elsif ts_we = '1' then
        prescale <= 0;
        seconds  <= opb;
      elsif prescale = G_CLK_HZ - 1 then
        prescale <= 0;
        seconds  <= seconds + 1;
      else
        prescale <= prescale + 1;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- keyboard: a rising edge on ui_in(7) latches the 7-bit character on ui_in(6:0)
  ---------------------------------------------------------------------------
  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        kbd_sync  <= (others => '0');
        kbd_valid <= '0';
        kbd_data  <= (others => '0');
      else
        kbd_sync <= kbd_sync(1 downto 0) & kbd_in(7);
        if kbd_sync(1) = '1' and kbd_sync(2) = '0' then
          kbd_data  <= kbd_in(6 downto 0);
          kbd_valid <= '1';
        elsif kbd_take = '1' then
          kbd_valid <= '0';
        end if;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- register file write; S_CLEAR zeroes it after reset, one register per cycle
  ---------------------------------------------------------------------------
  process (clk)
  begin
    if rising_edge(clk) then
      if state = S_CLEAR then
        regs(to_integer(cnt)) <= (others => '0');
      elsif (state = S_WB or state = S_WBJ) and f_t /= 0 then
        regs(to_integer(f_t)) <= wb_val;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- control
  ---------------------------------------------------------------------------
  process (clk)
    variable ge, eq : std_logic;
    variable signd  : std_logic;
  begin
    if rising_edge(clk) then
      fpu_start <= '0';
      if rst = '1' then
        state <= S_CLEAR;
        cnt   <= (others => '0');
        pc    <= (others => '0');
        flag  <= '0';
        gpio  <= (others => '0');
      else
        ge    := add_s(33);  -- no borrow from opa - opb
        eq    := '1' when opa = opb else '0';
        signd := '0' when op = OP_DIVU else '1';

        case state is
          when S_FETCH =>
            if acc_done = '1' then
              ir    <= acc_rdata;
              state <= S_RA;
            end if;

          when S_RA =>
            opa   <= rf_rd;
            state <= S_RB;

          when S_RB =>
            if f_opc = 0 then
              opb <= rf_rd;
            elsif f_opc(4 downto 3) = "11" then
              opb <= resize(ir(15 downto 0), 32);                    -- 0x18..0x1E
            else
              opb <= unsigned(resize(signed(ir(15 downto 0)), 32));  -- 0x08..0x11
            end if;
            state <= S_EXEC;

          when S_EXEC =>
            state <= S_WB;
            if f_cond = '1' and flag = '0' then
              state <= S_NEXT;
            else
              case op is
                when OP_ADD | OP_SUB => acc <= add_s(31 downto 0);
                when OP_OR   => acc <= opa or opb;
                when OP_AND  => acc <= opa and opb;
                when OP_XOR  => acc <= opa xor opb;
                when OP_NOT  => acc <= not opa;
                when OP_OVRF => acc <= (0 => add_s(32), others => '0');
                when OP_UNRF => acc <= (0 => (not ge) or eq, others => '0');
                when OP_FPU =>
                  fpu_start <= '1';
                  state     <= S_FPU;
                when OP_LUI  => acc <= opb(15 downto 0) & x"0000";

                when OP_CMP =>
                  case f_fn(2 downto 0) is
                    when "000"  => flag <= eq;
                    when "001"  => flag <= not eq;
                    when "010"  => flag <= ge and not eq;
                    when "011"  => flag <= ge;
                    when "100"  => flag <= not ge;
                    when others => flag <= (not ge) or eq;
                  end case;
                  state <= S_NEXT;

                when OP_MUL | OP_MHI =>
                  acc   <= (others => '0');
                  cnt   <= (others => '0');
                  state <= S_MUL;

                when OP_DIV | OP_DIVU | OP_REM =>
                  if opb = 0 then
                    state <= S_HALT;  -- the emulator panics
                  else
                    state <= S_DIV_NA;
                  end if;

                when OP_SHL | OP_SHR =>
                  if opb(31 downto 5) /= 0 then
                    acc <= (others => '0');
                  else
                    acc   <= opa;
                    cnt   <= opb(4 downto 0);
                    state <= S_SHIFT;
                  end if;

                when OP_LOAD | OP_STORE =>
                  state <= S_MEM;

                when OP_JAL =>
                  acc   <= pc_inc;
                  pc    <= add_s(31 downto 0);
                  state <= S_WBJ;

                when OP_JRAL =>
                  opa   <= add_s(31 downto 0);  -- imm + $a, then pc + that
                  state <= S_JRAL;

                when OP_HLT =>
                  state <= S_HALT;

                when OP_NOP =>
                  state <= S_NEXT;
              end case;
            end if;

          when S_JRAL =>
            acc   <= pc_inc;
            pc    <= add_s(31 downto 0);
            state <= S_WBJ;

          when S_MUL =>
            acc <= add_s(32 downto 1);
            opa <= add_s(0) & opa(31 downto 1);
            cnt <= cnt + 1;
            if cnt = 31 then
              state <= S_WB;
            end if;

          when S_DIV_NA =>
            sgn_q <= signd and (opa(31) xor opb(31));
            sgn_r <= signd and opa(31);
            if signd = '1' and opa(31) = '1' then
              opa <= add_s(31 downto 0);
            end if;
            state <= S_DIV_NB;

          when S_DIV_NB =>
            if signd = '1' and opb(31) = '1' then
              opb <= add_s(31 downto 0);
            end if;
            acc   <= (others => '0');
            cnt   <= (others => '0');
            state <= S_DIV;

          when S_DIV =>
            -- restoring division on magnitudes: quotient shifts into opa, remainder in acc
            if ge = '1' then
              acc <= add_s(31 downto 0);
            else
              acc <= acc(30 downto 0) & opa(31);
            end if;
            opa <= opa(30 downto 0) & ge;
            cnt <= cnt + 1;
            if cnt = 31 then
              state <= S_DIV_FQ;
            end if;

          when S_DIV_FQ =>
            if sgn_q = '1' then
              opa <= add_s(31 downto 0);
            end if;
            state <= S_DIV_FR;

          when S_DIV_FR =>
            if sgn_r = '1' then
              acc <= add_s(31 downto 0);
            end if;
            state <= S_WB;

          when S_SHIFT =>
            if cnt = 0 then
              state <= S_WB;
            else
              if f_fn(0) = '0' then
                acc <= acc(30 downto 0) & '0';
              else
                acc <= '0' & acc(31 downto 1);
              end if;
              cnt <= cnt - 1;
            end if;

          when S_MEM =>
            if acc_done = '1' then
              if op = OP_LOAD then
                acc   <= acc_rdata;
                state <= S_WB;
              else
                if mmio_sel = '1' and opa = x"20000008" then
                  gpio <= std_logic_vector(opb(7 downto 0));
                end if;
                state <= S_NEXT;
              end if;
            end if;

          when S_WB | S_NEXT =>
            pc    <= pc_inc;
            state <= S_FETCH;

          when S_WBJ =>
            state <= S_FETCH;

          when S_FPU =>
            if fpu_done = '1' then
              acc   <= unsigned(fpu_res);
              state <= S_WB;
            end if;

          when S_CLEAR =>
            cnt <= cnt + 1;
            if cnt = 31 then
              state <= S_FETCH;
            end if;

          when S_HALT =>
            null;
        end case;
      end if;
    end if;
  end process;
end architecture;
