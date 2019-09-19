// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Fri Aug  2 14:18:51 2019
// Host        : mcalveo running 64-bit CentOS Linux release 7.4.1708 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /home/sanjayr/projects/U250/RTL_KERNEL_STREAMING_MSFT/t4_RTL_KER_immedeate_DONE_AXIL_FIFO_SW_START_STOP_SYS_ILA/test1/rtl_vadd_2clks/src/ip/bd/bram_sys/ip/bram_sys_krnl_wr_axi_lite_cmd_0/bram_sys_krnl_wr_axi_lite_cmd_0_stub.v
// Design      : bram_sys_krnl_wr_axi_lite_cmd_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcu250-figd2104-2L-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "krnl_wr_axi_lite_cmd_fifo_ctrl,Vivado 2019.1" *)
module bram_sys_krnl_wr_axi_lite_cmd_0(ACLK, ARESETN, WVALID, WREADY, BREADY, BRESP, BVALID)
/* synthesis syn_black_box black_box_pad_pin="ACLK,ARESETN,WVALID,WREADY,BREADY,BRESP[1:0],BVALID" */;
  input ACLK;
  input ARESETN;
  input WVALID;
  input WREADY;
  output BREADY;
  output [1:0]BRESP;
  output BVALID;
endmodule
