-- SPI master for the Tiny Tapeout QSPI Pmod (two APS6404L PSRAMs), plain SPI mode 0.
-- Reads use command 0x03, writes 0x02, both with a 24-bit address and no dummy cycles.
-- SCK runs at clk/2. Data is little endian: the byte at addr goes into bits 7..0.
-- addr(23) picks the chip: 0 -> RAM A (cs_n(0)), 1 -> RAM B (cs_n(1)), giving 16 MiB.
-- addr, we, size and wdata must stay stable from req until done.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cupu_spi is
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    req   : in  std_logic;
    we    : in  std_logic;
    size  : in  std_logic_vector(1 downto 0);  -- 00 byte, 01 half, 10 word
    addr  : in  std_logic_vector(23 downto 0);
    wdata : in  std_logic_vector(31 downto 0);
    rdata : out std_logic_vector(31 downto 0);
    done  : out std_logic;                     -- one-cycle pulse, rdata valid with it
    sck   : out std_logic;
    mosi  : out std_logic;
    miso  : in  std_logic;
    cs_n  : out std_logic_vector(1 downto 0)
  );
end entity;

architecture rtl of cupu_spi is
  type state_t is (S_IDLE, S_XFER, S_GAP);
  signal state  : state_t;
  signal sreg   : std_logic_vector(31 downto 0);
  signal bitcnt : unsigned(5 downto 0);
  signal sck_r  : std_logic;
  signal cs_r   : std_logic_vector(1 downto 0);
  signal gap    : unsigned(1 downto 0);
  signal last   : unsigned(5 downto 0);
begin
  sck  <= sck_r;
  mosi <= sreg(31);
  cs_n <= cs_r;

  -- index of the final bit: 32 command/address bits + 8, 16 or 32 data bits
  with size select last <=
    to_unsigned(39, 6) when "00",
    to_unsigned(47, 6) when "01",
    to_unsigned(63, 6) when others;

  process (clk)
    variable sh : std_logic_vector(31 downto 0);
  begin
    if rising_edge(clk) then
      done <= '0';
      if rst = '1' then
        state <= S_IDLE;
        sck_r <= '0';
        cs_r  <= "11";
        rdata <= (others => '0');
      else
        case state is
          when S_IDLE =>
            if req = '1' then
              if we = '1' then
                sreg <= x"02" & addr;
              else
                sreg <= x"03" & addr;
              end if;
              cs_r   <= (not addr(23)) & addr(23);
              bitcnt <= (others => '0');
              state  <= S_XFER;
            end if;

          when S_XFER =>
            if sck_r = '0' then
              sck_r <= '1';
            else
              -- falling edge: sample MISO late for pad-delay margin, shift out next bit
              sck_r <= '0';
              sh := sreg(30 downto 0) & miso;
              if bitcnt = last then
                case size is
                  when "00"   => rdata <= x"000000" & sh(7 downto 0);
                  when "01"   => rdata <= x"0000" & sh(7 downto 0) & sh(15 downto 8);
                  when others => rdata <= sh(7 downto 0) & sh(15 downto 8) & sh(23 downto 16) & sh(31 downto 24);
                end case;
                cs_r  <= "11";
                done  <= '1';
                gap   <= (others => '1');
                state <= S_GAP;
              else
                if bitcnt = 31 and we = '1' then
                  sreg <= wdata(7 downto 0) & wdata(15 downto 8) & wdata(23 downto 16) & wdata(31 downto 24);
                else
                  sreg <= sh;
                end if;
                bitcnt <= bitcnt + 1;
              end if;
            end if;

          when S_GAP =>
            -- keep CS high for a few cycles (PSRAM tCPH) and drop the requester's stale req
            if gap = 0 then
              state <= S_IDLE;
            else
              gap <= gap - 1;
            end if;
        end case;
      end if;
    end if;
  end process;
end architecture;
