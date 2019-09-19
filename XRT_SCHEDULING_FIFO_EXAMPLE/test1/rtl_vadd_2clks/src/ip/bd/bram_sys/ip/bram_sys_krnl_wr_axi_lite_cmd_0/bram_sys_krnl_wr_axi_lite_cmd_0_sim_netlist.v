// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Fri Aug  2 14:18:51 2019
// Host        : mcalveo running 64-bit CentOS Linux release 7.4.1708 (Core)
// Command     : write_verilog -force -mode funcsim
//               /home/sanjayr/projects/U250/RTL_KERNEL_STREAMING_MSFT/t4_RTL_KER_immedeate_DONE_AXIL_FIFO_SW_START_STOP_SYS_ILA/test1/rtl_vadd_2clks/src/ip/bd/bram_sys/ip/bram_sys_krnl_wr_axi_lite_cmd_0/bram_sys_krnl_wr_axi_lite_cmd_0_sim_netlist.v
// Design      : bram_sys_krnl_wr_axi_lite_cmd_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcu250-figd2104-2L-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bram_sys_krnl_wr_axi_lite_cmd_0,krnl_wr_axi_lite_cmd_fifo_ctrl,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "krnl_wr_axi_lite_cmd_fifo_ctrl,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module bram_sys_krnl_wr_axi_lite_cmd_0
   (ACLK,
    ARESETN,
    WVALID,
    WREADY,
    BREADY,
    BRESP,
    BVALID);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ACLK, ASSOCIATED_RESET ARESETN, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN bram_sys_s_axi_aclk, INSERT_VIP 0" *) input ACLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input ARESETN;
  input WVALID;
  input WREADY;
  output BREADY;
  output [1:0]BRESP;
  output BVALID;

  wire \<const0> ;
  wire \<const1> ;
  wire ACLK;
  wire ARESETN;
  wire BVALID;
  wire WREADY;
  wire WVALID;

  assign BREADY = \<const1> ;
  assign BRESP[1] = \<const0> ;
  assign BRESP[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl inst
       (.ACLK(ACLK),
        .ARESETN(ARESETN),
        .BVALID(BVALID),
        .WREADY(WREADY),
        .WVALID(WVALID));
endmodule

(* ORIG_REF_NAME = "krnl_wr_axi_lite_cmd_fifo_ctrl" *) 
module bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl
   (BVALID,
    ACLK,
    ARESETN,
    WVALID,
    WREADY);
  output BVALID;
  input ACLK;
  input ARESETN;
  input WVALID;
  input WREADY;

  wire ACLK;
  wire ARESETN;
  wire BVALID;
  wire WREADY;
  wire WVALID;
  wire p_0_in;
  wire r0_BVALID;
  wire r0_BVALID0;
  wire r1_BVALID;
  wire r2_BVALID;

  LUT2 #(
    .INIT(4'h2)) 
    BVALID_INST_0
       (.I0(r1_BVALID),
        .I1(r2_BVALID),
        .O(BVALID));
  LUT1 #(
    .INIT(2'h1)) 
    r0_BVALID_i_1
       (.I0(ARESETN),
        .O(p_0_in));
  LUT2 #(
    .INIT(4'h8)) 
    r0_BVALID_i_2
       (.I0(WVALID),
        .I1(WREADY),
        .O(r0_BVALID0));
  FDRE #(
    .INIT(1'b0)) 
    r0_BVALID_reg
       (.C(ACLK),
        .CE(1'b1),
        .D(r0_BVALID0),
        .Q(r0_BVALID),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    r1_BVALID_reg
       (.C(ACLK),
        .CE(1'b1),
        .D(r0_BVALID),
        .Q(r1_BVALID),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    r2_BVALID_reg
       (.C(ACLK),
        .CE(1'b1),
        .D(r1_BVALID),
        .Q(r2_BVALID),
        .R(p_0_in));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
