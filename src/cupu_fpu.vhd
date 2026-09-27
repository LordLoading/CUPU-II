-- CUPU-II floating point unit: IEEE 754 binary32, round to nearest even.
--
--   op  func  operation
--   0   0x0E  itof   int32 -> float
--   1   0x0F  ftoi   float -> int32, round half away from zero (Go math.Round);
--                    NaN, inf and out of range give 0x80000000
--   2   0x10  fadd
--   3   0x11  fsub
--   4   0x12  fmul
--   5   0x13  fdiv
--   6   0x14  sqrt
--   7   0x15  sin
--   8   0x16  cos
--   9   0x17  tan
--
-- Everything is sequential around one 67-bit adder. Results are exact (correctly rounded)
-- for itof/ftoi/fadd/fsub/fmul/fdiv/sqrt, subnormals included. sin/cos/tan use Payne-Hanek
-- argument reduction and a 62-step CORDIC with 62 fraction bits; they are within 1 ulp and
-- almost always correctly rounded. Every NaN result is 0x7FC00000.
--
-- a and b must stay stable from start until done.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cupu_fpu_pkg.all;

entity cupu_fpu is
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    start : in  std_logic;                     -- one-cycle pulse
    op    : in  unsigned(3 downto 0);
    a     : in  std_logic_vector(31 downto 0);
    b     : in  std_logic_vector(31 downto 0);
    res   : out std_logic_vector(31 downto 0);
    done  : out std_logic                      -- one-cycle pulse, res valid with it
  );
end entity;

architecture rtl of cupu_fpu is
  constant OP_ITOF : natural := 0;
  constant OP_FTOI : natural := 1;
  constant OP_FADD : natural := 2;
  constant OP_FSUB : natural := 3;
  constant OP_FMUL : natural := 4;
  constant OP_FDIV : natural := 5;
  constant OP_SQRT : natural := 6;
  constant OP_SIN  : natural := 7;
  constant OP_COS  : natural := 8;
  constant OP_TAN  : natural := 9;

  constant QNAN    : std_logic_vector(31 downto 0) := x"7FC00000";
  constant ONE_F   : std_logic_vector(31 downto 0) := x"3F800000";
  constant ONE_Q62 : unsigned(65 downto 0) := shift_left(to_unsigned(1, 66), 62);

  type state_t is (
    F_IDLE, F_PRENORM,
    F_ADD_ALIGN, F_ADD_SUM,
    F_FTOI_SHIFT, F_FTOI_RND, F_FTOI_NEG,
    F_MUL, F_DIV, F_SQRT,
    F_TRIG_SMALL, F_PH, F_PH_SHIFT, F_PH_DONE, F_PIMUL, F_TRIG_START,
    F_CA, F_CB, F_CC, F_TRIG_OUT, F_TAN1, F_TAN2,
    F_NORM, F_ROUND, F_DONE
  );
  -- where F_NORM goes when it is done
  type cont_t is (C_ROUND, C_TAN1, C_TAN2);

  subtype exp_t is integer range -1024 to 1023;

  signal state : state_t;
  signal cont  : cont_t;
  signal opn   : natural range 0 to 15;

  signal R, X, Y, Z : unsigned(65 downto 0);
  signal W          : unsigned(91 downto 0);  -- Payne-Hanek accumulator, CORDIC temp
  signal ma, mb     : unsigned(23 downto 0);
  signal ea, eb     : exp_t;
  signal er, ed     : exp_t;  -- R's LSB has weight 2^(er - 65)
  signal sr, stk    : std_logic;
  signal effsub     : std_logic;
  signal cnt        : unsigned(7 downto 0);
  signal quad       : unsigned(1 downto 0);
  signal res_r      : std_logic_vector(31 downto 0);
  signal done_r     : std_logic;

  -- unpacked operands
  signal a_exp, b_exp   : unsigned(7 downto 0);
  signal a_m, b_m       : unsigned(23 downto 0);
  signal a_e, b_e       : exp_t;
  signal a_nan, b_nan   : std_logic;
  signal a_inf, b_inf   : std_logic;
  signal a_zero, b_zero : std_logic;
  signal sa, sb, sbe    : std_logic;

  -- shared adder: add_s = add_x + (add_y xor inv) + inv
  signal add_x, add_y : unsigned(65 downto 0);
  signal add_inv      : std_logic;
  signal add_s        : unsigned(66 downto 0);
  signal add_ge       : std_logic;  -- carry out: add_x >= add_y when subtracting

  signal shifted : unsigned(65 downto 0);  -- CORDIC: X or Y >>> i
  signal atan_i  : unsigned(65 downto 0);

  function unpack_e(e : unsigned(7 downto 0)) return exp_t is
  begin
    if e = 0 then
      return -126;
    end if;
    return to_integer(e) - 127;
  end function;
