// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-10-20T22:27:27
// Bambu executed with: /tmp/lesson15_tools/squashfs-root/usr/bin/bambu -I../cpp --top-fname=moving_max --compiler=I386_CLANG16 --device-name=5CSEMA5F31C6 --clock-period=5 --generate-interface=INFER --reset-type=async --reset-level=high ../cpp/moving_max.cpp ../cpp/max8.cpp 
// 
// Send any bug to: panda-info@polimi.it
// ************************************************************************
// The following text holds for all the components tagged with PANDA_LGPLv3.
// They are all part of the BAMBU/PANDA IP LIBRARY.
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public
// License along with the PandA framework; see the files COPYING.LIB
// If not, see <http://www.gnu.org/licenses/>.
// ************************************************************************


`ifdef __ICARUS__
  `define _SIM_HAVE_CLOG2
`endif
`ifdef VERILATOR
  `define _SIM_HAVE_CLOG2
`endif
`ifdef MODEL_TECH
  `define _SIM_HAVE_CLOG2
`endif
`ifdef VCS
  `define _SIM_HAVE_CLOG2
`endif
`ifdef NCVERILOG
  `define _SIM_HAVE_CLOG2
`endif
`ifdef XILINX_SIMULATOR
  `define _SIM_HAVE_CLOG2
`endif
`ifdef XILINX_ISIM
  `define _SIM_HAVE_CLOG2
`endif

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>, Christian Pilato <christian.pilato@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module constant_value(out1);
  parameter BITSIZE_out1=1,
    value=1'b0;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = value;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module register_SARSE(clock,
  reset,
  in1,
  wenable,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input clock;
  input reset;
  input [BITSIZE_in1-1:0] in1;
  input wenable;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  
  reg [BITSIZE_out1-1:0] reg_out1 =0;
  assign out1 = reg_out1;
  always @(posedge clock or posedge reset)
    if (reset == 1'b1)
      reg_out1 <= {BITSIZE_out1{1'b0}};
    else if (wenable)
      reg_out1 <= in1;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module register_STD(clock,
  reset,
  in1,
  wenable,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input clock;
  input reset;
  input [BITSIZE_in1-1:0] in1;
  input wenable;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  reg [BITSIZE_out1-1:0] reg_out1 =0;
  assign out1 = reg_out1;
  always @(posedge clock)
    reg_out1 <= in1;

endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module UIdata_converter_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output signed [BITSIZE_out1-1:0] out1;
  generate
  if (BITSIZE_out1 <= BITSIZE_in1)
  begin
    assign out1 = in1[BITSIZE_out1-1:0];
  end
  else
  begin
    assign out1 = {{(BITSIZE_out1-BITSIZE_in1){1'b0}},in1};
  end
  endgenerate
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module IUdata_converter_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input signed [BITSIZE_in1-1:0] in1;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  generate
  if (BITSIZE_out1 <= BITSIZE_in1)
  begin
    assign out1 = in1[BITSIZE_out1-1:0];
  end
  else
  begin
    assign out1 = {{(BITSIZE_out1-BITSIZE_in1){in1[BITSIZE_in1-1]}},in1};
  end
  endgenerate
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module UUdata_converter_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  generate
  if (BITSIZE_out1 <= BITSIZE_in1)
  begin
    assign out1 = in1[BITSIZE_out1-1:0];
  end
  else
  begin
    assign out1 = {{(BITSIZE_out1-BITSIZE_in1){1'b0}},in1};
  end
  endgenerate
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module read_cond_FU(in1,
  out1);
  parameter BITSIZE_in1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output out1;
  assign out1 = in1 != {BITSIZE_in1{1'b0}};
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module max_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input signed [BITSIZE_in1-1:0] in1;
  input signed [BITSIZE_in2-1:0] in2;
  // OUT
  output signed [BITSIZE_out1-1:0] out1;
  assign out1 = in1 > in2 ? in1 : in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_eq_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1 == in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_lshift_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1,
    PRECISION=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  `ifndef _SIM_HAVE_CLOG2
    function integer log2;
       input integer value;
       integer temp_value;
      begin
        temp_value = value-1;
        for (log2=0; temp_value>0; log2=log2+1)
          temp_value = temp_value>>1;
      end
    endfunction
  `endif
  `ifdef _SIM_HAVE_CLOG2
    localparam arg2_bitsize = $clog2(PRECISION);
  `else
    localparam arg2_bitsize = log2(PRECISION);
  `endif
  generate
    if(BITSIZE_in2 > arg2_bitsize)
      assign out1 = in1 << in2[arg2_bitsize-1:0];
    else
      assign out1 = in1 << in2;
  endgenerate
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_plus_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1 + in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_pointer_plus_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1,
    LSB_PARAMETER=-1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  wire [BITSIZE_out1-1:0] in1_tmp;
  wire [BITSIZE_out1-1:0] in2_tmp;
  assign in1_tmp = in1;
  assign in2_tmp = in2;generate if (BITSIZE_out1 > LSB_PARAMETER) assign out1[BITSIZE_out1-1:LSB_PARAMETER] = (in1_tmp[BITSIZE_out1-1:LSB_PARAMETER] + in2_tmp[BITSIZE_out1-1:LSB_PARAMETER]); else assign out1 = 0; endgenerate
  generate if (LSB_PARAMETER != 0 && BITSIZE_out1 > LSB_PARAMETER) assign out1[LSB_PARAMETER-1:0] = 0; endgenerate
