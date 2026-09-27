`default_nettype none
`timescale 1ns / 1ps

/* Testbench for CUPU-II: the TT top level plus the two PSRAMs of the QSPI Pmod.
   test.py loads the program with a pulse on `load` and reads memory back with `dump`.
   Waveforms are only written with WAVES=1 (the full program runs for millions of cycles).
*/
module tb ();

`ifdef WAVES
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end
`endif

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  wire [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  reg load = 0;
  reg dump = 0;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  tt_um_zonlykroks_cupu user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  wire sck  = uio_out[3];
  wire mosi = uio_out[1];
  wire cs_a = uio_oe[6] ? uio_out[6] : 1'b1;
  wire cs_b = uio_oe[7] ? uio_out[7] : 1'b1;
  wire miso_a, miso_b;

  psram ram_a (.cs_n(cs_a), .sck(sck), .mosi(mosi), .miso(miso_a));
  psram ram_b (.cs_n(cs_b), .sck(sck), .mosi(mosi), .miso(miso_b));

  assign uio_in = {5'b0, (cs_a === 1'b0) ? miso_a : (cs_b === 1'b0) ? miso_b : 1'b0, 2'b0};

  always @(posedge load) $readmemh("prog.hex", ram_a.mem);
  // result area: byte address 0x100000, 64 KiB (the memory is word addressed)
  always @(posedge dump) $writememh("ram_dump.hex", ram_a.mem, 'h40000, 'h43fff);

endmodule

// SPI mode 0 PSRAM: 0x03 read and 0x02 write, 24-bit address, no dummy cycles.
// prog.hex holds 32-bit little endian words, so the memory is loaded as words.
module psram (
    input wire cs_n,
    input wire sck,
    input wire mosi,
    output reg miso
);
  localparam AW = 21;  // 2 MiB is plenty for the tests; addresses wrap

  reg [31:0] mem[0:(1 << (AW - 2)) - 1];
  reg [7:0] cmd;
  reg [23:0] addr;
  reg [7:0] byte_in;
  integer n = 0;
  reg [AW-1:0] a;

  initial miso = 0;

  always @(negedge cs_n) n = 0;

  always @(posedge sck) begin
    if (cs_n === 1'b0) begin
      if (n < 8) cmd = {cmd[6:0], mosi};
      else if (n < 32) addr = {addr[22:0], mosi};
      else if (cmd == 8'h02) begin
        byte_in = {byte_in[6:0], mosi};
        if ((n - 32) % 8 == 7) begin
          a = addr + (n - 32) / 8;
          mem[a[AW-1:2]][8*a[1:0]+:8] = byte_in;
        end
      end
      n = n + 1;
    end
  end

  always @(negedge sck) begin
    if (cs_n === 1'b0 && cmd == 8'h03 && n >= 32) begin
      a = addr + (n - 32) / 8;
      miso <= #5 mem[a[AW-1:2]][8*a[1:0]+7-(n-32)%8];
    end
  end
endmodule