begin
  res  <= res_r;
  done <= done_r;
  opn  <= to_integer(op);

  a_exp  <= unsigned(a(30 downto 23));
  b_exp  <= unsigned(b(30 downto 23));
  a_m(23) <= '0' when a_exp = 0 else '1';  -- hidden bit
  b_m(23) <= '0' when b_exp = 0 else '1';
  a_m(22 downto 0) <= unsigned(a(22 downto 0));
  b_m(22 downto 0) <= unsigned(b(22 downto 0));
  a_e    <= unpack_e(a_exp);
  b_e    <= unpack_e(b_exp);
  a_nan  <= '1' when a_exp = 255 and unsigned(a(22 downto 0)) /= 0 else '0';
  b_nan  <= '1' when b_exp = 255 and unsigned(b(22 downto 0)) /= 0 else '0';
  a_inf  <= '1' when a_exp = 255 and unsigned(a(22 downto 0)) = 0 else '0';
  b_inf  <= '1' when b_exp = 255 and unsigned(b(22 downto 0)) = 0 else '0';
  a_zero <= '1' when unsigned(a(30 downto 0)) = 0 else '0';
  b_zero <= '1' when unsigned(b(30 downto 0)) = 0 else '0';
  sa     <= a(31);
  sb     <= b(31);
  sbe    <= b(31) xor '1' when opn = OP_FSUB else b(31);

  shifted <= unsigned(shift_right(signed(Y), to_integer(cnt(5 downto 0)))) when state = F_CA else
             unsigned(shift_right(signed(X), to_integer(cnt(5 downto 0))));

  process (cnt)
  begin
    if cnt <= 20 then
      atan_i <= ATAN_TAB(to_integer(cnt(4 downto 0)));
    elsif cnt > 62 then
      atan_i <= (others => '0');
    else
      atan_i <= shift_left(to_unsigned(1, 66), 62 - to_integer(cnt(5 downto 0)));
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- shared adder operands
  ---------------------------------------------------------------------------
  process (state, opn, a, R, X, Y, Z, W, ma, mb, stk, effsub, cnt, shifted, atan_i, quad)
    variable v : unsigned(65 downto 0);
  begin
    add_x   <= (others => '0');
    add_y   <= (others => '0');
    add_inv <= '0';
    case state is
      when F_IDLE =>                              -- itof: |a|
        add_y   <= unsigned(resize(signed(a), 66));
        add_inv <= a(31);
      when F_ADD_SUM =>
        add_x   <= R;
        add_y   <= X;
        add_inv <= effsub;
      when F_FTOI_RND =>
        add_x    <= X;
        add_y(0) <= stk;
      when F_FTOI_NEG =>
        add_y   <= X;
        add_inv <= sa;
      when F_MUL =>
        add_x <= resize(X(47 downto 24), 66);
        if Y(0) = '1' then
          add_y <= resize(mb, 66);
        end if;
      when F_DIV =>
        add_x   <= resize(X(34 downto 0), 66);
        add_y   <= resize(Y(34 downto 0), 66);
        add_inv <= '1';
      when F_SQRT =>
        add_x   <= resize(Y(31 downto 0) & X(55 downto 54), 66);
        add_y   <= resize(Z(27 downto 0) & "01", 66);
        add_inv <= '1';
      when F_PH =>
        add_x <= resize(W(91 downto 68), 66);
        if TWO_OVER_PI(to_integer(cnt)) = '1' then
          add_y <= resize(ma, 66);
        end if;
      when F_PIMUL =>
        add_x <= unsigned(shift_right(signed(Z), 1));
        if PI_HALF(to_integer(cnt(6 downto 0))) = '1' then
          add_y <= X;
        end if;
      -- CORDIC step, rotating towards z = 0:
      --   z >= 0: x -= y>>i, y += x>>i, z -= atan(2^-i)
      --   z <  0: x += y>>i, y -= x>>i, z += atan(2^-i)
      when F_CA =>
        add_x   <= X;
        add_y   <= shifted;
        add_inv <= not Z(65);
      when F_CB =>
        add_x   <= Y;
        add_y   <= shifted;
        add_inv <= Z(65);
      when F_CC =>
        add_x   <= Z;
        add_y   <= atan_i;
        add_inv <= not Z(65);
      when F_TRIG_OUT | F_TAN1 =>
        -- |value| to convert: sin/cos result, or tan's denominator (F_TRIG_OUT)
        -- and numerator (F_TAN1). X = cos r, Y = sin r.
        if (opn = OP_SIN and quad(0) = '0') or (opn = OP_COS and quad(0) = '1') or
           (opn = OP_TAN and (state = F_TRIG_OUT) = (quad(0) = '1')) then
          v := Y;
        else
          v := X;
        end if;
        add_y   <= v;
        add_inv <= v(65);
      when others => null;
    end case;
  end process;

  process (add_x, add_y, add_inv)
    variable yy : unsigned(65 downto 0);
    variable c  : unsigned(66 downto 0);
  begin
    yy := add_y;
    if add_inv = '1' then
      yy := not add_y;
    end if;
    c := (0 => add_inv, others => '0');
    add_s <= ('0' & add_x) + ('0' & yy) + c;
  end process;
  add_ge <= add_s(66);

  ---------------------------------------------------------------------------
  -- control
  ---------------------------------------------------------------------------
  process (clk)
    variable big_is_a : boolean;
    variable d        : exp_t;
    variable t        : exp_t;
    variable mant     : unsigned(24 downto 0);
    variable inc      : std_logic;
    variable sticky   : std_logic;
    variable e2       : exp_t;
    variable v        : unsigned(65 downto 0);
    variable nsign    : std_logic;
    variable dsign    : std_logic;
  begin
    if rising_edge(clk) then
      done_r <= '0';
      if rst = '1' then
        state <= F_IDLE;
      else
        case state is
          -------------------------------------------------------------------
          when F_IDLE =>
            stk  <= '0';
            cont <= C_ROUND;
            ma   <= a_m;
            mb   <= b_m;
            ea   <= a_e;
            eb   <= b_e;
            if start = '1' then
              state <= F_DONE;  -- default for the special cases below
              case opn is
                when OP_ITOF =>
                  if a = x"00000000" then
                    res_r <= (others => '0');
                  else
                    sr    <= a(31);
                    R     <= add_s(65 downto 0);
                    er    <= 65;
                    state <= F_NORM;
                  end if;

                when OP_FTOI =>
                  if a_exp >= 158 then            -- |a| >= 2^31, inf, NaN
                    res_r <= x"80000000";
                  elsif a_exp < 126 then          -- |a| < 0.5
                    res_r <= (others => '0');
                  else
                    X     <= resize(a_m & x"00", 66);
                    cnt   <= to_unsigned(158, 8) - a_exp;
                    state <= F_FTOI_SHIFT;
                  end if;

                when OP_FADD | OP_FSUB =>
                  if a_nan = '1' or b_nan = '1' or (a_inf = '1' and b_inf = '1' and sa /= sbe) then
                    res_r <= QNAN;
                  elsif a_inf = '1' then
                    res_r <= sa & a(30 downto 0);
                  elsif b_inf = '1' then
                    res_r <= sbe & b(30 downto 0);
                  else
                    big_is_a := unsigned(a(30 downto 0)) >= unsigned(b(30 downto 0));
                    R <= (others => '0');
                    X <= (others => '0');
                    if big_is_a then
                      R(64 downto 41) <= a_m;
                      X(64 downto 41) <= b_m;
                      er <= a_e + 1;
                      sr <= sa;
                      d  := a_e - b_e;
                    else
                      R(64 downto 41) <= b_m;
                      X(64 downto 41) <= a_m;
                      er <= b_e + 1;
                      sr <= sbe;
                      d  := b_e - a_e;
                    end if;
                    if d > 50 then
                      d := 50;
                    end if;
                    cnt    <= to_unsigned(d, 8);
                    effsub <= sa xor sbe;
                    state  <= F_ADD_ALIGN;
                  end if;

                when OP_FMUL =>
                  sr <= sa xor sb;
                  if a_nan = '1' or b_nan = '1' or (a_inf = '1' and b_zero = '1') or (a_zero = '1' and b_inf = '1') then
                    res_r <= QNAN;
                  elsif a_inf = '1' or b_inf = '1' then
                    res_r <= (sa xor sb) & "1111111100000000000000000000000";
                  elsif a_zero = '1' or b_zero = '1' then
                    res_r <= (sa xor sb) & "0000000000000000000000000000000";
                  else
                    state <= F_PRENORM;
                  end if;

                when OP_FDIV =>
                  sr <= sa xor sb;
                  if a_nan = '1' or b_nan = '1' or (a_inf = '1' and b_inf = '1') or (a_zero = '1' and b_zero = '1') then
                    res_r <= QNAN;
                  elsif a_inf = '1' or b_zero = '1' then
                    res_r <= (sa xor sb) & "1111111100000000000000000000000";
                  elsif a_zero = '1' or b_inf = '1' then
                    res_r <= (sa xor sb) & "0000000000000000000000000000000";
                  else
                    state <= F_PRENORM;
                  end if;

                when OP_SQRT =>
                  sr <= '0';
                  mb <= x"800000";
                  if a_nan = '1' or (sa = '1' and a_zero = '0') then
                    res_r <= QNAN;
                  elsif a_zero = '1' or a_inf = '1' then
                    res_r <= a;
                  else
                    state <= F_PRENORM;
                  end if;

                when OP_SIN | OP_COS | OP_TAN =>
                  if a_nan = '1' or a_inf = '1' then
                    res_r <= QNAN;
                  elsif a_exp < 115 then          -- |a| < 2^-12
                    if opn = OP_COS then
                      res_r <= ONE_F;
                    else
                      res_r <= a;
                    end if;
                  elsif a_exp < 126 then          -- |a| < 0.5: no reduction needed
                    Z     <= resize(a_m, 66);
                    cnt   <= a_exp - 88;          -- Q3.62: m * 2^(exp - 150 + 62)
                    quad  <= "00";
                    state <= F_TRIG_SMALL;
                  else
                    W     <= (others => '0');
                    cnt   <= a_exp - 58;          -- highest 2/pi bit that matters
                    state <= F_PH;
                  end if;

                when others =>
                  res_r <= QNAN;
              end case;
            end if;

          -------------------------------------------------------------------
          when F_PRENORM =>
            -- make subnormal mantissas start with 1
            if ma(23) = '0' then
              ma <= ma(22 downto 0) & '0';
              ea <= ea - 1;
            elsif mb(23) = '0' then
              mb <= mb(22 downto 0) & '0';
              eb <= eb - 1;
            else
              case opn is
                when OP_FMUL =>
                  X     <= (others => '0');
                  Y     <= resize(ma, 66);
                  cnt   <= to_unsigned(24, 8);
                  state <= F_MUL;
                when OP_FDIV =>
                  X     <= resize(ma & "0000000000", 66);
                  Y     <= resize(mb & "0000000000", 66);
                  R     <= (others => '0');
                  er    <= ea - eb + 38;
                  cnt   <= to_unsigned(28, 8);
                  state <= F_DIV;
                when others =>                    -- sqrt
                  if ea mod 2 = 0 then
                    X  <= shift_left(resize(ma, 66), 31);
                    er <= ea / 2 + 38;
                  else
                    X  <= shift_left(resize(ma, 66), 32);
                    er <= (ea - 1) / 2 + 38;
                  end if;
                  Y     <= (others => '0');
                  Z     <= (others => '0');
                  cnt   <= to_unsigned(28, 8);
                  state <= F_SQRT;
              end case;
            end if;

          -------------------------------------------------------------------
          when F_ADD_ALIGN =>
            -- shift the smaller operand right, folding lost bits into bit 0
            if cnt = 0 then
              state <= F_ADD_SUM;
            else
              X   <= '0' & X(65 downto 2) & (X(1) or X(0));
              cnt <= cnt - 1;
            end if;

          when F_ADD_SUM =>
            R <= add_s(65 downto 0);
            if add_s(65 downto 0) = 0 then
              sr <= sa and sbe;  -- exact zero: -0 only for (-0) + (-0)
            end if;
            state <= F_NORM;

          -------------------------------------------------------------------
          when F_FTOI_SHIFT =>
            if cnt = 0 then
              state <= F_FTOI_RND;
            else
              X   <= '0' & X(65 downto 1);
              stk <= X(0);  -- last bit shifted out = the 0.5 bit
              cnt <= cnt - 1;
            end if;

          when F_FTOI_RND =>
            X     <= add_s(65 downto 0);
            state <= F_FTOI_NEG;

          when F_FTOI_NEG =>
            res_r <= std_logic_vector(add_s(31 downto 0));
            state <= F_DONE;

          -------------------------------------------------------------------
          when F_MUL =>
            -- shift-add: X(47:0) accumulates ma * mb, Y feeds ma's bits LSB first
            if cnt = 0 then
              R     <= X;
              er    <= ea + eb + 19;
              state <= F_NORM;
            else
              X(47 downto 0) <= add_s(24 downto 0) & X(23 downto 1);
              Y   <= '0' & Y(65 downto 1);
              cnt <= cnt - 1;
            end if;

          when F_DIV =>
            -- restoring division; quotient bits shift into R
            if cnt = 0 then
              if X /= 0 then
                stk <= '1';
              end if;
              state <= F_NORM;
            else
              R <= R(64 downto 0) & add_ge;
              if add_ge = '1' then
                X <= add_s(64 downto 0) & '0';
              else
                X <= X(64 downto 0) & '0';
              end if;
              cnt <= cnt - 1;
            end if;

          when F_SQRT =>
            -- digit by digit: two radicand bits per step from X, remainder Y, root Z
            if cnt = 0 then
              R <= Z;
              if Y /= 0 then
                stk <= '1';
              end if;
              state <= F_NORM;
            else
              if add_ge = '1' then
                Y <= add_s(65 downto 0);
              else
                Y <= resize(Y(31 downto 0) & X(55 downto 54), 66);
              end if;
              Z   <= Z(64 downto 0) & add_ge;
              X   <= X(63 downto 0) & "00";
              cnt <= cnt - 1;
            end if;

          -------------------------------------------------------------------
          -- sin / cos / tan
          -------------------------------------------------------------------
          when F_TRIG_SMALL =>
            if cnt = 0 then
              state <= F_TRIG_START;
            else
              Z   <= Z(64 downto 0) & '0';
              cnt <= cnt - 1;
            end if;

          when F_PH =>
            -- Payne-Hanek: W = sum of 2/pi bits * mantissa, LSB first, giving
            -- |a| * 2/pi mod 4 in Q2.66 (W(67 downto 0)) at the end
            W <= add_s(24 downto 0) & W(67 downto 1);
            t := to_integer(a_exp) - 151;       -- lowest bit that matters, at least 1
            if t < 1 then
              t := 1;
            end if;
            if to_integer(cnt) = t then
              if a_exp < 152 then
                cnt <= to_unsigned(152, 8) - a_exp;
              else
                cnt <= (others => '0');
              end if;
              state <= F_PH_SHIFT;
            else
              cnt <= cnt - 1;
            end if;

          when F_PH_SHIFT =>
            if cnt = 0 then
              state <= F_PH_DONE;
            else
              W   <= '0' & W(91 downto 1);
              cnt <= cnt - 1;
            end if;

          when F_PH_DONE =>
            -- nearest quadrant, and the signed remainder in [-0.5, 0.5) quarter turns
            quad  <= W(67 downto 66) + ("0" & W(65));
            X     <= unsigned(shift_right(signed(W(65 downto 0)), 4));  -- Q3.62
            Z     <= (others => '0');
            cnt   <= to_unsigned(64, 8);
            state <= F_PIMUL;

          when F_PIMUL =>
            -- Z = X * pi/2, pi/2's bits LSB first
            Z <= add_s(65 downto 0);
            if cnt = 0 then
              state <= F_TRIG_START;
            else
              cnt <= cnt - 1;
            end if;

          when F_TRIG_START =>
            -- Z = reduced angle r in radians, |r| <= pi/4
            if Z(65 downto 42) = 0 or not Z(65 downto 42) = 0 then
              X     <= ONE_Q62;     -- |r| < 2^-20: cos r = 1, sin r = r to well below 1 ulp
              Y     <= Z;
              state <= F_TRIG_OUT;
            else
              X     <= CORDIC_K;
              Y     <= (others => '0');
              cnt   <= (others => '0');
              state <= F_CA;
            end if;

          when F_CA =>
            W(65 downto 0) <= add_s(65 downto 0);   -- new X, parked
            state          <= F_CB;

          when F_CB =>
            Y     <= add_s(65 downto 0);
            state <= F_CC;

          when F_CC =>
            X <= W(65 downto 0);
            Z <= add_s(65 downto 0);
            if cnt = 61 then
              state <= F_TRIG_OUT;
            else
              cnt   <= cnt + 1;
              state <= F_CA;
            end if;

          when F_TRIG_OUT =>
            -- sin: q0 +sin q1 +cos q2 -sin q3 -cos, then odd in a
            -- cos: q0 +cos q1 -sin q2 -cos q3 +sin
            -- tan: q even +sin/cos, q odd -cos/sin, then odd in a
            -- the adder is already producing |value| (see operand process)
            if opn = OP_TAN then
              if quad(0) = '0' then
                nsign := Y(65);
                dsign := X(65);
              else
                nsign := X(65);
                dsign := Y(65);
              end if;
              sr   <= nsign xor dsign xor quad(0) xor sa;
              cont <= C_TAN1;                 -- normalise the denominator first
            elsif opn = OP_SIN then
              if quad(0) = '0' then v := Y; else v := X; end if;
              sr <= v(65) xor quad(1) xor sa;
            else
              if quad(0) = '0' then v := X; else v := Y; end if;
              sr <= v(65) xor (quad(1) xor quad(0));
            end if;
            R     <= add_s(65 downto 0);
            er    <= 3;
            stk   <= '0';
            state <= F_NORM;

          when F_TAN1 =>
            -- normalised denominator is in R; park it in Z, normalise the numerator
            Z     <= R;
            ed    <= er;
            R     <= add_s(65 downto 0);
            er    <= 3;
            cont  <= C_TAN2;
            state <= F_NORM;

          when F_TAN2 =>
            X     <= resize(R(65 downto 32), 66);
            Y     <= resize(Z(65 downto 32), 66);
            er    <= er - ed + 38;
            R     <= (others => '0');
            cnt   <= to_unsigned(28, 8);
            cont  <= C_ROUND;
            state <= F_DIV;

          -------------------------------------------------------------------
          -- normalise and round R * 2^(er - 65)
          -------------------------------------------------------------------
          when F_NORM =>
            if cont /= C_ROUND then
              if R(65) = '0' and R /= 0 then
                R  <= R(64 downto 0) & '0';
                er <= er - 1;
              elsif cont = C_TAN1 then
                state <= F_TAN1;
              else
                state <= F_TAN2;
              end if;
            elsif R = 0 then
              state <= F_ROUND;
            elsif er < -126 then
              R   <= '0' & R(65 downto 1);
              stk <= stk or R(0);
              er  <= er + 1;
            elsif R(65) = '0' and er > -126 then
              R  <= R(64 downto 0) & '0';
              er <= er - 1;
            else
              state <= F_ROUND;
            end if;

          when F_ROUND =>
            sticky := stk;
            if R(40 downto 0) /= 0 then
              sticky := '1';
            end if;
            inc  := R(41) and (sticky or R(42));
            mant := '0' & R(65 downto 42);
            if inc = '1' then
              mant := mant + 1;
            end if;
            e2   := er;
            if mant(24) = '1' then
              mant := '0' & mant(24 downto 1);
              e2   := er + 1;
            end if;
            if R = 0 and stk = '0' then
              res_r <= sr & "0000000000000000000000000000000";
            elsif mant(23) = '0' then
              res_r <= sr & "00000000" & std_logic_vector(mant(22 downto 0));
            elsif e2 > 127 then
              res_r <= sr & "1111111100000000000000000000000";
            else
              res_r <= sr & std_logic_vector(to_unsigned(e2 + 127, 8)) & std_logic_vector(mant(22 downto 0));
            end if;
            state <= F_DONE;

          when F_DONE =>
            done_r <= '1';
            state  <= F_IDLE;
        end case;
      end if;
    end if;
  end process;
end architecture;