endmodule

// Interface module for function: in_bambu_artificial_ParmMgr
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module in_bambu_artificial_ParmMgr_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  in4,
  _in_q0,
  _in_q1,
  out1,
  _in_address0,
  _in_address1,
  _in_ce0,
  _in_ce1);
  parameter BITSIZE_in1=1, PORTSIZE_in1=2,
    BITSIZE_in2=6, PORTSIZE_in2=2,
    BITSIZE_in3=32, PORTSIZE_in3=2,
    BITSIZE_in4=32, PORTSIZE_in4=2,
    BITSIZE_out1=32, PORTSIZE_out1=2;
  // IN
  input clock;
  input reset;
  input [1:0] start_port;
  input [(PORTSIZE_in1*BITSIZE_in1)+(-1):0] in1;
  input [(PORTSIZE_in2*BITSIZE_in2)+(-1):0] in2;
  input [(PORTSIZE_in3*BITSIZE_in3)+(-1):0] in3;
  input [(PORTSIZE_in4*BITSIZE_in4)+(-1):0] in4;
  input [31:0] _in_q0;
  input [31:0] _in_q1;
  // OUT
  output [(PORTSIZE_out1*BITSIZE_out1)+(-1):0] out1;
  output [5:0] _in_address0;
  output [5:0] _in_address1;
  output _in_ce0;
  output _in_ce1;
  //T
  assign _in_ce0 = start_port[0];
  assign _in_ce1 = start_port[1];
  assign _in_address0 = in4[BITSIZE_in4*0+:8] / 4;
  assign _in_address1 = in4[BITSIZE_in4*1+:8] / 4;
  assign out1[BITSIZE_out1*0+:BITSIZE_out1] = _in_q0;
  assign out1[BITSIZE_out1*1+:BITSIZE_out1] = _in_q1;

endmodule

// Interface module for function: out_bambu_artificial_ParmMgr
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module out_bambu_artificial_ParmMgr_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  in4,
  out1,
  _out_address0,
  _out_address1,
  _out_ce0,
  _out_ce1,
  _out_we0,
  _out_we1,
  _out_d0,
  _out_d1);
  parameter BITSIZE_in1=1, PORTSIZE_in1=2,
    BITSIZE_in2=6, PORTSIZE_in2=2,
    BITSIZE_in3=32, PORTSIZE_in3=2,
    BITSIZE_in4=32, PORTSIZE_in4=2,
    BITSIZE_out1=32, PORTSIZE_out1=2;
  // IN
  input clock;
  input reset;
  input [1:0] start_port;
  input [(PORTSIZE_in1*BITSIZE_in1)+(-1):0] in1;
  input [(PORTSIZE_in2*BITSIZE_in2)+(-1):0] in2;
  input [(PORTSIZE_in3*BITSIZE_in3)+(-1):0] in3;
  input [(PORTSIZE_in4*BITSIZE_in4)+(-1):0] in4;
  // OUT
  output [(PORTSIZE_out1*BITSIZE_out1)+(-1):0] out1;
  output [5:0] _out_address0;
  output [5:0] _out_address1;
  output _out_ce0;
  output _out_ce1;
  output _out_we0;
  output _out_we1;
  output [31:0] _out_d0;
  output [31:0] _out_d1;
  //T
  assign _out_ce0 = start_port[0];
  assign _out_ce1 = start_port[1];
  assign _out_address0 = in4[BITSIZE_in4*0+:8] / 4;
  assign _out_address1 = in4[BITSIZE_in4*1+:8] / 4;
  assign _out_we0 = start_port[0] & (|in1[BITSIZE_in1*0+:BITSIZE_in1]);
  assign _out_d0 = in3[BITSIZE_in3*0+:BITSIZE_in3];
  assign _out_we1 = start_port[1] & (|in1[BITSIZE_in1*1+:BITSIZE_in1]);
  assign _out_d1 = in3[BITSIZE_in3*1+:BITSIZE_in3];

endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>, Christian Pilato <christian.pilato@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module MUX_GATE(sel,
  in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input sel;
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = sel ? in1 : in2;
endmodule

// Datapath RTL description for _Z10moving_maxPiS_
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z10moving_maxPiS_(clock,
  reset,
  in_port_in,
  in_port_out,
  _in_q0,
  _in_q1,
  _in_address0,
  _in_address1,
  _in_ce0,
  _in_ce1,
  _out_address0,
  _out_address1,
  _out_ce0,
  _out_ce1,
  _out_we0,
  _out_we1,
  _out_d0,
  _out_d1,
  selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562,
  selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737,
  selector_MUX_34_reg_0_0_0_0,
  selector_MUX_35_reg_1_0_0_0,
  selector_MUX_46_reg_2_0_0_0,
  selector_MUX_48_reg_3_0_0_0,
  selector_MUX_49_reg_4_0_0_0,
  selector_MUX_50_reg_5_0_0_0,
  selector_MUX_51_reg_6_0_0_0,
  selector_MUX_52_reg_7_0_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_15,
  wrenable_reg_16,
  wrenable_reg_17,
  wrenable_reg_18,
  wrenable_reg_19,
  wrenable_reg_2,
  wrenable_reg_20,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z10moving_maxPiS__428532_428574,
  OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562,
  OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_in;
  input [31:0] in_port_out;
  input [31:0] _in_q0;
  input [31:0] _in_q1;
  input selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  input selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  input selector_MUX_34_reg_0_0_0_0;
  input selector_MUX_35_reg_1_0_0_0;
  input selector_MUX_46_reg_2_0_0_0;
  input selector_MUX_48_reg_3_0_0_0;
  input selector_MUX_49_reg_4_0_0_0;
  input selector_MUX_50_reg_5_0_0_0;
  input selector_MUX_51_reg_6_0_0_0;
  input selector_MUX_52_reg_7_0_0_0;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_10;
  input wrenable_reg_11;
  input wrenable_reg_12;
  input wrenable_reg_13;
  input wrenable_reg_14;
  input wrenable_reg_15;
  input wrenable_reg_16;
  input wrenable_reg_17;
  input wrenable_reg_18;
  input wrenable_reg_19;
  input wrenable_reg_2;
  input wrenable_reg_20;
  input wrenable_reg_3;
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output [5:0] _in_address0;
  output [5:0] _in_address1;
  output _in_ce0;
  output _in_ce1;
  output [5:0] _out_address0;
  output [5:0] _out_address1;
  output _out_ce0;
  output _out_ce1;
  output _out_we0;
  output _out_we1;
  output [31:0] _out_d0;
  output [31:0] _out_d1;
  output OUT_CONDITION__Z10moving_maxPiS__428532_428574;
  output OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  output OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  // Component and signal declarations
  wire [31:0] null_out_signal_fu__Z10moving_maxPiS__428532_428562_out1_1;
  wire [31:0] null_out_signal_fu__Z10moving_maxPiS__428532_428737_out1_0;
  wire [31:0] null_out_signal_fu__Z10moving_maxPiS__428532_428737_out1_1;
  wire [31:0] out_IUdata_converter_FU_19_i0_fu__Z10moving_maxPiS__428532_428679;
  wire [31:0] out_MUX_34_reg_0_0_0_0;
  wire [31:0] out_MUX_35_reg_1_0_0_0;
  wire [31:0] out_MUX_46_reg_2_0_0_0;
  wire [31:0] out_MUX_48_reg_3_0_0_0;
  wire [31:0] out_MUX_49_reg_4_0_0_0;
  wire [31:0] out_MUX_50_reg_5_0_0_0;
  wire [31:0] out_MUX_51_reg_6_0_0_0;
  wire [31:0] out_MUX_52_reg_7_0_0_0;
  wire signed [31:0] out_UIdata_converter_FU_11_i0_fu__Z10moving_maxPiS__428532_428658;
  wire signed [31:0] out_UIdata_converter_FU_12_i0_fu__Z10moving_maxPiS__428532_428660;
  wire signed [31:0] out_UIdata_converter_FU_13_i0_fu__Z10moving_maxPiS__428532_428663;
  wire signed [31:0] out_UIdata_converter_FU_14_i0_fu__Z10moving_maxPiS__428532_428665;
  wire signed [31:0] out_UIdata_converter_FU_15_i0_fu__Z10moving_maxPiS__428532_428668;
  wire signed [31:0] out_UIdata_converter_FU_16_i0_fu__Z10moving_maxPiS__428532_428670;
  wire signed [31:0] out_UIdata_converter_FU_17_i0_fu__Z10moving_maxPiS__428532_428673;
  wire signed [31:0] out_UIdata_converter_FU_18_i0_fu__Z10moving_maxPiS__428532_428675;
  wire out_UUdata_converter_FU_20_i0_fu__Z10moving_maxPiS__428532_428573;
  wire out_const_0;
  wire out_const_1;
  wire [1:0] out_const_2;
  wire [5:0] out_const_3;
  wire [6:0] out_const_4;
  wire [31:0] out_const_5;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [31:0] out_in_bambu_artificial_ParmMgr_modgen_28_i0_fu__Z10moving_maxPiS__428532_428562;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i0_fu__Z10moving_maxPiS__428532_428563;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i1_fu__Z10moving_maxPiS__428532_428564;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i2_fu__Z10moving_maxPiS__428532_428565;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i3_fu__Z10moving_maxPiS__428532_428566;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i4_fu__Z10moving_maxPiS__428532_428567;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i5_fu__Z10moving_maxPiS__428532_428568;
  wire signed [31:0] out_max_expr_FU_32_32_32_23_i6_fu__Z10moving_maxPiS__428532_428569;
  wire out_read_cond_FU_21_i0_fu__Z10moving_maxPiS__428532_428574;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire [31:0] out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire out_reg_13_reg_13;
  wire [31:0] out_reg_14_reg_14;
  wire [31:0] out_reg_15_reg_15;
  wire [31:0] out_reg_16_reg_16;
  wire [31:0] out_reg_17_reg_17;
  wire [31:0] out_reg_18_reg_18;
  wire [31:0] out_reg_19_reg_19;
  wire [31:0] out_reg_1_reg_1;
  wire [31:0] out_reg_20_reg_20;
  wire [31:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_ui_eq_expr_FU_32_0_32_24_i0_fu__Z10moving_maxPiS__428532_428685;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_25_i0_fu__Z10moving_maxPiS__428532_428655;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_26_i0_fu__Z10moving_maxPiS__428532_428572;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_27_i0_fu__Z10moving_maxPiS__428532_428561;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_27_i1_fu__Z10moving_maxPiS__428532_428570;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_34_reg_0_0_0_0 (.out1(out_MUX_34_reg_0_0_0_0),
    .sel(selector_MUX_34_reg_0_0_0_0),
    .in1(out_reg_1_reg_1),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_35_reg_1_0_0_0 (.out1(out_MUX_35_reg_1_0_0_0),
    .sel(selector_MUX_35_reg_1_0_0_0),
    .in1(out_reg_2_reg_2),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_46_reg_2_0_0_0 (.out1(out_MUX_46_reg_2_0_0_0),
    .sel(selector_MUX_46_reg_2_0_0_0),
    .in1(out_reg_3_reg_3),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_48_reg_3_0_0_0 (.out1(out_MUX_48_reg_3_0_0_0),
    .sel(selector_MUX_48_reg_3_0_0_0),
    .in1(out_reg_4_reg_4),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_49_reg_4_0_0_0 (.out1(out_MUX_49_reg_4_0_0_0),
    .sel(selector_MUX_49_reg_4_0_0_0),
    .in1(out_reg_5_reg_5),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_50_reg_5_0_0_0 (.out1(out_MUX_50_reg_5_0_0_0),
    .sel(selector_MUX_50_reg_5_0_0_0),
    .in1(out_reg_6_reg_6),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_51_reg_6_0_0_0 (.out1(out_MUX_51_reg_6_0_0_0),
    .sel(selector_MUX_51_reg_6_0_0_0),
    .in1(out_reg_16_reg_16),
    .in2(out_const_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_52_reg_7_0_0_0 (.out1(out_MUX_52_reg_7_0_0_0),
    .sel(selector_MUX_52_reg_7_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_26_i0_fu__Z10moving_maxPiS__428532_428572),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b10)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b10000000000000000000000000000000)) const_5 (.out1(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z10moving_maxPiS__428532_428561 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_27_i0_fu__Z10moving_maxPiS__428532_428561),
    .in1(in_port_in),
    .in2(out_ui_lshift_expr_FU_32_0_32_25_i0_fu__Z10moving_maxPiS__428532_428655));
  in_bambu_artificial_ParmMgr_modgen #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_in2(6),
    .PORTSIZE_in2(2),
    .BITSIZE_in3(32),
    .PORTSIZE_in3(2),
    .BITSIZE_in4(32),
    .PORTSIZE_in4(2),
    .BITSIZE_out1(32),
    .PORTSIZE_out1(2)) fu__Z10moving_maxPiS__428532_428562 (.out1({null_out_signal_fu__Z10moving_maxPiS__428532_428562_out1_1,
      out_in_bambu_artificial_ParmMgr_modgen_28_i0_fu__Z10moving_maxPiS__428532_428562}),
    ._in_address0(_in_address0),
    ._in_address1(_in_address1),
    ._in_ce0(_in_ce0),
    ._in_ce1(_in_ce1),
    .clock(clock),
    .reset(reset),
    .start_port({1'b0,
      selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562}),
    .in1({1'b0,
      out_const_0}),
    .in2({6'b000000,
      out_const_3}),
    .in3({32'b00000000000000000000000000000000,
      out_conv_out_const_0_1_32}),
    .in4({32'b00000000000000000000000000000000,
      out_reg_8_reg_8}),
    ._in_q0(_in_q0),
    ._in_q1(_in_q1));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428563 (.out1(out_max_expr_FU_32_32_32_23_i0_fu__Z10moving_maxPiS__428532_428563),
    .in1(out_reg_17_reg_17),
    .in2(out_reg_14_reg_14));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428564 (.out1(out_max_expr_FU_32_32_32_23_i1_fu__Z10moving_maxPiS__428532_428564),
    .in1(out_UIdata_converter_FU_13_i0_fu__Z10moving_maxPiS__428532_428663),
    .in2(out_UIdata_converter_FU_14_i0_fu__Z10moving_maxPiS__428532_428665));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428565 (.out1(out_max_expr_FU_32_32_32_23_i2_fu__Z10moving_maxPiS__428532_428565),
    .in1(out_UIdata_converter_FU_15_i0_fu__Z10moving_maxPiS__428532_428668),
    .in2(out_UIdata_converter_FU_16_i0_fu__Z10moving_maxPiS__428532_428670));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428566 (.out1(out_max_expr_FU_32_32_32_23_i3_fu__Z10moving_maxPiS__428532_428566),
    .in1(out_UIdata_converter_FU_17_i0_fu__Z10moving_maxPiS__428532_428673),
    .in2(out_UIdata_converter_FU_18_i0_fu__Z10moving_maxPiS__428532_428675));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428567 (.out1(out_max_expr_FU_32_32_32_23_i4_fu__Z10moving_maxPiS__428532_428567),
    .in1(out_reg_18_reg_18),
    .in2(out_reg_9_reg_9));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428568 (.out1(out_max_expr_FU_32_32_32_23_i5_fu__Z10moving_maxPiS__428532_428568),
    .in1(out_reg_10_reg_10),
    .in2(out_reg_11_reg_11));
  max_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428569 (.out1(out_max_expr_FU_32_32_32_23_i6_fu__Z10moving_maxPiS__428532_428569),
    .in1(out_reg_19_reg_19),
    .in2(out_reg_15_reg_15));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z10moving_maxPiS__428532_428570 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_27_i1_fu__Z10moving_maxPiS__428532_428570),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_25_i0_fu__Z10moving_maxPiS__428532_428655));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428572 (.out1(out_ui_plus_expr_FU_32_0_32_26_i0_fu__Z10moving_maxPiS__428532_428572),
    .in1(out_reg_7_reg_7),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z10moving_maxPiS__428532_428573 (.out1(out_UUdata_converter_FU_20_i0_fu__Z10moving_maxPiS__428532_428573),
    .in1(out_ui_eq_expr_FU_32_0_32_24_i0_fu__Z10moving_maxPiS__428532_428685));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z10moving_maxPiS__428532_428574 (.out1(out_read_cond_FU_21_i0_fu__Z10moving_maxPiS__428532_428574),
    .in1(out_reg_13_reg_13));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z10moving_maxPiS__428532_428655 (.out1(out_ui_lshift_expr_FU_32_0_32_25_i0_fu__Z10moving_maxPiS__428532_428655),
    .in1(out_reg_7_reg_7),
    .in2(out_const_2));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428658 (.out1(out_UIdata_converter_FU_11_i0_fu__Z10moving_maxPiS__428532_428658),
    .in1(out_in_bambu_artificial_ParmMgr_modgen_28_i0_fu__Z10moving_maxPiS__428532_428562));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428660 (.out1(out_UIdata_converter_FU_12_i0_fu__Z10moving_maxPiS__428532_428660),
    .in1(out_reg_6_reg_6));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428663 (.out1(out_UIdata_converter_FU_13_i0_fu__Z10moving_maxPiS__428532_428663),
    .in1(out_reg_5_reg_5));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428665 (.out1(out_UIdata_converter_FU_14_i0_fu__Z10moving_maxPiS__428532_428665),
    .in1(out_reg_4_reg_4));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428668 (.out1(out_UIdata_converter_FU_15_i0_fu__Z10moving_maxPiS__428532_428668),
    .in1(out_reg_3_reg_3));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428670 (.out1(out_UIdata_converter_FU_16_i0_fu__Z10moving_maxPiS__428532_428670),
    .in1(out_reg_2_reg_2));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428673 (.out1(out_UIdata_converter_FU_17_i0_fu__Z10moving_maxPiS__428532_428673),
    .in1(out_reg_1_reg_1));
  UIdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428675 (.out1(out_UIdata_converter_FU_18_i0_fu__Z10moving_maxPiS__428532_428675),
    .in1(out_reg_0_reg_0));
  IUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z10moving_maxPiS__428532_428679 (.out1(out_IUdata_converter_FU_19_i0_fu__Z10moving_maxPiS__428532_428679),
    .in1(out_max_expr_FU_32_32_32_23_i6_fu__Z10moving_maxPiS__428532_428569));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(7),
    .BITSIZE_out1(1)) fu__Z10moving_maxPiS__428532_428685 (.out1(out_ui_eq_expr_FU_32_0_32_24_i0_fu__Z10moving_maxPiS__428532_428685),
    .in1(out_ui_plus_expr_FU_32_0_32_26_i0_fu__Z10moving_maxPiS__428532_428572),
    .in2(out_const_4));
  out_bambu_artificial_ParmMgr_modgen #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_in2(6),
    .PORTSIZE_in2(2),
    .BITSIZE_in3(32),
    .PORTSIZE_in3(2),
    .BITSIZE_in4(32),
    .PORTSIZE_in4(2),
    .BITSIZE_out1(32),
    .PORTSIZE_out1(2)) fu__Z10moving_maxPiS__428532_428737 (.out1({null_out_signal_fu__Z10moving_maxPiS__428532_428737_out1_1,
      null_out_signal_fu__Z10moving_maxPiS__428532_428737_out1_0}),
    ._out_address0(_out_address0),
    ._out_address1(_out_address1),
    ._out_ce0(_out_ce0),
    ._out_ce1(_out_ce1),
    ._out_we0(_out_we0),
    ._out_we1(_out_we1),
    ._out_d0(_out_d0),
    ._out_d1(_out_d1),
    .clock(clock),
    .reset(reset),
    .start_port({1'b0,
      selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737}),
    .in1({1'b0,
      out_const_1}),
    .in2({6'b000000,
      out_const_3}),
    .in3({32'b00000000000000000000000000000000,
      out_reg_20_reg_20}),
    .in4({32'b00000000000000000000000000000000,
      out_reg_12_reg_12}));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_34_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_35_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_max_expr_FU_32_32_32_23_i2_fu__Z10moving_maxPiS__428532_428565),
    .wenable(wrenable_reg_10));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_max_expr_FU_32_32_32_23_i3_fu__Z10moving_maxPiS__428532_428566),
    .wenable(wrenable_reg_11));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_27_i1_fu__Z10moving_maxPiS__428532_428570),
    .wenable(wrenable_reg_12));
  register_SARSE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z10moving_maxPiS__428532_428573),
    .wenable(wrenable_reg_13));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_UIdata_converter_FU_12_i0_fu__Z10moving_maxPiS__428532_428660),
    .wenable(wrenable_reg_14));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_max_expr_FU_32_32_32_23_i5_fu__Z10moving_maxPiS__428532_428568),
    .wenable(wrenable_reg_15));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_in_bambu_artificial_ParmMgr_modgen_28_i0_fu__Z10moving_maxPiS__428532_428562),
    .wenable(wrenable_reg_16));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_UIdata_converter_FU_11_i0_fu__Z10moving_maxPiS__428532_428658),
    .wenable(wrenable_reg_17));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_18 (.out1(out_reg_18_reg_18),
    .clock(clock),
    .reset(reset),
    .in1(out_max_expr_FU_32_32_32_23_i0_fu__Z10moving_maxPiS__428532_428563),
    .wenable(wrenable_reg_18));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_19 (.out1(out_reg_19_reg_19),
    .clock(clock),
    .reset(reset),
    .in1(out_max_expr_FU_32_32_32_23_i4_fu__Z10moving_maxPiS__428532_428567),
    .wenable(wrenable_reg_19));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_46_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_20 (.out1(out_reg_20_reg_20),
    .clock(clock),
    .reset(reset),
    .in1(out_IUdata_converter_FU_19_i0_fu__Z10moving_maxPiS__428532_428679),
    .wenable(wrenable_reg_20));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_48_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_49_reg_4_0_0_0),
    .wenable(wrenable_reg_4));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_50_reg_5_0_0_0),
    .wenable(wrenable_reg_5));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_51_reg_6_0_0_0),
    .wenable(wrenable_reg_6));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_52_reg_7_0_0_0),
    .wenable(wrenable_reg_7));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_27_i0_fu__Z10moving_maxPiS__428532_428561),
    .wenable(wrenable_reg_8));
  register_SARSE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_max_expr_FU_32_32_32_23_i1_fu__Z10moving_maxPiS__428532_428564),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z10moving_maxPiS__428532_428574 = out_read_cond_FU_21_i0_fu__Z10moving_maxPiS__428532_428574;

