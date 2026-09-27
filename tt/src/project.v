module cupu_spi_Brtl
  (input  clk,
   input  rst,
   input  req,
   input  we,
   input  [1:0] size,
   input  [23:0] addr,
   input  [31:0] wdata,
   output [31:0] rdata,
   output done,
   output sck,
   output mosi,
   input  miso,
   output [1:0] cs_n);
  wire [1:0] state;
  wire [31:0] sreg;
  wire [5:0] bitcnt;
  wire sck_r;
  wire [1:0] cs_r;
  wire [1:0] gap;
  wire [5:0] last;
  wire n1020;
  wire n1023;
  wire n1026;
  wire [1:0] n1028;
  reg [5:0] n1029;
  wire [31:0] n1035;
  wire [31:0] n1037;
  wire [31:0] n1038;
  wire n1039;
  wire n1040;
  wire n1041;
  wire [1:0] n1042;
  wire [1:0] n1044;
  wire [31:0] n1045;
  wire [5:0] n1047;
  wire [1:0] n1048;
  wire n1050;
  wire n1051;
  wire [30:0] n1052;
  wire [31:0] n1053;
  wire n1054;
  wire [7:0] n1055;
  wire [31:0] n1057;
  wire n1059;
  wire [7:0] n1060;
  wire [23:0] n1062;
  wire [7:0] n1063;
  wire [31:0] n1064;
  wire n1066;
  wire [7:0] n1067;
  wire [7:0] n1068;
  wire [15:0] n1069;
  wire [7:0] n1070;
  wire [23:0] n1071;
  wire [7:0] n1072;
  wire [31:0] n1073;
  wire [1:0] n1074;
  reg [31:0] n1075;
  wire n1077;
  wire n1078;
  wire [7:0] n1079;
  wire [7:0] n1080;
  wire [15:0] n1081;
  wire [7:0] n1082;
  wire [23:0] n1083;
  wire [7:0] n1084;
  wire [31:0] n1085;
  wire [31:0] n1086;
  wire [5:0] n1088;
  wire [31:0] n1089;
  wire n1092;
  wire [1:0] n1094;
  wire [31:0] n1095;
  wire [5:0] n1096;
  wire [1:0] n1098;
  wire [1:0] n1100;
  wire [31:0] n1101;
  wire n1103;
  wire [1:0] n1104;
  wire [31:0] n1105;
  wire [5:0] n1106;
  wire n1109;
  wire [1:0] n1110;
  wire [1:0] n1111;
  wire n1114;
  wire n1116;
  wire [1:0] n1118;
  wire [1:0] n1120;
  wire [1:0] n1121;
  wire n1123;
  wire [2:0] n1124;
  reg [31:0] n1126;
  reg n1129;
  reg [1:0] n1131;
  reg [31:0] n1133;
  reg [5:0] n1135;
  reg n1137;
  reg [1:0] n1139;
  reg [1:0] n1141;
  wire [31:0] n1145;
  wire n1147;
  wire [1:0] n1150;
  wire [31:0] n1151;
  wire [5:0] n1152;
  wire n1154;
  wire [1:0] n1156;
  wire [1:0] n1157;
  reg [31:0] n1169;
  reg n1170;
  reg [1:0] n1171;
  reg [31:0] n1172;
  reg [5:0] n1173;
  reg n1174;
  reg [1:0] n1175;
  reg [1:0] n1176;
  assign rdata = n1169; //(module output)
  assign done = n1170; //(module output)
  assign sck = sck_r; //(module output)
  assign mosi = n1020; //(module output)
  assign cs_n = cs_r; //(module output)
  /*# cupu_spi.vhd:31:10 */
  assign state = n1171; // (signal)
  /*# cupu_spi.vhd:32:10 */
  assign sreg = n1172; // (signal)
  /*# cupu_spi.vhd:33:10 */
  assign bitcnt = n1173; // (signal)
  /*# cupu_spi.vhd:34:10 */
  assign sck_r = n1174; // (signal)
  /*# cupu_spi.vhd:35:10 */
  assign cs_r = n1175; // (signal)
  /*# cupu_spi.vhd:36:10 */
  assign gap = n1176; // (signal)
  /*# cupu_spi.vhd:37:10 */
  assign last = n1029; // (signal)
  /*# cupu_spi.vhd:40:15 */
  assign n1020 = sreg[31]; // extract
  /*# cupu_spi.vhd:45:24 */
  assign n1023 = size == 2'b00;
  /*# cupu_spi.vhd:46:24 */
  assign n1026 = size == 2'b01;
  /*# cupu_spi.vhd:44:3 */
  assign n1028 = {n1026, n1023};
  /*# cupu_spi.vhd:44:3 */
  always @*
    case (n1028)
      2'b10: n1029 = 6'b101111;
      2'b01: n1029 = 6'b100111;
      default: n1029 = 6'b111111;
    endcase
  /*# cupu_spi.vhd:64:31 */
  assign n1035 = {8'b00000010, addr};
  /*# cupu_spi.vhd:66:31 */
  assign n1037 = {8'b00000011, addr};
  /*# cupu_spi.vhd:63:15 */
  assign n1038 = we ? n1035 : n1037;
  /*# cupu_spi.vhd:68:34 */
  assign n1039 = addr[23]; // extract
  /*# cupu_spi.vhd:68:26 */
  assign n1040 = ~n1039;
  /*# cupu_spi.vhd:68:46 */
  assign n1041 = addr[23]; // extract
  /*# cupu_spi.vhd:68:40 */
  assign n1042 = {n1040, n1041};
  /*# cupu_spi.vhd:62:13 */
  assign n1044 = req ? 2'b01 : state;
  /*# cupu_spi.vhd:62:13 */
  assign n1045 = req ? n1038 : sreg;
  /*# cupu_spi.vhd:62:13 */
  assign n1047 = req ? 6'b000000 : bitcnt;
  /*# cupu_spi.vhd:62:13 */
  assign n1048 = req ? n1042 : cs_r;
  /*# cupu_spi.vhd:61:11 */
  assign n1050 = state == 2'b00;
  /*# cupu_spi.vhd:74:22 */
  assign n1051 = ~sck_r;
  /*# cupu_spi.vhd:79:25 */
  assign n1052 = sreg[30:0]; // extract
  /*# cupu_spi.vhd:79:39 */
  assign n1053 = {n1052, miso};
  /*# cupu_spi.vhd:80:25 */
  assign n1054 = bitcnt == last;
  /*# cupu_spi.vhd:82:57 */
  assign n1055 = n1053[7:0]; // extract
  /*# cupu_spi.vhd:82:53 */
  assign n1057 = {24'b000000000000000000000000, n1055};
  /*# cupu_spi.vhd:82:19 */
  assign n1059 = size == 2'b00;
  /*# cupu_spi.vhd:83:55 */
  assign n1060 = n1053[7:0]; // extract
  /*# cupu_spi.vhd:83:51 */
  assign n1062 = {16'b0000000000000000, n1060};
  /*# cupu_spi.vhd:83:72 */
  assign n1063 = n1053[15:8]; // extract
  /*# cupu_spi.vhd:83:68 */
  assign n1064 = {n1062, n1063};
  /*# cupu_spi.vhd:83:19 */
  assign n1066 = size == 2'b01;
  /*# cupu_spi.vhd:84:45 */
  assign n1067 = n1053[7:0]; // extract
  /*# cupu_spi.vhd:84:62 */
  assign n1068 = n1053[15:8]; // extract
  /*# cupu_spi.vhd:84:58 */
  assign n1069 = {n1067, n1068};
  /*# cupu_spi.vhd:84:80 */
  assign n1070 = n1053[23:16]; // extract
  /*# cupu_spi.vhd:84:76 */
  assign n1071 = {n1069, n1070};
  /*# cupu_spi.vhd:84:99 */
  assign n1072 = n1053[31:24]; // extract
  /*# cupu_spi.vhd:84:95 */
  assign n1073 = {n1071, n1072};
  /*# cupu_spi.vhd:81:17 */
  assign n1074 = {n1066, n1059};
  /*# cupu_spi.vhd:81:17 */
  always @*
    case (n1074)
      2'b10: n1075 = n1064;
      2'b01: n1075 = n1057;
      default: n1075 = n1073;
    endcase
  /*# cupu_spi.vhd:91:27 */
  assign n1077 = bitcnt == 6'b011111;
  /*# cupu_spi.vhd:91:32 */
  assign n1078 = we & n1077;
  /*# cupu_spi.vhd:92:32 */
  assign n1079 = wdata[7:0]; // extract
  /*# cupu_spi.vhd:92:52 */
  assign n1080 = wdata[15:8]; // extract
  /*# cupu_spi.vhd:92:45 */
  assign n1081 = {n1079, n1080};
  /*# cupu_spi.vhd:92:73 */
  assign n1082 = wdata[23:16]; // extract
  /*# cupu_spi.vhd:92:66 */
  assign n1083 = {n1081, n1082};
  /*# cupu_spi.vhd:92:95 */
  assign n1084 = wdata[31:24]; // extract
  /*# cupu_spi.vhd:92:88 */
  assign n1085 = {n1083, n1084};
  /*# cupu_spi.vhd:91:17 */
  assign n1086 = n1078 ? n1085 : n1053;
  /*# cupu_spi.vhd:96:34 */
  assign n1088 = bitcnt + 6'b000001;
  /*# cupu_spi.vhd:80:15 */
  assign n1089 = n1054 ? n1075 : n1169;
  /*# cupu_spi.vhd:80:15 */
  assign n1092 = n1054 ? 1'b1 : 1'b0;
  /*# cupu_spi.vhd:80:15 */
  assign n1094 = n1054 ? 2'b10 : state;
  /*# cupu_spi.vhd:80:15 */
  assign n1095 = n1054 ? sreg : n1086;
  /*# cupu_spi.vhd:80:15 */
  assign n1096 = n1054 ? bitcnt : n1088;
  /*# cupu_spi.vhd:80:15 */
  assign n1098 = n1054 ? 2'b11 : cs_r;
  /*# cupu_spi.vhd:80:15 */
  assign n1100 = n1054 ? 2'b11 : gap;
  /*# cupu_spi.vhd:74:13 */
  assign n1101 = n1051 ? n1169 : n1089;
  /*# cupu_spi.vhd:74:13 */
  assign n1103 = n1051 ? 1'b0 : n1092;
  /*# cupu_spi.vhd:74:13 */
  assign n1104 = n1051 ? state : n1094;
  /*# cupu_spi.vhd:74:13 */
  assign n1105 = n1051 ? sreg : n1095;
  /*# cupu_spi.vhd:74:13 */
  assign n1106 = n1051 ? bitcnt : n1096;
  /*# cupu_spi.vhd:74:13 */
  assign n1109 = n1051 ? 1'b1 : 1'b0;
  /*# cupu_spi.vhd:74:13 */
  assign n1110 = n1051 ? cs_r : n1098;
  /*# cupu_spi.vhd:74:13 */
  assign n1111 = n1051 ? gap : n1100;
  /*# cupu_spi.vhd:73:11 */
  assign n1114 = state == 2'b01;
  /*# cupu_spi.vhd:102:20 */
  assign n1116 = gap == 2'b00;
  /*# cupu_spi.vhd:105:26 */
  assign n1118 = gap - 2'b01;
  /*# cupu_spi.vhd:102:13 */
  assign n1120 = n1116 ? 2'b00 : state;
  /*# cupu_spi.vhd:102:13 */
  assign n1121 = n1116 ? gap : n1118;
  /*# cupu_spi.vhd:100:11 */
  assign n1123 = state == 2'b10;
  /*# cupu_spi.vhd:60:9 */
  assign n1124 = {n1123, n1114, n1050};
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1126 = n1169;
      3'b010: n1126 = n1101;
      3'b001: n1126 = n1169;
      default: n1126 = 32'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1129 = 1'b0;
      3'b010: n1129 = n1103;
      3'b001: n1129 = 1'b0;
      default: n1129 = 1'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1131 = n1120;
      3'b010: n1131 = n1104;
      3'b001: n1131 = n1044;
      default: n1131 = 2'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1133 = sreg;
      3'b010: n1133 = n1105;
      3'b001: n1133 = n1045;
      default: n1133 = 32'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1135 = bitcnt;
      3'b010: n1135 = n1106;
      3'b001: n1135 = n1047;
      default: n1135 = 6'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1137 = sck_r;
      3'b010: n1137 = n1109;
      3'b001: n1137 = sck_r;
      default: n1137 = 1'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1139 = cs_r;
      3'b010: n1139 = n1110;
      3'b001: n1139 = n1048;
      default: n1139 = 2'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1124)
      3'b100: n1141 = n1121;
      3'b010: n1141 = n1111;
      3'b001: n1141 = gap;
      default: n1141 = 2'bX;
    endcase
  /*# cupu_spi.vhd:54:7 */
  assign n1145 = rst ? 32'b00000000000000000000000000000000 : n1126;
  /*# cupu_spi.vhd:54:7 */
  assign n1147 = rst ? 1'b0 : n1129;
  /*# cupu_spi.vhd:54:7 */
  assign n1150 = rst ? 2'b00 : n1131;
  /*# cupu_spi.vhd:54:7 */
  assign n1151 = rst ? sreg : n1133;
  /*# cupu_spi.vhd:54:7 */
  assign n1152 = rst ? bitcnt : n1135;
  /*# cupu_spi.vhd:54:7 */
  assign n1154 = rst ? 1'b0 : n1137;
  /*# cupu_spi.vhd:54:7 */
  assign n1156 = rst ? 2'b11 : n1139;
  /*# cupu_spi.vhd:54:7 */
  assign n1157 = rst ? gap : n1141;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1169 <= n1145;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1170 <= n1147;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1171 <= n1150;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1172 <= n1151;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1173 <= n1152;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1174 <= n1154;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1175 <= n1156;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1176 <= n1157;
endmodule

module cupu_core_Brtl_25000000
  (input  clk,
   input  rst,
   output mem_req,
   output mem_we,
   output [1:0] mem_size,
   output [23:0] mem_addr,
   output [31:0] mem_wdata,
   input  [31:0] mem_rdata,
   input  mem_done,
   input  [7:0] kbd_in,
   output [7:0] gpio_out,
   output halted);
  wire [4:0] state;
  wire [31:0] pc;
  wire [31:0] ir;
  wire [31:0] opa;
  wire [31:0] opb;
  wire [31:0] acc;
  wire [4:0] cnt;
  wire flag;
  wire sgn_q;
  wire sgn_r;
  wire f_cond;
  wire [4:0] f_opc;
  wire [4:0] f_t;
  wire [4:0] f_a;
  wire [4:0] f_b;
  wire [10:0] f_fn;
  wire [4:0] op;
  wire [4:0] rf_idx;
  wire [31:0] rf_rd;
  wire [31:0] wb_val;
  wire [31:0] pc_inc;
  wire [32:0] add_x;
  wire [32:0] add_y;
  wire add_inv;
  wire add_cin;
  wire [33:0] add_s;
  wire [31:0] acc_addr;
  wire [1:0] acc_size;
  wire acc_req;
  wire mmio_sel;
  wire [31:0] mmio_rd;
  wire acc_done;
  wire [31:0] acc_rdata;
  wire [7:0] gpio;
  wire [31:0] seconds;
  wire [24:0] prescale;
  wire n34;
  wire [4:0] n35;
  wire [4:0] n36;
  wire [4:0] n37;
  wire [4:0] n38;
  wire [10:0] n39;
  wire n43;
  wire [30:0] n44;
  wire n46;
  wire n48;
  wire n50;
  wire n52;
  wire n54;
  wire n56;
  wire n58;
  wire n60;
  wire n62;
  wire n64;
  wire n66;
  wire n68;
  wire n70;
  wire n72;
  wire n75;
  wire n76;
  wire n77;
  wire n80;
  wire n81;
  wire n82;
  wire n85;
  wire n86;
  wire n87;
  wire n90;
  wire n91;
  wire n92;
  wire n94;
  wire [18:0] n95;
  reg [4:0] n116;
  wire [30:0] n117;
  wire n119;
  wire n121;
  wire n122;
  wire n124;
  wire n126;
  wire n127;
  wire n129;
  wire n131;
  wire n132;
  wire n134;
  wire n136;
  wire n138;
  wire n140;
  wire n141;
  wire n143;
  wire n145;
  wire n146;
  wire n148;
  wire n150;
  wire n151;
  wire n153;
  wire n155;
  wire n157;
  wire [10:0] n158;
  reg [4:0] n171;
  wire [4:0] n172;
  wire n176;
  wire [4:0] n177;
  wire n179;
  wire [4:0] n180;
  wire n184;
  wire [31:0] n191;
  wire n195;
  wire n197;
  wire n198;
  wire n200;
  wire n201;
  wire [31:0] n202;
  wire [31:0] n204;
  wire [32:0] n208;
  wire [32:0] n210;
  wire n212;
  wire n214;
  wire n215;
  wire n217;
  wire n218;
  wire n220;
  wire [1:0] n221;
  reg n224;
  reg n228;
  wire n230;
  wire [32:0] n232;
  wire [32:0] n234;
  wire n236;
  wire n237;
  wire [32:0] n238;
  wire n239;
  wire n240;
  wire [32:0] n241;
  wire n243;
  wire n246;
  wire n249;
  wire [32:0] n251;
  wire n253;
  wire n255;
  wire n257;
  wire [32:0] n259;
  wire n261;
  wire n263;
  wire n264;
  wire [32:0] n266;
  wire n268;
  wire n269;
  wire [32:0] n270;
  wire [32:0] n272;
  wire n274;
  wire [32:0] n276;
  wire n278;
  wire [6:0] n279;
  reg [32:0] n283;
  reg [32:0] n284;
  reg n290;
  reg n297;
  wire [32:0] n304;
  wire [32:0] n305;
  wire [33:0] n339;
  wire [33:0] n341;
  wire [33:0] n343;
  wire [33:0] n344;
  wire [33:0] n345;
  wire n348;
  wire [31:0] n349;
  wire n352;
  wire n354;
  wire n355;
  wire n356;
  wire n361;
  wire [2:0] n362;
  wire n364;
  wire n366;
  wire n367;
  wire n369;
  wire n371;
  wire n372;
  wire [1:0] n373;
  reg [1:0] n377;
  wire [1:0] n379;
  wire [7:0] n382;
  wire n384;
  wire n385;
  wire n387;
  wire n388;
  wire n391;
  wire n393;
  wire n394;
  wire n395;
  wire [23:0] n397;
  wire n398;
  wire n399;
  wire [3:0] n406;
  wire [4:0] n408;
  wire [4:0] n410;
  wire [27:0] n411;
  wire n413;
  wire [30:0] n414;
  wire [7:0] n415;
  wire n417;
  wire [7:0] n418;
  wire n420;
  wire [7:0] n421;
  wire n423;
  wire [7:0] n424;
  wire n426;
  wire n428;
  wire n430;
  wire [5:0] n431;
  reg [7:0] n433;
  wire [7:0] n435;
  wire [3:0] n439;
  wire [4:0] n441;
  wire [4:0] n443;
  wire [27:0] n444;
  wire n446;
  wire [30:0] n447;
  wire [7:0] n448;
  wire n450;
  wire [7:0] n451;
  wire n453;
  wire [7:0] n454;
  wire n456;
  wire [7:0] n457;
  wire n459;
  wire n461;
  wire n463;
  wire [5:0] n464;
  reg [7:0] n466;
  wire [7:0] n468;
  wire [3:0] n471;
  wire [4:0] n473;
  wire [4:0] n475;
  wire [27:0] n476;
  wire n478;
  wire [30:0] n479;
  wire [7:0] n480;
  wire n482;
  wire [7:0] n483;
  wire n485;
  wire [7:0] n486;
  wire n488;
  wire [7:0] n489;
  wire n491;
  wire n493;
  wire n495;
  wire [5:0] n496;
  reg [7:0] n498;
  wire [7:0] n500;
  wire [3:0] n503;
  wire [4:0] n505;
  wire [4:0] n507;
  wire [27:0] n508;
  wire n510;
  wire [30:0] n511;
  wire [7:0] n512;
  wire n514;
  wire [7:0] n515;
  wire n517;
  wire [7:0] n518;
  wire n520;
  wire [7:0] n521;
  wire n523;
  wire n525;
  wire n527;
  wire [5:0] n528;
  reg [7:0] n530;
  wire [7:0] n532;
  localparam [23:0] n534 = 24'b000000000000000000000000;
  wire n536;
  wire n539;
  wire [1:0] n540;
  wire [7:0] n541;
  reg [7:0] n542;
  wire [15:0] n543;
  wire [15:0] n544;
  reg [15:0] n545;
  wire [31:0] n546;
  wire n549;
  wire [31:0] n550;
  wire n553;
  wire n554;
  wire [31:0] n559;
  wire n561;
  wire [31:0] n563;
  wire [31:0] n564;
  wire [31:0] n566;
  wire [24:0] n567;
  wire [31:0] n568;
  wire [24:0] n570;
  wire [31:0] n572;
  wire [24:0] n574;
  wire n582;
  wire n584;
  wire n585;
  wire n587;
  wire n588;
  wire n603;
  wire n604;
  wire n606;
  wire n609;
  wire n611;
  wire [4:0] n614;
  wire [31:0] n615;
  wire n617;
  wire n619;
  wire n621;
  wire [1:0] n622;
  wire n624;
  wire [15:0] n625;
  wire [31:0] n626;
  wire [15:0] n627;
  wire [31:0] n628;
  wire [31:0] n629;
  wire [31:0] n630;
  wire n632;
  wire n633;
  wire n634;
  wire [31:0] n635;
  wire n637;
  wire n639;
  wire n640;
  wire [31:0] n641;
  wire n643;
  wire [31:0] n644;
  wire n646;
  wire [31:0] n647;
  wire n649;
  wire [31:0] n650;
  wire n652;
  wire n653;
  wire [31:0] n685;
  wire n687;
  wire n688;
  wire n689;
  wire [31:0] n721;
  wire n723;
  wire n725;
  wire [15:0] n726;
  wire [31:0] n728;
  wire n730;
  wire [2:0] n731;
  wire n733;
  wire n734;
  wire n736;
  wire n737;
  wire n738;
  wire n740;
  wire n742;
  wire n743;
  wire n745;
  wire n746;
  wire n747;
  wire [4:0] n748;
  reg n749;
  wire n751;
  wire n753;
  wire n755;
  wire n756;
  wire n758;
  wire n760;
  wire n761;
  wire n763;
  wire n764;
  wire [26:0] n765;
  wire n767;
  wire [4:0] n768;
  wire [4:0] n771;
  wire [31:0] n773;
  wire [4:0] n774;
  wire n776;
  wire n778;
  wire n779;
  wire n781;
  wire n783;
  wire n784;
  wire [31:0] n785;
  wire n787;
  wire [31:0] n788;
  wire n790;
  wire n792;
  wire n794;
  wire [17:0] n795;
  reg [4:0] n806;
  reg [31:0] n808;
  reg [31:0] n810;
  reg [31:0] n814;
  reg [4:0] n817;
  reg n819;
  wire [4:0] n821;
  wire [31:0] n823;
  wire [31:0] n824;
  wire [31:0] n825;
  wire [4:0] n826;
  wire n827;
  wire n829;
  wire [31:0] n830;
  wire n832;
  wire [31:0] n833;
  wire n834;
  wire [30:0] n835;
  wire [31:0] n836;
  wire [4:0] n838;
  wire n840;
  wire [4:0] n842;
  wire n844;
  wire n845;
  wire n846;
  wire n847;
  wire n848;
  wire n849;
  wire n850;
  wire n851;
  wire n852;
  wire [31:0] n853;
  wire [31:0] n854;
  wire n856;
  wire n857;
  wire n858;
  wire [31:0] n859;
  wire [31:0] n860;
  wire n862;
  wire [31:0] n863;
  wire [30:0] n864;
  wire n865;
  wire [31:0] n866;
  wire [31:0] n867;
  wire [30:0] n868;
  wire [31:0] n869;
  wire [4:0] n871;
  wire n873;
  wire [4:0] n875;
  wire n877;
  wire [31:0] n878;
  wire [31:0] n879;
  wire n881;
  wire [31:0] n882;
  wire [31:0] n883;
  wire n885;
  wire n887;
  wire n888;
  wire n889;
  wire [30:0] n890;
  wire [31:0] n892;
  wire [30:0] n893;
  wire [31:0] n895;
  wire [31:0] n896;
  wire [4:0] n898;
  wire [4:0] n900;
  wire [31:0] n901;
  wire [4:0] n902;
  wire n904;
  wire n906;
  wire n908;
  wire n909;
  wire [7:0] n910;
  wire [7:0] n911;
  wire [4:0] n914;
  wire [31:0] n915;
  wire [7:0] n916;
  wire [4:0] n917;
  wire n918;
  wire [7:0] n919;
  wire n921;
  wire n923;
  wire n925;
  wire n926;
  wire n928;
  wire n930;
  wire [15:0] n931;
  reg [4:0] n942;
  reg [31:0] n944;
  reg [31:0] n946;
  reg [31:0] n948;
  reg [31:0] n950;
  reg [31:0] n953;
  reg [4:0] n956;
  reg n958;
  reg n960;
  reg n962;
  reg [7:0] n964;
  wire [4:0] n966;
  wire [31:0] n968;
  wire [31:0] n969;
  wire [31:0] n970;
  wire [31:0] n971;
  wire [31:0] n972;
  wire [4:0] n973;
  wire n975;
  wire n976;
  wire n977;
  wire [7:0] n979;
  reg [4:0] n1000;
  reg [31:0] n1001;
  reg [31:0] n1002;
  reg [31:0] n1003;
  reg [31:0] n1004;
  reg [31:0] n1005;
  reg [4:0] n1006;
  reg n1007;
  reg n1008;
  reg n1009;
  reg [7:0] n1010;
  reg [31:0] n1011;
  reg [24:0] n1012;
  wire [31:0] n1013; // mem_rd
  assign mem_req = n388; //(module output)
  assign mem_we = n395; //(module output)
  assign mem_size = acc_size; //(module output)
  assign mem_addr = n397; //(module output)
  assign mem_wdata = opb; //(module output)
  assign gpio_out = gpio; //(module output)
  assign halted = n554; //(module output)
  /*# cupu_core.vhd:53:10 */
  assign state = n1000; // (signal)
  /*# cupu_core.vhd:54:10 */
  assign pc = n1001; // (signal)
  /*# cupu_core.vhd:54:14 */
  assign ir = n1002; // (signal)
  /*# cupu_core.vhd:54:18 */
  assign opa = n1003; // (signal)
  /*# cupu_core.vhd:54:23 */
  assign opb = n1004; // (signal)
  /*# cupu_core.vhd:54:28 */
  assign acc = n1005; // (signal)
  /*# cupu_core.vhd:55:10 */
  assign cnt = n1006; // (signal)
  /*# cupu_core.vhd:56:10 */
  assign flag = n1007; // (signal)
  /*# cupu_core.vhd:56:16 */
  assign sgn_q = n1008; // (signal)
  /*# cupu_core.vhd:56:23 */
  assign sgn_r = n1009; // (signal)
  /*# cupu_core.vhd:59:10 */
  assign f_cond = n34; // (signal)
  /*# cupu_core.vhd:60:10 */
  assign f_opc = n35; // (signal)
  /*# cupu_core.vhd:61:10 */
  assign f_t = n36; // (signal)
  /*# cupu_core.vhd:61:15 */
  assign f_a = n37; // (signal)
  /*# cupu_core.vhd:61:20 */
  assign f_b = n38; // (signal)
  /*# cupu_core.vhd:62:10 */
  assign f_fn = n39; // (signal)
  /*# cupu_core.vhd:63:10 */
  assign op = n172; // (signal)
  /*# cupu_core.vhd:65:10 */
  assign rf_idx = n177; // (signal)
  /*# cupu_core.vhd:66:10 */
  assign rf_rd = n191; // (signal)
  /*# cupu_core.vhd:67:10 */
  assign wb_val = n202; // (signal)
  /*# cupu_core.vhd:68:10 */
  assign pc_inc = n204; // (signal)
  /*# cupu_core.vhd:71:10 */
  assign add_x = n283; // (signal)
  /*# cupu_core.vhd:71:17 */
  assign add_y = n284; // (signal)
  /*# cupu_core.vhd:72:10 */
  assign add_inv = n290; // (signal)
  /*# cupu_core.vhd:72:19 */
  assign add_cin = n297; // (signal)
  /*# cupu_core.vhd:73:10 */
  assign add_s = n345; // (signal)
  /*# cupu_core.vhd:76:10 */
  assign acc_addr = n349; // (signal)
  /*# cupu_core.vhd:77:10 */
  assign acc_size = n379; // (signal)
  /*# cupu_core.vhd:78:10 */
  assign acc_req = n356; // (signal)
  /*# cupu_core.vhd:79:10 */
  assign mmio_sel = n385; // (signal)
  /*# cupu_core.vhd:80:10 */
  assign mmio_rd = n546; // (signal)
  /*# cupu_core.vhd:81:10 */
  assign acc_done = n399; // (signal)
  /*# cupu_core.vhd:82:10 */
  assign acc_rdata = n550; // (signal)
  /*# cupu_core.vhd:85:10 */
  assign gpio = n1010; // (signal)
  /*# cupu_core.vhd:86:10 */
  assign seconds = n1011; // (signal)
  /*# cupu_core.vhd:87:10 */
  assign prescale = n1012; // (signal)
  /*# cupu_core.vhd:89:15 */
  assign n34 = ir[31]; // extract
  /*# cupu_core.vhd:90:15 */
  assign n35 = ir[30:26]; // extract
  /*# cupu_core.vhd:91:15 */
  assign n36 = ir[25:21]; // extract
  /*# cupu_core.vhd:92:15 */
  assign n37 = ir[20:16]; // extract
  /*# cupu_core.vhd:93:15 */
  assign n38 = ir[15:11]; // extract
  /*# cupu_core.vhd:94:15 */
  assign n39 = ir[10:0]; // extract
  /*# cupu_core.vhd:102:14 */
  assign n43 = f_opc == 5'b00000;
  /*# cupu_core.vhd:103:12 */
  assign n44 = {20'b0, f_fn};  // uext
  /*# cupu_core.vhd:104:9 */
  assign n46 = n44 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:105:9 */
  assign n48 = n44 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:106:9 */
  assign n50 = n44 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:107:9 */
  assign n52 = n44 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:108:9 */
  assign n54 = n44 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:109:9 */
  assign n56 = n44 == 31'b0000000000000000000000000000101;
  /*# cupu_core.vhd:110:9 */
  assign n58 = n44 == 31'b0000000000000000000000000000110;
  /*# cupu_core.vhd:111:9 */
  assign n60 = n44 == 31'b0000000000000000000000000000111;
  /*# cupu_core.vhd:112:9 */
  assign n62 = n44 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:113:9 */
  assign n64 = n44 == 31'b0000000000000000000000000001001;
  /*# cupu_core.vhd:114:9 */
  assign n66 = n44 == 31'b0000000000000000000000000001010;
  /*# cupu_core.vhd:115:9 */
  assign n68 = n44 == 31'b0000000000000000000000000001011;
  /*# cupu_core.vhd:116:9 */
  assign n70 = n44 == 31'b0000000000000000000000000001100;
  /*# cupu_core.vhd:117:9 */
  assign n72 = n44 == 31'b0000000000000000000000000001101;
  /*# cupu_core.vhd:118:9 */
  assign n75 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000001110);
  /*# cupu_core.vhd:118:9 */
  assign n76 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000010111);
  /*# cupu_core.vhd:118:9 */
  assign n77 = n75 & n76;
  /*# cupu_core.vhd:119:9 */
  assign n80 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000100000);
  /*# cupu_core.vhd:119:9 */
  assign n81 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000100101);
  /*# cupu_core.vhd:119:9 */
  assign n82 = n80 & n81;
  /*# cupu_core.vhd:120:9 */
  assign n85 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000110000);
  /*# cupu_core.vhd:120:9 */
  assign n86 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000110010);
  /*# cupu_core.vhd:120:9 */
  assign n87 = n85 & n86;
  /*# cupu_core.vhd:121:9 */
  assign n90 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000110011);
  /*# cupu_core.vhd:121:9 */
  assign n91 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000110101);
  /*# cupu_core.vhd:121:9 */
  assign n92 = n90 & n91;
  /*# cupu_core.vhd:122:9 */
  assign n94 = n44 == 31'b0000000000000000000000001000000;
  /*# cupu_core.vhd:103:7 */
  assign n95 = {n94, n92, n87, n82, n77, n72, n70, n68, n66, n64, n62, n60, n58, n56, n54, n52, n50, n48, n46};
  /*# cupu_core.vhd:103:7 */
  always @*
    case (n95)
      19'b1000000000000000000: n116 = 5'b10100;
      19'b0100000000000000000: n116 = 5'b10011;
      19'b0010000000000000000: n116 = 5'b10010;
      19'b0001000000000000000: n116 = 5'b10001;
      19'b0000100000000000000: n116 = 5'b10000;
      19'b0000010000000000000: n116 = 5'b01111;
      19'b0000001000000000000: n116 = 5'b01110;
      19'b0000000100000000000: n116 = 5'b00100;
      19'b0000000010000000000: n116 = 5'b00111;
      19'b0000000001000000000: n116 = 5'b01101;
      19'b0000000000100000000: n116 = 5'b01100;
      19'b0000000000010000000: n116 = 5'b01011;
      19'b0000000000001000000: n116 = 5'b01010;
      19'b0000000000000100000: n116 = 5'b01001;
      19'b0000000000000010000: n116 = 5'b01000;
      19'b0000000000000001000: n116 = 5'b00101;
      19'b0000000000000000100: n116 = 5'b00011;
      19'b0000000000000000010: n116 = 5'b00010;
      19'b0000000000000000001: n116 = 5'b00001;
      default: n116 = 5'b00000;
    endcase
  /*# cupu_core.vhd:126:12 */
  assign n117 = {26'b0, f_opc};  // uext
  /*# cupu_core.vhd:127:9 */
  assign n119 = n117 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:127:21 */
  assign n121 = n117 == 31'b0000000000000000000000000011000;
  /*# cupu_core.vhd:127:21 */
  assign n122 = n119 | n121;
  /*# cupu_core.vhd:128:9 */
  assign n124 = n117 == 31'b0000000000000000000000000001001;
  /*# cupu_core.vhd:128:21 */
  assign n126 = n117 == 31'b0000000000000000000000000011001;
  /*# cupu_core.vhd:128:21 */
  assign n127 = n124 | n126;
  /*# cupu_core.vhd:129:9 */
  assign n129 = n117 == 31'b0000000000000000000000000001010;
  /*# cupu_core.vhd:129:21 */
  assign n131 = n117 == 31'b0000000000000000000000000011010;
  /*# cupu_core.vhd:129:21 */
  assign n132 = n129 | n131;
  /*# cupu_core.vhd:130:9 */
  assign n134 = n117 == 31'b0000000000000000000000000001011;
  /*# cupu_core.vhd:131:9 */
  assign n136 = n117 == 31'b0000000000000000000000000011011;
  /*# cupu_core.vhd:132:9 */
  assign n138 = n117 == 31'b0000000000000000000000000001100;
  /*# cupu_core.vhd:132:21 */
  assign n140 = n117 == 31'b0000000000000000000000000011100;
  /*# cupu_core.vhd:132:21 */
  assign n141 = n138 | n140;
  /*# cupu_core.vhd:133:9 */
  assign n143 = n117 == 31'b0000000000000000000000000001101;
  /*# cupu_core.vhd:133:21 */
  assign n145 = n117 == 31'b0000000000000000000000000011101;
  /*# cupu_core.vhd:133:21 */
  assign n146 = n143 | n145;
  /*# cupu_core.vhd:134:9 */
  assign n148 = n117 == 31'b0000000000000000000000000001110;
  /*# cupu_core.vhd:134:21 */
  assign n150 = n117 == 31'b0000000000000000000000000011110;
  /*# cupu_core.vhd:134:21 */
  assign n151 = n148 | n150;
  /*# cupu_core.vhd:135:9 */
  assign n153 = n117 == 31'b0000000000000000000000000001111;
  /*# cupu_core.vhd:136:9 */
  assign n155 = n117 == 31'b0000000000000000000000000010000;
  /*# cupu_core.vhd:137:9 */
  assign n157 = n117 == 31'b0000000000000000000000000010001;
  /*# cupu_core.vhd:126:7 */
  assign n158 = {n157, n155, n153, n151, n146, n141, n136, n134, n132, n127, n122};
  /*# cupu_core.vhd:126:7 */
  always @*
    case (n158)
      11'b10000000000: n171 = 5'b10111;
      11'b01000000000: n171 = 5'b10110;
      11'b00100000000: n171 = 5'b10101;
      11'b00010000000: n171 = 5'b01010;
      11'b00001000000: n171 = 5'b01001;
      11'b00000100000: n171 = 5'b01000;
      11'b00000010000: n171 = 5'b00110;
      11'b00000001000: n171 = 5'b00101;
      11'b00000000100: n171 = 5'b00011;
      11'b00000000010: n171 = 5'b00010;
      11'b00000000001: n171 = 5'b00001;
      default: n171 = 5'b00000;
    endcase
  /*# cupu_core.vhd:102:5 */
  assign n172 = n43 ? n116 : n171;
  /*# cupu_core.vhd:146:28 */
  assign n176 = state == 5'b00001;
  /*# cupu_core.vhd:146:17 */
  assign n177 = n176 ? f_a : n180;
  /*# cupu_core.vhd:147:25 */
  assign n179 = op == 5'b10011;
  /*# cupu_core.vhd:146:35 */
  assign n180 = n179 ? f_t : f_b;
  /*# cupu_core.vhd:152:15 */
  assign n184 = rf_idx != 5'b00000;
  /*# cupu_core.vhd:152:5 */
  assign n191 = n184 ? n1013 : 32'b00000000000000000000000000000000;
  /*# cupu_core.vhd:158:25 */
  assign n195 = op == 5'b00011;
  /*# cupu_core.vhd:158:40 */
  assign n197 = op == 5'b00101;
  /*# cupu_core.vhd:158:34 */
  assign n198 = n195 | n197;
  /*# cupu_core.vhd:158:55 */
  assign n200 = op == 5'b00110;
  /*# cupu_core.vhd:158:49 */
  assign n201 = n198 | n200;
  /*# cupu_core.vhd:158:17 */
  assign n202 = n201 ? opa : acc;
  /*# cupu_core.vhd:160:16 */
  assign n204 = pc + 32'b00000000000000000000000000000100;
  /*# cupu_core.vhd:167:20 */
  assign n208 = {1'b0, opa};
  /*# cupu_core.vhd:168:20 */
  assign n210 = {1'b0, opb};
  /*# cupu_core.vhd:174:11 */
  assign n212 = op == 5'b00010;
  /*# cupu_core.vhd:174:23 */
  assign n214 = op == 5'b01111;
  /*# cupu_core.vhd:174:23 */
  assign n215 = n212 | n214;
  /*# cupu_core.vhd:174:33 */
  assign n217 = op == 5'b10001;
  /*# cupu_core.vhd:174:33 */
  assign n218 = n215 | n217;
  /*# cupu_core.vhd:177:11 */
  assign n220 = op == 5'b01110;
  /*# cupu_core.vhd:173:9 */
  assign n221 = {n220, n218};
  /*# cupu_core.vhd:173:9 */
  always @*
    case (n221)
      2'b10: n224 = 1'b0;
      2'b01: n224 = 1'b1;
      default: n224 = 1'b0;
    endcase
  /*# cupu_core.vhd:173:9 */
  always @*
    case (n221)
      2'b10: n228 = 1'b1;
      2'b01: n228 = 1'b1;
      default: n228 = 1'b0;
    endcase
  /*# cupu_core.vhd:172:7 */
  assign n230 = state == 5'b00011;
  /*# cupu_core.vhd:182:22 */
  assign n232 = {1'b0, pc};
  /*# cupu_core.vhd:183:22 */
  assign n234 = {1'b0, opa};
  /*# cupu_core.vhd:181:7 */
  assign n236 = state == 5'b01000;
  /*# cupu_core.vhd:186:21 */
  assign n237 = acc[31]; // extract
  /*# cupu_core.vhd:186:26 */
  assign n238 = {n237, acc};
  /*# cupu_core.vhd:187:15 */
  assign n239 = opa[0]; // extract
  /*# cupu_core.vhd:188:23 */
  assign n240 = opb[31]; // extract
  /*# cupu_core.vhd:188:28 */
  assign n241 = {n240, opb};
  /*# cupu_core.vhd:189:18 */
  assign n243 = cnt == 5'b11111;
  /*# cupu_core.vhd:189:11 */
  assign n246 = n243 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:189:11 */
  assign n249 = n243 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:187:9 */
  assign n251 = n239 ? n241 : 33'b000000000000000000000000000000000;
  /*# cupu_core.vhd:187:9 */
  assign n253 = n239 ? n246 : 1'b0;
  /*# cupu_core.vhd:187:9 */
  assign n255 = n239 ? n249 : 1'b0;
  /*# cupu_core.vhd:184:7 */
  assign n257 = state == 5'b01001;
  /*# cupu_core.vhd:198:24 */
  assign n259 = {1'b0, opa};
  /*# cupu_core.vhd:196:7 */
  assign n261 = state == 5'b01010;
  /*# cupu_core.vhd:196:21 */
  assign n263 = state == 5'b01101;
  /*# cupu_core.vhd:196:21 */
  assign n264 = n261 | n263;
  /*# cupu_core.vhd:203:24 */
  assign n266 = {1'b0, opb};
  /*# cupu_core.vhd:201:7 */
  assign n268 = state == 5'b01011;
  /*# cupu_core.vhd:207:29 */
  assign n269 = opa[31]; // extract
  /*# cupu_core.vhd:207:24 */
  assign n270 = {acc, n269};
  /*# cupu_core.vhd:208:24 */
  assign n272 = {1'b0, opb};
  /*# cupu_core.vhd:206:7 */
  assign n274 = state == 5'b01100;
  /*# cupu_core.vhd:213:24 */
  assign n276 = {1'b0, acc};
  /*# cupu_core.vhd:211:7 */
  assign n278 = state == 5'b01110;
  /*# cupu_core.vhd:171:5 */
  assign n279 = {n278, n274, n268, n264, n257, n236, n230};
  /*# cupu_core.vhd:171:5 */
  always @*
    case (n279)
      7'b1000000: n283 = 33'b000000000000000000000000000000000;
      7'b0100000: n283 = n270;
      7'b0010000: n283 = 33'b000000000000000000000000000000000;
      7'b0001000: n283 = 33'b000000000000000000000000000000000;
      7'b0000100: n283 = n238;
      7'b0000010: n283 = n232;
      7'b0000001: n283 = n208;
      default: n283 = n208;
    endcase
  /*# cupu_core.vhd:171:5 */
  always @*
    case (n279)
      7'b1000000: n284 = n276;
      7'b0100000: n284 = n272;
      7'b0010000: n284 = n266;
      7'b0001000: n284 = n259;
      7'b0000100: n284 = n251;
      7'b0000010: n284 = n234;
      7'b0000001: n284 = n210;
      default: n284 = n210;
    endcase
  /*# cupu_core.vhd:171:5 */
  always @*
    case (n279)
      7'b1000000: n290 = 1'b1;
      7'b0100000: n290 = 1'b1;
      7'b0010000: n290 = 1'b1;
      7'b0001000: n290 = 1'b1;
      7'b0000100: n290 = n253;
      7'b0000010: n290 = 1'b0;
      7'b0000001: n290 = n224;
      default: n290 = 1'b0;
    endcase
  /*# cupu_core.vhd:171:5 */
  always @*
    case (n279)
      7'b1000000: n297 = 1'b1;
      7'b0100000: n297 = 1'b1;
      7'b0010000: n297 = 1'b1;
      7'b0001000: n297 = 1'b1;
      7'b0000100: n297 = n255;
      7'b0000010: n297 = 1'b0;
      7'b0000001: n297 = n228;
      default: n297 = 1'b0;
    endcase
  /*# cupu_core.vhd:226:12 */
  assign n304 = ~add_y;
  /*# cupu_core.vhd:225:5 */
  assign n305 = add_inv ? n304 : add_y;
  /*# cupu_core.vhd:228:10 */
  assign n339 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, add_cin};
  /*# cupu_core.vhd:229:19 */
  assign n341 = {1'b0, add_x};
  /*# cupu_core.vhd:229:35 */
  assign n343 = {1'b0, n305};
  /*# cupu_core.vhd:229:28 */
  assign n344 = n341 + n343;
  /*# cupu_core.vhd:229:40 */
  assign n345 = n344 + n339;
  /*# cupu_core.vhd:235:29 */
  assign n348 = state == 5'b00000;
  /*# cupu_core.vhd:235:18 */
  assign n349 = n348 ? pc : opa;
  /*# cupu_core.vhd:236:30 */
  assign n352 = state == 5'b00000;
  /*# cupu_core.vhd:236:49 */
  assign n354 = state == 5'b00100;
  /*# cupu_core.vhd:236:40 */
  assign n355 = n352 | n354;
  /*# cupu_core.vhd:236:19 */
  assign n356 = n355 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:239:14 */
  assign n361 = state == 5'b00000;
  /*# cupu_core.vhd:242:16 */
  assign n362 = f_fn[2:0]; // extract
  /*# cupu_core.vhd:243:9 */
  assign n364 = n362 == 3'b000;
  /*# cupu_core.vhd:243:20 */
  assign n366 = n362 == 3'b011;
  /*# cupu_core.vhd:243:20 */
  assign n367 = n364 | n366;
  /*# cupu_core.vhd:244:9 */
  assign n369 = n362 == 3'b001;
  /*# cupu_core.vhd:244:20 */
  assign n371 = n362 == 3'b100;
  /*# cupu_core.vhd:244:20 */
  assign n372 = n369 | n371;
  /*# cupu_core.vhd:242:7 */
  assign n373 = {n372, n367};
  /*# cupu_core.vhd:242:7 */
  always @*
    case (n373)
      2'b10: n377 = 2'b01;
      2'b01: n377 = 2'b10;
      default: n377 = 2'b00;
    endcase
  /*# cupu_core.vhd:239:5 */
  assign n379 = n361 ? 2'b10 : n377;
  /*# cupu_core.vhd:250:33 */
  assign n382 = acc_addr[31:24]; // extract
  /*# cupu_core.vhd:250:48 */
  assign n384 = n382 == 8'b00000000;
  /*# cupu_core.vhd:250:20 */
  assign n385 = n384 ? 1'b0 : 1'b1;
  /*# cupu_core.vhd:251:28 */
  assign n387 = ~mmio_sel;
  /*# cupu_core.vhd:251:24 */
  assign n388 = acc_req & n387;
  /*# cupu_core.vhd:252:31 */
  assign n391 = state == 5'b00100;
  /*# cupu_core.vhd:252:46 */
  assign n393 = op == 5'b10011;
  /*# cupu_core.vhd:252:39 */
  assign n394 = n393 & n391;
  /*# cupu_core.vhd:252:20 */
  assign n395 = n394 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:254:41 */
  assign n397 = acc_addr[23:0]; // extract
  /*# cupu_core.vhd:256:39 */
  assign n398 = ~mmio_sel;
  /*# cupu_core.vhd:256:25 */
  assign n399 = n398 ? mem_done : 1'b1;
  /*# cupu_core.vhd:266:29 */
  assign n406 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:266:19 */
  assign n408 = {1'b0, n406};
  /*# cupu_core.vhd:266:43 */
  assign n410 = n408 + 5'b00000;
  /*# cupu_core.vhd:268:18 */
  assign n411 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:268:32 */
  assign n413 = n411 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:269:14 */
  assign n414 = {26'b0, n410};  // uext
  /*# cupu_core.vhd:270:55 */
  assign n415 = seconds[7:0]; // extract
  /*# cupu_core.vhd:270:11 */
  assign n417 = n414 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:271:55 */
  assign n418 = seconds[15:8]; // extract
  /*# cupu_core.vhd:271:11 */
  assign n420 = n414 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:272:55 */
  assign n421 = seconds[23:16]; // extract
  /*# cupu_core.vhd:272:11 */
  assign n423 = n414 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:273:55 */
  assign n424 = seconds[31:24]; // extract
  /*# cupu_core.vhd:273:11 */
  assign n426 = n414 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:274:11 */
  assign n428 = n414 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:275:11 */
  assign n430 = n414 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:269:9 */
  assign n431 = {n430, n428, n426, n423, n420, n417};
  /*# cupu_core.vhd:269:9 */
  always @*
    case (n431)
      6'b100000: n433 = gpio;
      6'b010000: n433 = kbd_in;
      6'b001000: n433 = n424;
      6'b000100: n433 = n421;
      6'b000010: n433 = n418;
      6'b000001: n433 = n415;
      default: n433 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:268:7 */
  assign n435 = n413 ? n433 : 8'b00000000;
  /*# cupu_core.vhd:266:29 */
  assign n439 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:266:19 */
  assign n441 = {1'b0, n439};
  /*# cupu_core.vhd:266:43 */
  assign n443 = n441 + 5'b00001;
  /*# cupu_core.vhd:268:18 */
  assign n444 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:268:32 */
  assign n446 = n444 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:269:14 */
  assign n447 = {26'b0, n443};  // uext
  /*# cupu_core.vhd:270:55 */
  assign n448 = seconds[7:0]; // extract
  /*# cupu_core.vhd:270:11 */
  assign n450 = n447 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:271:55 */
  assign n451 = seconds[15:8]; // extract
  /*# cupu_core.vhd:271:11 */
  assign n453 = n447 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:272:55 */
  assign n454 = seconds[23:16]; // extract
  /*# cupu_core.vhd:272:11 */
  assign n456 = n447 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:273:55 */
  assign n457 = seconds[31:24]; // extract
  /*# cupu_core.vhd:273:11 */
  assign n459 = n447 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:274:11 */
  assign n461 = n447 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:275:11 */
  assign n463 = n447 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:269:9 */
  assign n464 = {n463, n461, n459, n456, n453, n450};
  /*# cupu_core.vhd:269:9 */
  always @*
    case (n464)
      6'b100000: n466 = gpio;
      6'b010000: n466 = kbd_in;
      6'b001000: n466 = n457;
      6'b000100: n466 = n454;
      6'b000010: n466 = n451;
      6'b000001: n466 = n448;
      default: n466 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:268:7 */
  assign n468 = n446 ? n466 : 8'b00000000;
  /*# cupu_core.vhd:266:29 */
  assign n471 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:266:19 */
  assign n473 = {1'b0, n471};
  /*# cupu_core.vhd:266:43 */
  assign n475 = n473 + 5'b00010;
  /*# cupu_core.vhd:268:18 */
  assign n476 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:268:32 */
  assign n478 = n476 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:269:14 */
  assign n479 = {26'b0, n475};  // uext
  /*# cupu_core.vhd:270:55 */
  assign n480 = seconds[7:0]; // extract
  /*# cupu_core.vhd:270:11 */
  assign n482 = n479 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:271:55 */
  assign n483 = seconds[15:8]; // extract
  /*# cupu_core.vhd:271:11 */
  assign n485 = n479 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:272:55 */
  assign n486 = seconds[23:16]; // extract
  /*# cupu_core.vhd:272:11 */
  assign n488 = n479 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:273:55 */
  assign n489 = seconds[31:24]; // extract
  /*# cupu_core.vhd:273:11 */
  assign n491 = n479 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:274:11 */
  assign n493 = n479 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:275:11 */
  assign n495 = n479 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:269:9 */
  assign n496 = {n495, n493, n491, n488, n485, n482};
  /*# cupu_core.vhd:269:9 */
  always @*
    case (n496)
      6'b100000: n498 = gpio;
      6'b010000: n498 = kbd_in;
      6'b001000: n498 = n489;
      6'b000100: n498 = n486;
      6'b000010: n498 = n483;
      6'b000001: n498 = n480;
      default: n498 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:268:7 */
  assign n500 = n478 ? n498 : 8'b00000000;
  /*# cupu_core.vhd:266:29 */
  assign n503 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:266:19 */
  assign n505 = {1'b0, n503};
  /*# cupu_core.vhd:266:43 */
  assign n507 = n505 + 5'b00011;
  /*# cupu_core.vhd:268:18 */
  assign n508 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:268:32 */
  assign n510 = n508 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:269:14 */
  assign n511 = {26'b0, n507};  // uext
  /*# cupu_core.vhd:270:55 */
  assign n512 = seconds[7:0]; // extract
  /*# cupu_core.vhd:270:11 */
  assign n514 = n511 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:271:55 */
  assign n515 = seconds[15:8]; // extract
  /*# cupu_core.vhd:271:11 */
  assign n517 = n511 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:272:55 */
  assign n518 = seconds[23:16]; // extract
  /*# cupu_core.vhd:272:11 */
  assign n520 = n511 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:273:55 */
  assign n521 = seconds[31:24]; // extract
  /*# cupu_core.vhd:273:11 */
  assign n523 = n511 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:274:11 */
  assign n525 = n511 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:275:11 */
  assign n527 = n511 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:269:9 */
  assign n528 = {n527, n525, n523, n520, n517, n514};
  /*# cupu_core.vhd:269:9 */
  always @*
    case (n528)
      6'b100000: n530 = gpio;
      6'b010000: n530 = kbd_in;
      6'b001000: n530 = n521;
      6'b000100: n530 = n518;
      6'b000010: n530 = n515;
      6'b000001: n530 = n512;
      default: n530 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:268:7 */
  assign n532 = n510 ? n530 : 8'b00000000;
  /*# cupu_core.vhd:282:7 */
  assign n536 = acc_size == 2'b00;
  /*# cupu_core.vhd:283:7 */
  assign n539 = acc_size == 2'b01;
  /*# cupu_core.vhd:281:5 */
  assign n540 = {n539, n536};
  assign n541 = n534[7:0]; // extract
  /*# cupu_core.vhd:281:5 */
  always @*
    case (n540)
      2'b10: n542 = n468;
      2'b01: n542 = n541;
      default: n542 = n468;
    endcase
  assign n543 = n534[23:8]; // extract
  /*# cupu_core.vhd:262:14 */
  assign n544 = {n532, n500};
  /*# cupu_core.vhd:281:5 */
  always @*
    case (n540)
      2'b10: n545 = 16'b0000000000000000;
      2'b01: n545 = n543;
      default: n545 = n544;
    endcase
  /*# cupu_core.vhd:262:14 */
  assign n546 = {n545, n542, n435};
  /*# cupu_core.vhd:289:50 */
  assign n549 = ~mmio_sel;
  /*# cupu_core.vhd:289:36 */
  assign n550 = n549 ? mem_rdata : mmio_rd;
  /*# cupu_core.vhd:292:30 */
  assign n553 = state == 5'b10000;
  /*# cupu_core.vhd:292:19 */
  assign n554 = n553 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:303:22 */
  assign n559 = {7'b0, prescale};  // uext
  /*# cupu_core.vhd:303:22 */
  assign n561 = n559 == 32'b00000001011111010111100000111111;
  /*# cupu_core.vhd:305:29 */
  assign n563 = seconds + 32'b00000000000000000000000000000001;
  /*# cupu_core.vhd:307:30 */
  assign n564 = {7'b0, prescale};  // uext
  /*# cupu_core.vhd:307:30 */
  assign n566 = n564 + 32'b00000000000000000000000000000001;
  /*# cupu_core.vhd:307:21 */
  assign n567 = n566[24:0];  // trunc
  /*# cupu_core.vhd:303:7 */
  assign n568 = n561 ? n563 : seconds;
  /*# cupu_core.vhd:303:7 */
  assign n570 = n561 ? 25'b0000000000000000000000000 : n567;
  /*# cupu_core.vhd:300:7 */
  assign n572 = rst ? 32'b00000000000000000000000000000000 : n568;
  /*# cupu_core.vhd:300:7 */
  assign n574 = rst ? 25'b0000000000000000000000000 : n570;
  /*# cupu_core.vhd:318:17 */
  assign n582 = state == 5'b00101;
  /*# cupu_core.vhd:318:33 */
  assign n584 = state == 5'b00110;
  /*# cupu_core.vhd:318:24 */
  assign n585 = n582 | n584;
  /*# cupu_core.vhd:318:50 */
  assign n587 = f_t != 5'b00000;
  /*# cupu_core.vhd:318:42 */
  assign n588 = n587 & n585;
  /*# cupu_core.vhd:338:23 */
  assign n603 = add_s[33]; // extract
  /*# cupu_core.vhd:339:31 */
  assign n604 = opa == opb;
  /*# cupu_core.vhd:339:22 */
  assign n606 = n604 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:340:30 */
  assign n609 = op == 5'b00110;
  /*# cupu_core.vhd:340:22 */
  assign n611 = n609 ? 1'b0 : 1'b1;
  /*# cupu_core.vhd:344:13 */
  assign n614 = acc_done ? 5'b00001 : state;
  /*# cupu_core.vhd:344:13 */
  assign n615 = acc_done ? acc_rdata : ir;
  /*# cupu_core.vhd:343:11 */
  assign n617 = state == 5'b00000;
  /*# cupu_core.vhd:349:11 */
  assign n619 = state == 5'b00001;
  /*# cupu_core.vhd:354:22 */
  assign n621 = f_opc == 5'b00000;
  /*# cupu_core.vhd:356:24 */
  assign n622 = f_opc[4:3]; // extract
  /*# cupu_core.vhd:356:37 */
  assign n624 = n622 == 2'b11;
  /*# cupu_core.vhd:357:31 */
  assign n625 = ir[15:0]; // extract
  /*# cupu_core.vhd:357:22 */
  assign n626 = {16'b0, n625};  // uext
  /*# cupu_core.vhd:359:47 */
  assign n627 = ir[15:0]; // extract
  /*# cupu_core.vhd:359:31 */
  assign n628 = {{16{n627[15]}}, n627}; // sext
  /*# cupu_core.vhd:356:13 */
  assign n629 = n624 ? n626 : n628;
  /*# cupu_core.vhd:354:13 */
  assign n630 = n621 ? rf_rd : n629;
  /*# cupu_core.vhd:353:11 */
  assign n632 = state == 5'b00010;
  /*# cupu_core.vhd:365:38 */
  assign n633 = ~flag;
  /*# cupu_core.vhd:365:29 */
  assign n634 = n633 & f_cond;
  /*# cupu_core.vhd:369:53 */
  assign n635 = add_s[31:0]; // extract
  /*# cupu_core.vhd:369:17 */
  assign n637 = op == 5'b00001;
  /*# cupu_core.vhd:369:29 */
  assign n639 = op == 5'b00010;
  /*# cupu_core.vhd:369:29 */
  assign n640 = n637 | n639;
  /*# cupu_core.vhd:370:44 */
  assign n641 = opa | opb;
  /*# cupu_core.vhd:370:17 */
  assign n643 = op == 5'b01000;
  /*# cupu_core.vhd:371:44 */
  assign n644 = opa & opb;
  /*# cupu_core.vhd:371:17 */
  assign n646 = op == 5'b01001;
  /*# cupu_core.vhd:372:44 */
  assign n647 = opa ^ opb;
  /*# cupu_core.vhd:372:17 */
  assign n649 = op == 5'b01010;
  /*# cupu_core.vhd:373:40 */
  assign n650 = ~opa;
  /*# cupu_core.vhd:373:17 */
  assign n652 = op == 5'b01011;
  /*# cupu_core.vhd:374:51 */
  assign n653 = add_s[32]; // extract
  /*# cupu_core.vhd:374:40 */
  assign n685 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, n653};
  /*# cupu_core.vhd:374:17 */
  assign n687 = op == 5'b01110;
  /*# cupu_core.vhd:375:47 */
  assign n688 = ~n603;
  /*# cupu_core.vhd:375:55 */
  assign n689 = n688 | n606;
  /*# cupu_core.vhd:375:40 */
  assign n721 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, n689};
  /*# cupu_core.vhd:375:17 */
  assign n723 = op == 5'b01111;
  /*# cupu_core.vhd:376:17 */
  assign n725 = op == 5'b10000;
  /*# cupu_core.vhd:377:43 */
  assign n726 = opb[15:0]; // extract
  /*# cupu_core.vhd:377:57 */
  assign n728 = {n726, 16'b0000000000000000};
  /*# cupu_core.vhd:377:17 */
  assign n730 = op == 5'b10101;
  /*# cupu_core.vhd:380:28 */
  assign n731 = f_fn[2:0]; // extract
  /*# cupu_core.vhd:381:21 */
  assign n733 = n731 == 3'b000;
  /*# cupu_core.vhd:382:44 */
  assign n734 = ~n606;
  /*# cupu_core.vhd:382:21 */
  assign n736 = n731 == 3'b001;
  /*# cupu_core.vhd:383:51 */
  assign n737 = ~n606;
  /*# cupu_core.vhd:383:47 */
  assign n738 = n603 & n737;
  /*# cupu_core.vhd:383:21 */
  assign n740 = n731 == 3'b010;
  /*# cupu_core.vhd:384:21 */
  assign n742 = n731 == 3'b011;
  /*# cupu_core.vhd:385:44 */
  assign n743 = ~n603;
  /*# cupu_core.vhd:385:21 */
  assign n745 = n731 == 3'b100;
  /*# cupu_core.vhd:386:45 */
  assign n746 = ~n603;
  /*# cupu_core.vhd:386:53 */
  assign n747 = n746 | n606;
  /*# cupu_core.vhd:380:19 */
  assign n748 = {n745, n742, n740, n736, n733};
  /*# cupu_core.vhd:380:19 */
  always @*
    case (n748)
      5'b10000: n749 = n743;
      5'b01000: n749 = n603;
      5'b00100: n749 = n738;
      5'b00010: n749 = n734;
      5'b00001: n749 = n606;
      default: n749 = n747;
    endcase
  /*# cupu_core.vhd:379:17 */
  assign n751 = op == 5'b10001;
  /*# cupu_core.vhd:390:17 */
  assign n753 = op == 5'b00011;
  /*# cupu_core.vhd:390:29 */
  assign n755 = op == 5'b00100;
  /*# cupu_core.vhd:390:29 */
  assign n756 = n753 | n755;
  /*# cupu_core.vhd:395:17 */
  assign n758 = op == 5'b00101;
  /*# cupu_core.vhd:395:29 */
  assign n760 = op == 5'b00110;
  /*# cupu_core.vhd:395:29 */
  assign n761 = n758 | n760;
  /*# cupu_core.vhd:395:39 */
  assign n763 = op == 5'b00111;
  /*# cupu_core.vhd:395:39 */
  assign n764 = n761 | n763;
  /*# cupu_core.vhd:399:25 */
  assign n765 = opb[31:5]; // extract
  /*# cupu_core.vhd:399:39 */
  assign n767 = n765 != 27'b000000000000000000000000000;
  /*# cupu_core.vhd:403:33 */
  assign n768 = opb[4:0]; // extract
  /*# cupu_core.vhd:399:19 */
  assign n771 = n767 ? 5'b00101 : 5'b01111;
  /*# cupu_core.vhd:399:19 */
  assign n773 = n767 ? 32'b00000000000000000000000000000000 : opa;
  /*# cupu_core.vhd:399:19 */
  assign n774 = n767 ? cnt : n768;
  /*# cupu_core.vhd:398:17 */
  assign n776 = op == 5'b01100;
  /*# cupu_core.vhd:398:29 */
  assign n778 = op == 5'b01101;
  /*# cupu_core.vhd:398:29 */
  assign n779 = n776 | n778;
  /*# cupu_core.vhd:407:17 */
  assign n781 = op == 5'b10010;
  /*# cupu_core.vhd:407:30 */
  assign n783 = op == 5'b10011;
  /*# cupu_core.vhd:407:30 */
  assign n784 = n781 | n783;
  /*# cupu_core.vhd:412:33 */
  assign n785 = add_s[31:0]; // extract
  /*# cupu_core.vhd:410:17 */
  assign n787 = op == 5'b10110;
  /*# cupu_core.vhd:416:33 */
  assign n788 = add_s[31:0]; // extract
  /*# cupu_core.vhd:415:17 */
  assign n790 = op == 5'b10111;
  /*# cupu_core.vhd:419:17 */
  assign n792 = op == 5'b10100;
  /*# cupu_core.vhd:422:17 */
  assign n794 = op == 5'b00000;
  /*# cupu_core.vhd:368:15 */
  assign n795 = {n794, n792, n790, n787, n784, n779, n764, n756, n751, n730, n725, n723, n687, n652, n649, n646, n643, n640};
  /*# cupu_core.vhd:368:15 */
  always @*
    case (n795)
      18'b100000000000000000: n806 = 5'b00111;
      18'b010000000000000000: n806 = 5'b10000;
      18'b001000000000000000: n806 = 5'b01000;
      18'b000100000000000000: n806 = 5'b00110;
      18'b000010000000000000: n806 = 5'b00100;
      18'b000001000000000000: n806 = n771;
      18'b000000100000000000: n806 = 5'b01010;
      18'b000000010000000000: n806 = 5'b01001;
      18'b000000001000000000: n806 = 5'b00111;
      18'b000000000100000000: n806 = 5'b00101;
      18'b000000000010000000: n806 = 5'b00101;
      18'b000000000001000000: n806 = 5'b00101;
      18'b000000000000100000: n806 = 5'b00101;
      18'b000000000000010000: n806 = 5'b00101;
      18'b000000000000001000: n806 = 5'b00101;
      18'b000000000000000100: n806 = 5'b00101;
      18'b000000000000000010: n806 = 5'b00101;
      18'b000000000000000001: n806 = 5'b00101;
      default: n806 = 5'bX;
    endcase
  /*# cupu_core.vhd:368:15 */
  always @*
    case (n795)
      18'b100000000000000000: n808 = pc;
      18'b010000000000000000: n808 = pc;
      18'b001000000000000000: n808 = pc;
      18'b000100000000000000: n808 = n785;
      18'b000010000000000000: n808 = pc;
      18'b000001000000000000: n808 = pc;
      18'b000000100000000000: n808 = pc;
      18'b000000010000000000: n808 = pc;
      18'b000000001000000000: n808 = pc;
      18'b000000000100000000: n808 = pc;
      18'b000000000010000000: n808 = pc;
      18'b000000000001000000: n808 = pc;
      18'b000000000000100000: n808 = pc;
      18'b000000000000010000: n808 = pc;
      18'b000000000000001000: n808 = pc;
      18'b000000000000000100: n808 = pc;
      18'b000000000000000010: n808 = pc;
      18'b000000000000000001: n808 = pc;
      default: n808 = 32'bX;
    endcase
  /*# cupu_core.vhd:368:15 */
  always @*
    case (n795)
      18'b100000000000000000: n810 = opa;
      18'b010000000000000000: n810 = opa;
      18'b001000000000000000: n810 = n788;
      18'b000100000000000000: n810 = opa;
      18'b000010000000000000: n810 = opa;
      18'b000001000000000000: n810 = opa;
      18'b000000100000000000: n810 = opa;
      18'b000000010000000000: n810 = opa;
      18'b000000001000000000: n810 = opa;
      18'b000000000100000000: n810 = opa;
      18'b000000000010000000: n810 = opa;
      18'b000000000001000000: n810 = opa;
      18'b000000000000100000: n810 = opa;
      18'b000000000000010000: n810 = opa;
      18'b000000000000001000: n810 = opa;
      18'b000000000000000100: n810 = opa;
      18'b000000000000000010: n810 = opa;
      18'b000000000000000001: n810 = opa;
      default: n810 = 32'bX;
    endcase
  /*# cupu_core.vhd:368:15 */
  always @*
    case (n795)
      18'b100000000000000000: n814 = acc;
      18'b010000000000000000: n814 = acc;
      18'b001000000000000000: n814 = acc;
      18'b000100000000000000: n814 = pc_inc;
      18'b000010000000000000: n814 = acc;
      18'b000001000000000000: n814 = n773;
      18'b000000100000000000: n814 = acc;
      18'b000000010000000000: n814 = 32'b00000000000000000000000000000000;
      18'b000000001000000000: n814 = acc;
      18'b000000000100000000: n814 = n728;
      18'b000000000010000000: n814 = 32'b00000000000000000000000000000000;
      18'b000000000001000000: n814 = n721;
      18'b000000000000100000: n814 = n685;
      18'b000000000000010000: n814 = n650;
      18'b000000000000001000: n814 = n647;
      18'b000000000000000100: n814 = n644;
      18'b000000000000000010: n814 = n641;
      18'b000000000000000001: n814 = n635;
      default: n814 = 32'bX;
    endcase
  /*# cupu_core.vhd:368:15 */
  always @*
    case (n795)
      18'b100000000000000000: n817 = cnt;
      18'b010000000000000000: n817 = cnt;
      18'b001000000000000000: n817 = cnt;
      18'b000100000000000000: n817 = cnt;
      18'b000010000000000000: n817 = cnt;
      18'b000001000000000000: n817 = n774;
      18'b000000100000000000: n817 = cnt;
      18'b000000010000000000: n817 = 5'b00000;
      18'b000000001000000000: n817 = cnt;
      18'b000000000100000000: n817 = cnt;
      18'b000000000010000000: n817 = cnt;
      18'b000000000001000000: n817 = cnt;
      18'b000000000000100000: n817 = cnt;
      18'b000000000000010000: n817 = cnt;
      18'b000000000000001000: n817 = cnt;
      18'b000000000000000100: n817 = cnt;
      18'b000000000000000010: n817 = cnt;
      18'b000000000000000001: n817 = cnt;
      default: n817 = 5'bX;
    endcase
  /*# cupu_core.vhd:368:15 */
  always @*
    case (n795)
      18'b100000000000000000: n819 = flag;
      18'b010000000000000000: n819 = flag;
      18'b001000000000000000: n819 = flag;
      18'b000100000000000000: n819 = flag;
      18'b000010000000000000: n819 = flag;
      18'b000001000000000000: n819 = flag;
      18'b000000100000000000: n819 = flag;
      18'b000000010000000000: n819 = flag;
      18'b000000001000000000: n819 = n749;
      18'b000000000100000000: n819 = flag;
      18'b000000000010000000: n819 = flag;
      18'b000000000001000000: n819 = flag;
      18'b000000000000100000: n819 = flag;
      18'b000000000000010000: n819 = flag;
      18'b000000000000001000: n819 = flag;
      18'b000000000000000100: n819 = flag;
      18'b000000000000000010: n819 = flag;
      18'b000000000000000001: n819 = flag;
      default: n819 = 1'bX;
    endcase
  /*# cupu_core.vhd:365:13 */
  assign n821 = n634 ? 5'b00111 : n806;
  /*# cupu_core.vhd:365:13 */
  assign n823 = n634 ? pc : n808;
  /*# cupu_core.vhd:365:13 */
  assign n824 = n634 ? opa : n810;
  /*# cupu_core.vhd:365:13 */
  assign n825 = n634 ? acc : n814;
  /*# cupu_core.vhd:365:13 */
  assign n826 = n634 ? cnt : n817;
  /*# cupu_core.vhd:365:13 */
  assign n827 = n634 ? flag : n819;
  /*# cupu_core.vhd:363:11 */
  assign n829 = state == 5'b00011;
  /*# cupu_core.vhd:429:27 */
  assign n830 = add_s[31:0]; // extract
  /*# cupu_core.vhd:427:11 */
  assign n832 = state == 5'b01000;
  /*# cupu_core.vhd:433:25 */
  assign n833 = add_s[32:1]; // extract
  /*# cupu_core.vhd:434:25 */
  assign n834 = add_s[0]; // extract
  /*# cupu_core.vhd:434:34 */
  assign n835 = opa[31:1]; // extract
  /*# cupu_core.vhd:434:29 */
  assign n836 = {n834, n835};
  /*# cupu_core.vhd:435:24 */
  assign n838 = cnt + 5'b00001;
  /*# cupu_core.vhd:436:20 */
  assign n840 = cnt == 5'b11111;
  /*# cupu_core.vhd:436:13 */
  assign n842 = n840 ? 5'b00101 : state;
  /*# cupu_core.vhd:432:11 */
  assign n844 = state == 5'b01001;
  /*# cupu_core.vhd:441:36 */
  assign n845 = opa[31]; // extract
  /*# cupu_core.vhd:441:48 */
  assign n846 = opb[31]; // extract
  /*# cupu_core.vhd:441:41 */
  assign n847 = n845 ^ n846;
  /*# cupu_core.vhd:441:28 */
  assign n848 = n611 & n847;
  /*# cupu_core.vhd:442:35 */
  assign n849 = opa[31]; // extract
  /*# cupu_core.vhd:442:28 */
  assign n850 = n611 & n849;
  /*# cupu_core.vhd:443:35 */
  assign n851 = opa[31]; // extract
  /*# cupu_core.vhd:443:28 */
  assign n852 = n851 & n611;
  /*# cupu_core.vhd:444:27 */
  assign n853 = add_s[31:0]; // extract
  /*# cupu_core.vhd:443:13 */
  assign n854 = n852 ? n853 : opa;
  /*# cupu_core.vhd:440:11 */
  assign n856 = state == 5'b01010;
  /*# cupu_core.vhd:449:35 */
  assign n857 = opb[31]; // extract
  /*# cupu_core.vhd:449:28 */
  assign n858 = n857 & n611;
  /*# cupu_core.vhd:450:27 */
  assign n859 = add_s[31:0]; // extract
  /*# cupu_core.vhd:449:13 */
  assign n860 = n858 ? n859 : opb;
  /*# cupu_core.vhd:448:11 */
  assign n862 = state == 5'b01011;
  /*# cupu_core.vhd:459:27 */
  assign n863 = add_s[31:0]; // extract
  /*# cupu_core.vhd:461:25 */
  assign n864 = acc[30:0]; // extract
  /*# cupu_core.vhd:461:44 */
  assign n865 = opa[31]; // extract
  /*# cupu_core.vhd:461:39 */
  assign n866 = {n864, n865};
  /*# cupu_core.vhd:458:13 */
  assign n867 = n603 ? n863 : n866;
  /*# cupu_core.vhd:463:23 */
  assign n868 = opa[30:0]; // extract
  /*# cupu_core.vhd:463:37 */
  assign n869 = {n868, n603};
  /*# cupu_core.vhd:464:24 */
  assign n871 = cnt + 5'b00001;
  /*# cupu_core.vhd:465:20 */
  assign n873 = cnt == 5'b11111;
  /*# cupu_core.vhd:465:13 */
  assign n875 = n873 ? 5'b01101 : state;
  /*# cupu_core.vhd:456:11 */
  assign n877 = state == 5'b01100;
  /*# cupu_core.vhd:471:27 */
  assign n878 = add_s[31:0]; // extract
  /*# cupu_core.vhd:470:13 */
  assign n879 = sgn_q ? n878 : opa;
  /*# cupu_core.vhd:469:11 */
  assign n881 = state == 5'b01101;
  /*# cupu_core.vhd:477:27 */
  assign n882 = add_s[31:0]; // extract
  /*# cupu_core.vhd:476:13 */
  assign n883 = sgn_r ? n882 : acc;
  /*# cupu_core.vhd:475:11 */
  assign n885 = state == 5'b01110;
  /*# cupu_core.vhd:482:20 */
  assign n887 = cnt == 5'b00000;
  /*# cupu_core.vhd:485:22 */
  assign n888 = f_fn[0]; // extract
  /*# cupu_core.vhd:485:26 */
  assign n889 = ~n888;
  /*# cupu_core.vhd:486:27 */
  assign n890 = acc[30:0]; // extract
  /*# cupu_core.vhd:486:41 */
  assign n892 = {n890, 1'b0};
  /*# cupu_core.vhd:488:33 */
  assign n893 = acc[31:1]; // extract
  /*# cupu_core.vhd:488:28 */
  assign n895 = {1'b0, n893};
  /*# cupu_core.vhd:485:15 */
  assign n896 = n889 ? n892 : n895;
  /*# cupu_core.vhd:490:26 */
  assign n898 = cnt - 5'b00001;
  /*# cupu_core.vhd:482:13 */
  assign n900 = n887 ? 5'b00101 : state;
  /*# cupu_core.vhd:482:13 */
  assign n901 = n887 ? acc : n896;
  /*# cupu_core.vhd:482:13 */
  assign n902 = n887 ? cnt : n898;
  /*# cupu_core.vhd:481:11 */
  assign n904 = state == 5'b01111;
  /*# cupu_core.vhd:495:21 */
  assign n906 = op == 5'b10010;
  /*# cupu_core.vhd:499:43 */
  assign n908 = opa == 32'b00100000000000000000000000001000;
  /*# cupu_core.vhd:499:35 */
  assign n909 = n908 & mmio_sel;
  /*# cupu_core.vhd:500:47 */
  assign n910 = opb[7:0]; // extract
  /*# cupu_core.vhd:499:17 */
  assign n911 = n909 ? n910 : gpio;
  /*# cupu_core.vhd:495:15 */
  assign n914 = n906 ? 5'b00101 : 5'b00111;
  /*# cupu_core.vhd:494:13 */
  assign n915 = n918 ? acc_rdata : acc;
  /*# cupu_core.vhd:495:15 */
  assign n916 = n906 ? gpio : n911;
  /*# cupu_core.vhd:494:13 */
  assign n917 = acc_done ? n914 : state;
  /*# cupu_core.vhd:494:13 */
  assign n918 = n906 & acc_done;
  /*# cupu_core.vhd:494:13 */
  assign n919 = acc_done ? n916 : gpio;
  /*# cupu_core.vhd:493:11 */
  assign n921 = state == 5'b00100;
  /*# cupu_core.vhd:506:11 */
  assign n923 = state == 5'b00101;
  /*# cupu_core.vhd:506:21 */
  assign n925 = state == 5'b00111;
  /*# cupu_core.vhd:506:21 */
  assign n926 = n923 | n925;
  /*# cupu_core.vhd:510:11 */
  assign n928 = state == 5'b00110;
  /*# cupu_core.vhd:513:11 */
  assign n930 = state == 5'b10000;
  /*# cupu_core.vhd:342:9 */
  assign n931 = {n930, n928, n926, n921, n904, n885, n881, n877, n862, n856, n844, n832, n829, n632, n619, n617};
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n942 = state;
      16'b0100000000000000: n942 = 5'b00000;
      16'b0010000000000000: n942 = 5'b00000;
      16'b0001000000000000: n942 = n917;
      16'b0000100000000000: n942 = n900;
      16'b0000010000000000: n942 = 5'b00101;
      16'b0000001000000000: n942 = 5'b01110;
      16'b0000000100000000: n942 = n875;
      16'b0000000010000000: n942 = 5'b01100;
      16'b0000000001000000: n942 = 5'b01011;
      16'b0000000000100000: n942 = n842;
      16'b0000000000010000: n942 = 5'b00110;
      16'b0000000000001000: n942 = n821;
      16'b0000000000000100: n942 = 5'b00011;
      16'b0000000000000010: n942 = 5'b00010;
      16'b0000000000000001: n942 = n614;
      default: n942 = 5'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n944 = pc;
      16'b0100000000000000: n944 = pc;
      16'b0010000000000000: n944 = pc_inc;
      16'b0001000000000000: n944 = pc;
      16'b0000100000000000: n944 = pc;
      16'b0000010000000000: n944 = pc;
      16'b0000001000000000: n944 = pc;
      16'b0000000100000000: n944 = pc;
      16'b0000000010000000: n944 = pc;
      16'b0000000001000000: n944 = pc;
      16'b0000000000100000: n944 = pc;
      16'b0000000000010000: n944 = n830;
      16'b0000000000001000: n944 = n823;
      16'b0000000000000100: n944 = pc;
      16'b0000000000000010: n944 = pc;
      16'b0000000000000001: n944 = pc;
      default: n944 = 32'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n946 = ir;
      16'b0100000000000000: n946 = ir;
      16'b0010000000000000: n946 = ir;
      16'b0001000000000000: n946 = ir;
      16'b0000100000000000: n946 = ir;
      16'b0000010000000000: n946 = ir;
      16'b0000001000000000: n946 = ir;
      16'b0000000100000000: n946 = ir;
      16'b0000000010000000: n946 = ir;
      16'b0000000001000000: n946 = ir;
      16'b0000000000100000: n946 = ir;
      16'b0000000000010000: n946 = ir;
      16'b0000000000001000: n946 = ir;
      16'b0000000000000100: n946 = ir;
      16'b0000000000000010: n946 = ir;
      16'b0000000000000001: n946 = n615;
      default: n946 = 32'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n948 = opa;
      16'b0100000000000000: n948 = opa;
      16'b0010000000000000: n948 = opa;
      16'b0001000000000000: n948 = opa;
      16'b0000100000000000: n948 = opa;
      16'b0000010000000000: n948 = opa;
      16'b0000001000000000: n948 = n879;
      16'b0000000100000000: n948 = n869;
      16'b0000000010000000: n948 = opa;
      16'b0000000001000000: n948 = n854;
      16'b0000000000100000: n948 = n836;
      16'b0000000000010000: n948 = opa;
      16'b0000000000001000: n948 = n824;
      16'b0000000000000100: n948 = opa;
      16'b0000000000000010: n948 = rf_rd;
      16'b0000000000000001: n948 = opa;
      default: n948 = 32'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n950 = opb;
      16'b0100000000000000: n950 = opb;
      16'b0010000000000000: n950 = opb;
      16'b0001000000000000: n950 = opb;
      16'b0000100000000000: n950 = opb;
      16'b0000010000000000: n950 = opb;
      16'b0000001000000000: n950 = opb;
      16'b0000000100000000: n950 = opb;
      16'b0000000010000000: n950 = n860;
      16'b0000000001000000: n950 = opb;
      16'b0000000000100000: n950 = opb;
      16'b0000000000010000: n950 = opb;
      16'b0000000000001000: n950 = opb;
      16'b0000000000000100: n950 = n630;
      16'b0000000000000010: n950 = opb;
      16'b0000000000000001: n950 = opb;
      default: n950 = 32'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n953 = acc;
      16'b0100000000000000: n953 = acc;
      16'b0010000000000000: n953 = acc;
      16'b0001000000000000: n953 = n915;
      16'b0000100000000000: n953 = n901;
      16'b0000010000000000: n953 = n883;
      16'b0000001000000000: n953 = acc;
      16'b0000000100000000: n953 = n867;
      16'b0000000010000000: n953 = 32'b00000000000000000000000000000000;
      16'b0000000001000000: n953 = acc;
      16'b0000000000100000: n953 = n833;
      16'b0000000000010000: n953 = pc_inc;
      16'b0000000000001000: n953 = n825;
      16'b0000000000000100: n953 = acc;
      16'b0000000000000010: n953 = acc;
      16'b0000000000000001: n953 = acc;
      default: n953 = 32'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n956 = cnt;
      16'b0100000000000000: n956 = cnt;
      16'b0010000000000000: n956 = cnt;
      16'b0001000000000000: n956 = cnt;
      16'b0000100000000000: n956 = n902;
      16'b0000010000000000: n956 = cnt;
      16'b0000001000000000: n956 = cnt;
      16'b0000000100000000: n956 = n871;
      16'b0000000010000000: n956 = 5'b00000;
      16'b0000000001000000: n956 = cnt;
      16'b0000000000100000: n956 = n838;
      16'b0000000000010000: n956 = cnt;
      16'b0000000000001000: n956 = n826;
      16'b0000000000000100: n956 = cnt;
      16'b0000000000000010: n956 = cnt;
      16'b0000000000000001: n956 = cnt;
      default: n956 = 5'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n958 = flag;
      16'b0100000000000000: n958 = flag;
      16'b0010000000000000: n958 = flag;
      16'b0001000000000000: n958 = flag;
      16'b0000100000000000: n958 = flag;
      16'b0000010000000000: n958 = flag;
      16'b0000001000000000: n958 = flag;
      16'b0000000100000000: n958 = flag;
      16'b0000000010000000: n958 = flag;
      16'b0000000001000000: n958 = flag;
      16'b0000000000100000: n958 = flag;
      16'b0000000000010000: n958 = flag;
      16'b0000000000001000: n958 = n827;
      16'b0000000000000100: n958 = flag;
      16'b0000000000000010: n958 = flag;
      16'b0000000000000001: n958 = flag;
      default: n958 = 1'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n960 = sgn_q;
      16'b0100000000000000: n960 = sgn_q;
      16'b0010000000000000: n960 = sgn_q;
      16'b0001000000000000: n960 = sgn_q;
      16'b0000100000000000: n960 = sgn_q;
      16'b0000010000000000: n960 = sgn_q;
      16'b0000001000000000: n960 = sgn_q;
      16'b0000000100000000: n960 = sgn_q;
      16'b0000000010000000: n960 = sgn_q;
      16'b0000000001000000: n960 = n848;
      16'b0000000000100000: n960 = sgn_q;
      16'b0000000000010000: n960 = sgn_q;
      16'b0000000000001000: n960 = sgn_q;
      16'b0000000000000100: n960 = sgn_q;
      16'b0000000000000010: n960 = sgn_q;
      16'b0000000000000001: n960 = sgn_q;
      default: n960 = 1'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n962 = sgn_r;
      16'b0100000000000000: n962 = sgn_r;
      16'b0010000000000000: n962 = sgn_r;
      16'b0001000000000000: n962 = sgn_r;
      16'b0000100000000000: n962 = sgn_r;
      16'b0000010000000000: n962 = sgn_r;
      16'b0000001000000000: n962 = sgn_r;
      16'b0000000100000000: n962 = sgn_r;
      16'b0000000010000000: n962 = sgn_r;
      16'b0000000001000000: n962 = n850;
      16'b0000000000100000: n962 = sgn_r;
      16'b0000000000010000: n962 = sgn_r;
      16'b0000000000001000: n962 = sgn_r;
      16'b0000000000000100: n962 = sgn_r;
      16'b0000000000000010: n962 = sgn_r;
      16'b0000000000000001: n962 = sgn_r;
      default: n962 = 1'bX;
    endcase
  /*# cupu_core.vhd:342:9 */
  always @*
    case (n931)
      16'b1000000000000000: n964 = gpio;
      16'b0100000000000000: n964 = gpio;
      16'b0010000000000000: n964 = gpio;
      16'b0001000000000000: n964 = n919;
      16'b0000100000000000: n964 = gpio;
      16'b0000010000000000: n964 = gpio;
      16'b0000001000000000: n964 = gpio;
      16'b0000000100000000: n964 = gpio;
      16'b0000000010000000: n964 = gpio;
      16'b0000000001000000: n964 = gpio;
      16'b0000000000100000: n964 = gpio;
      16'b0000000000010000: n964 = gpio;
      16'b0000000000001000: n964 = gpio;
      16'b0000000000000100: n964 = gpio;
      16'b0000000000000010: n964 = gpio;
      16'b0000000000000001: n964 = gpio;
      default: n964 = 8'bX;
    endcase
  /*# cupu_core.vhd:332:7 */
  assign n966 = rst ? 5'b00000 : n942;
  /*# cupu_core.vhd:332:7 */
  assign n968 = rst ? 32'b00000000000000000000000000000000 : n944;
  /*# cupu_core.vhd:332:7 */
  assign n969 = rst ? ir : n946;
  /*# cupu_core.vhd:332:7 */
  assign n970 = rst ? opa : n948;
  /*# cupu_core.vhd:332:7 */
  assign n971 = rst ? opb : n950;
  /*# cupu_core.vhd:332:7 */
  assign n972 = rst ? acc : n953;
  /*# cupu_core.vhd:332:7 */
  assign n973 = rst ? cnt : n956;
  /*# cupu_core.vhd:332:7 */
  assign n975 = rst ? 1'b0 : n958;
  /*# cupu_core.vhd:332:7 */
  assign n976 = rst ? sgn_q : n960;
  /*# cupu_core.vhd:332:7 */
  assign n977 = rst ? sgn_r : n962;
  /*# cupu_core.vhd:332:7 */
  assign n979 = rst ? 8'b00000000 : n964;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1000 <= n966;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1001 <= n968;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1002 <= n969;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1003 <= n970;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1004 <= n971;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1005 <= n972;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1006 <= n973;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1007 <= n975;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1008 <= n976;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1009 <= n977;
  /*# cupu_core.vhd:331:5 */
  always @(posedge clk)
    n1010 <= n979;
  /*# cupu_core.vhd:299:5 */
  always @(posedge clk)
    n1011 <= n572;
  /*# cupu_core.vhd:299:5 */
  always @(posedge clk)
    n1012 <= n574;
  /*# cupu_core.vhd:153:21 */
  reg [31:0] regs[31:0] ; // memory
  assign n1013 = regs[rf_idx];
  always @(posedge clk)
    if (n588)
      regs[f_t] <= wb_val;
  /*# cupu_core.vhd:153:21 */
  /*# cupu_core.vhd:319:14 */
endmodule

module tt_um_zonlykroks_cupu
  (input  [7:0] ui_in,
   output [7:0] uo_out,
   input  [7:0] uio_in,
   output [7:0] uio_out,
   output [7:0] uio_oe,
   input  ena,
   input  clk,
   input  rst_n);
  wire rst;
  wire mem_req;
  wire mem_we;
  wire mem_done;
  wire [1:0] mem_size;
  wire [23:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [31:0] mem_rdata;
  wire sck;
  wire mosi;
  wire [1:0] cs_n;
  wire n3;
  wire [7:0] \core.gpio_out ;
  wire \core.halted ;
  wire n14;
  wire n20;
  wire n21;
  wire n23;
  wire [7:0] n24;
  wire [7:0] n26;
  assign uo_out = \core.gpio_out ; //(module output)
  assign uio_out = n26; //(module output)
  assign uio_oe = n24; //(module output)
  /*# tt_um_zonlykroks_cupu.vhd:27:10 */
  assign rst = n3; // (signal)
  /*# tt_um_zonlykroks_cupu.vhd:38:10 */
  assign n3 = ~rst_n;
  /*# tt_um_zonlykroks_cupu.vhd:40:3 */
  cupu_core_Brtl_25000000 core (
    .clk(clk),
    .rst(rst),
    .mem_rdata(mem_rdata),
    .mem_done(mem_done),
    .kbd_in(ui_in),
    .mem_req(mem_req),
    .mem_we(mem_we),
    .mem_size(mem_size),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .gpio_out(\core.gpio_out ),
    .halted());
  /*# tt_um_zonlykroks_cupu.vhd:57:3 */
  cupu_spi_Brtl spi (
    .clk(clk),
    .rst(rst),
    .req(mem_req),
    .we(mem_we),
    .size(mem_size),
    .addr(mem_addr),
    .wdata(mem_wdata),
    .miso(n14),
    .rdata(mem_rdata),
    .done(mem_done),
    .sck(sck),
    .mosi(mosi),
    .cs_n(cs_n));
  /*# tt_um_zonlykroks_cupu.vhd:70:22 */
  assign n14 = uio_in[2]; // extract
  /*# tt_um_zonlykroks_cupu.vhd:80:21 */
  assign n20 = cs_n[0]; // extract
  /*# tt_um_zonlykroks_cupu.vhd:81:21 */
  assign n21 = cs_n[1]; // extract
  /*# tt_um_zonlykroks_cupu.vhd:83:30 */
  assign n23 = ~rst_n;
  /*# tt_um_zonlykroks_cupu.vhd:83:19 */
  assign n24 = n23 ? 8'b00000000 : 8'b11001011;
  /*# tt_um_zonlykroks_cupu.vhd:18:5 */
  assign n26 = {n21, n20, 1'b0, 1'b0, sck, 1'b0, mosi, 1'b1};
endmodule