endmodule

// FSM based controller description for _Z10moving_maxPiS_
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z10moving_maxPiS_(done_port,
  selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562,
  selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737,
  selector_MUX_34_reg_0_0_0_0,
  selector_MUX_35_reg_1_0_0_0,
  selector_MUX_46_reg_2_0_0_0,
  selector_MUX_48_reg_3_0_0_0,
  selector_MUX_49_reg_4_0_0_0,
  selector_MUX_50_reg_5_0_0_0,
  selector_MUX_51_reg_6_0_0_0,
  selector_MUX_52_reg_7_0_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_15,
  wrenable_reg_16,
  wrenable_reg_17,
  wrenable_reg_18,
  wrenable_reg_19,
  wrenable_reg_2,
  wrenable_reg_20,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z10moving_maxPiS__428532_428574,
  OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562,
  OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z10moving_maxPiS__428532_428574;
  input OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  input OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  output selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  output selector_MUX_34_reg_0_0_0_0;
  output selector_MUX_35_reg_1_0_0_0;
  output selector_MUX_46_reg_2_0_0_0;
  output selector_MUX_48_reg_3_0_0_0;
  output selector_MUX_49_reg_4_0_0_0;
  output selector_MUX_50_reg_5_0_0_0;
  output selector_MUX_51_reg_6_0_0_0;
  output selector_MUX_52_reg_7_0_0_0;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_10;
  output wrenable_reg_11;
  output wrenable_reg_12;
  output wrenable_reg_13;
  output wrenable_reg_14;
  output wrenable_reg_15;
  output wrenable_reg_16;
  output wrenable_reg_17;
  output wrenable_reg_18;
  output wrenable_reg_19;
  output wrenable_reg_2;
  output wrenable_reg_20;
  output wrenable_reg_3;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [3:0] S_7 = 4'd7,
    S_0 = 4'd0,
    S_1 = 4'd1,
    S_2 = 4'd2,
    S_3 = 4'd3,
    S_4 = 4'd4,
    S_5 = 4'd5,
    S_6 = 4'd6,
    S_8 = 4'd8;
  reg [3:0] _present_state=S_7, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  reg selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  reg selector_MUX_34_reg_0_0_0_0;
  reg selector_MUX_35_reg_1_0_0_0;
  reg selector_MUX_46_reg_2_0_0_0;
  reg selector_MUX_48_reg_3_0_0_0;
  reg selector_MUX_49_reg_4_0_0_0;
  reg selector_MUX_50_reg_5_0_0_0;
  reg selector_MUX_51_reg_6_0_0_0;
  reg selector_MUX_52_reg_7_0_0_0;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_10;
  reg wrenable_reg_11;
  reg wrenable_reg_12;
  reg wrenable_reg_13;
  reg wrenable_reg_14;
  reg wrenable_reg_15;
  reg wrenable_reg_16;
  reg wrenable_reg_17;
  reg wrenable_reg_18;
  reg wrenable_reg_19;
  reg wrenable_reg_2;
  reg wrenable_reg_20;
  reg wrenable_reg_3;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock or posedge reset)
    if (reset == 1'b1) _present_state <= S_7;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562 = 1'b0;
    selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737 = 1'b0;
    selector_MUX_34_reg_0_0_0_0 = 1'b0;
    selector_MUX_35_reg_1_0_0_0 = 1'b0;
    selector_MUX_46_reg_2_0_0_0 = 1'b0;
    selector_MUX_48_reg_3_0_0_0 = 1'b0;
    selector_MUX_49_reg_4_0_0_0 = 1'b0;
    selector_MUX_50_reg_5_0_0_0 = 1'b0;
    selector_MUX_51_reg_6_0_0_0 = 1'b0;
    selector_MUX_52_reg_7_0_0_0 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_10 = 1'b0;
    wrenable_reg_11 = 1'b0;
    wrenable_reg_12 = 1'b0;
    wrenable_reg_13 = 1'b0;
    wrenable_reg_14 = 1'b0;
    wrenable_reg_15 = 1'b0;
    wrenable_reg_16 = 1'b0;
    wrenable_reg_17 = 1'b0;
    wrenable_reg_18 = 1'b0;
    wrenable_reg_19 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_20 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_7 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          _next_state = S_0;
        end
        else
        begin
          _next_state = S_7;
        end
      S_0 :
        begin
          selector_MUX_52_reg_7_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          _next_state = S_1;
        end
      S_1 :
        begin
          selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562 = 1'b1;
          wrenable_reg_15 = 1'b1;
          _next_state = S_2;
        end
      S_2 :
        begin
          wrenable_reg_16 = 1'b1;
          wrenable_reg_17 = 1'b1;
          _next_state = S_3;
        end
      S_3 :
        begin
          wrenable_reg_18 = 1'b1;
          _next_state = S_4;
        end
      S_4 :
        begin
          wrenable_reg_19 = 1'b1;
          _next_state = S_5;
        end
      S_5 :
        begin
          wrenable_reg_20 = 1'b1;
          _next_state = S_6;
        end
      S_6 :
        begin
          selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737 = 1'b1;
          selector_MUX_34_reg_0_0_0_0 = 1'b1;
          selector_MUX_35_reg_1_0_0_0 = 1'b1;
          selector_MUX_46_reg_2_0_0_0 = 1'b1;
          selector_MUX_48_reg_3_0_0_0 = 1'b1;
          selector_MUX_49_reg_4_0_0_0 = 1'b1;
          selector_MUX_50_reg_5_0_0_0 = 1'b1;
          selector_MUX_51_reg_6_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          if (OUT_CONDITION__Z10moving_maxPiS__428532_428574 == 1'b1)
            begin
              _next_state = S_8;
              done_port = 1'b1;
              selector_MUX_34_reg_0_0_0_0 = 1'b0;
              selector_MUX_35_reg_1_0_0_0 = 1'b0;
              selector_MUX_46_reg_2_0_0_0 = 1'b0;
              selector_MUX_48_reg_3_0_0_0 = 1'b0;
              selector_MUX_49_reg_4_0_0_0 = 1'b0;
              selector_MUX_50_reg_5_0_0_0 = 1'b0;
              selector_MUX_51_reg_6_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_2 = 1'b0;
              wrenable_reg_3 = 1'b0;
              wrenable_reg_4 = 1'b0;
              wrenable_reg_5 = 1'b0;
              wrenable_reg_6 = 1'b0;
            end
          else
            begin
              _next_state = S_0;
            end
        end
      S_8 :
        begin
          _next_state = S_7;
        end
      default :
        begin
          _next_state = S_7;
        end
    endcase
  end
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Marco Lattuada <marco.lattuada@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module flipflop_AR(clock,
  reset,
  in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input clock;
  input reset;
  input in1;
  // OUT
  output out1;
  
  reg reg_out1 =0;
  assign out1 = reg_out1;
  always @(posedge clock or posedge reset)
    if (reset == 1'b1)
      reg_out1 <= {BITSIZE_out1{1'b0}};
    else
      reg_out1 <= in1;
endmodule

// Top component for _Z10moving_maxPiS_
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z10moving_maxPiS_(clock,
  reset,
  start_port,
  done_port,
  in,
  out,
  _in_q0,
  _in_q1,
  _in_address0,
  _in_address1,
  _in_ce0,
  _in_ce1,
  _out_address0,
  _out_address1,
  _out_ce0,
  _out_ce1,
  _out_we0,
  _out_we1,
  _out_d0,
  _out_d1);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] in;
  input [31:0] out;
  input [31:0] _in_q0;
  input [31:0] _in_q1;
  // OUT
  output done_port;
  output [5:0] _in_address0;
  output [5:0] _in_address1;
  output _in_ce0;
  output _in_ce1;
  output [5:0] _out_address0;
  output [5:0] _out_address1;
  output _out_ce0;
  output _out_ce1;
  output _out_we0;
  output _out_we1;
  output [31:0] _out_d0;
  output [31:0] _out_d1;
  // Component and signal declarations
  wire OUT_CONDITION__Z10moving_maxPiS__428532_428574;
  wire OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  wire OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562;
  wire selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737;
  wire selector_MUX_34_reg_0_0_0_0;
  wire selector_MUX_35_reg_1_0_0_0;
  wire selector_MUX_46_reg_2_0_0_0;
  wire selector_MUX_48_reg_3_0_0_0;
  wire selector_MUX_49_reg_4_0_0_0;
  wire selector_MUX_50_reg_5_0_0_0;
  wire selector_MUX_51_reg_6_0_0_0;
  wire selector_MUX_52_reg_7_0_0_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_10;
  wire wrenable_reg_11;
  wire wrenable_reg_12;
  wire wrenable_reg_13;
  wire wrenable_reg_14;
  wire wrenable_reg_15;
  wire wrenable_reg_16;
  wire wrenable_reg_17;
  wire wrenable_reg_18;
  wire wrenable_reg_19;
  wire wrenable_reg_2;
  wire wrenable_reg_20;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z10moving_maxPiS_ Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562(selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562),
    .selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737(selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737),
    .selector_MUX_34_reg_0_0_0_0(selector_MUX_34_reg_0_0_0_0),
    .selector_MUX_35_reg_1_0_0_0(selector_MUX_35_reg_1_0_0_0),
    .selector_MUX_46_reg_2_0_0_0(selector_MUX_46_reg_2_0_0_0),
    .selector_MUX_48_reg_3_0_0_0(selector_MUX_48_reg_3_0_0_0),
    .selector_MUX_49_reg_4_0_0_0(selector_MUX_49_reg_4_0_0_0),
    .selector_MUX_50_reg_5_0_0_0(selector_MUX_50_reg_5_0_0_0),
    .selector_MUX_51_reg_6_0_0_0(selector_MUX_51_reg_6_0_0_0),
    .selector_MUX_52_reg_7_0_0_0(selector_MUX_52_reg_7_0_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_15(wrenable_reg_15),
    .wrenable_reg_16(wrenable_reg_16),
    .wrenable_reg_17(wrenable_reg_17),
    .wrenable_reg_18(wrenable_reg_18),
    .wrenable_reg_19(wrenable_reg_19),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_20(wrenable_reg_20),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z10moving_maxPiS__428532_428574(OUT_CONDITION__Z10moving_maxPiS__428532_428574),
    .OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562(OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562),
    .OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737(OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z10moving_maxPiS_ Datapath_i (._in_address0(_in_address0),
    ._in_address1(_in_address1),
    ._in_ce0(_in_ce0),
    ._in_ce1(_in_ce1),
    ._out_address0(_out_address0),
    ._out_address1(_out_address1),
    ._out_ce0(_out_ce0),
    ._out_ce1(_out_ce1),
    ._out_we0(_out_we0),
    ._out_we1(_out_we1),
    ._out_d0(_out_d0),
    ._out_d1(_out_d1),
    .OUT_CONDITION__Z10moving_maxPiS__428532_428574(OUT_CONDITION__Z10moving_maxPiS__428532_428574),
    .OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562(OUT_UNBOUNDED__Z10moving_maxPiS__428532_428562),
    .OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737(OUT_UNBOUNDED__Z10moving_maxPiS__428532_428737),
    .clock(clock),
    .reset(reset),
    .in_port_in(in),
    .in_port_out(out),
    ._in_q0(_in_q0),
    ._in_q1(_in_q1),
    .selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562(selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428562),
    .selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737(selector_IN_UNBOUNDED__Z10moving_maxPiS__428532_428737),
    .selector_MUX_34_reg_0_0_0_0(selector_MUX_34_reg_0_0_0_0),
    .selector_MUX_35_reg_1_0_0_0(selector_MUX_35_reg_1_0_0_0),
    .selector_MUX_46_reg_2_0_0_0(selector_MUX_46_reg_2_0_0_0),
    .selector_MUX_48_reg_3_0_0_0(selector_MUX_48_reg_3_0_0_0),
    .selector_MUX_49_reg_4_0_0_0(selector_MUX_49_reg_4_0_0_0),
    .selector_MUX_50_reg_5_0_0_0(selector_MUX_50_reg_5_0_0_0),
    .selector_MUX_51_reg_6_0_0_0(selector_MUX_51_reg_6_0_0_0),
    .selector_MUX_52_reg_7_0_0_0(selector_MUX_52_reg_7_0_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_15(wrenable_reg_15),
    .wrenable_reg_16(wrenable_reg_16),
    .wrenable_reg_17(wrenable_reg_17),
    .wrenable_reg_18(wrenable_reg_18),
    .wrenable_reg_19(wrenable_reg_19),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_20(wrenable_reg_20),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9));
  flipflop_AR #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) done_delayed_REG (.out1(done_delayed_REG_signal_out),
    .clock(clock),
    .reset(reset),
    .in1(done_delayed_REG_signal_in));
  // io-signal post fix
  assign done_port = done_delayed_REG_signal_out;

endmodule

// Minimal interface for function: _Z10moving_maxPiS_
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z10moving_maxPiS_(clock,
  reset,
  start_port,
  in_q0,
  in_q1,
  done_port,
  in_address0,
  in_address1,
  in_ce0,
  in_ce1,
  out_address0,
  out_address1,
  out_ce0,
  out_ce1,
  out_we0,
  out_we1,
  out_d0,
  out_d1);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] in_q0;
  input [31:0] in_q1;
  // OUT
  output done_port;
  output [5:0] in_address0;
  output [5:0] in_address1;
  output in_ce0;
  output in_ce1;
  output [5:0] out_address0;
  output [5:0] out_address1;
  output out_ce0;
  output out_ce1;
  output out_we0;
  output out_we1;
  output [31:0] out_d0;
  output [31:0] out_d1;
  // Component and signal declarations
  
  __Z10moving_maxPiS_ __Z10moving_maxPiS__i0 (.done_port(done_port),
    ._in_address0(in_address0),
    ._in_address1(in_address1),
    ._in_ce0(in_ce0),
    ._in_ce1(in_ce1),
    ._out_address0(out_address0),
    ._out_address1(out_address1),
    ._out_ce0(out_ce0),
    ._out_ce1(out_ce1),
    ._out_we0(out_we0),
    ._out_we1(out_we1),
    ._out_d0(out_d0),
    ._out_d1(out_d1),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .in(32'b00000000000000000000000000000000),
    .out(32'b00000000000000000000000000000000),
    ._in_q0(in_q0),
    ._in_q1(in_q1));

endmodule


