// /*******************************************************************************
// Copyright (c) 2018, Xilinx, Inc.
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// 
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// 
// 
// 3. Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
// 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// *******************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// Description: This is a example of how to create an RTL Kernel.  The function
// of this module is to add two 32-bit values and produce a result.  The values
// are read from one AXI4 memory mapped master, processed and then written out.
//
// Data flow: axi_read_master->fifo[2]->adder->fifo->axi_write_master
///////////////////////////////////////////////////////////////////////////////

// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1 ns / 1 ps 

module krnl_vadd_2clk_rtl_int #( 
  parameter integer  C_S_AXI_CONTROL_DATA_WIDTH = 32,
  parameter integer  C_S_AXI_CONTROL_ADDR_WIDTH = 32,
  parameter integer  C_M_AXI_GMEM_ID_WIDTH = 1,
  parameter integer  C_M_AXI_GMEM_ADDR_WIDTH = 64,
  parameter integer  C_M_AXI_GMEM_DATA_WIDTH = 32
)
(
  // System signals
  input  wire  ap_clk,
  input  wire  ap_rst_n,
  input  wire  ap_clk_2,
  input  wire  ap_rst_n_2,

  // AXI4 master interface m0 
  output wire                                 m0_axi_gmem_AWVALID,
  input  wire                                 m0_axi_gmem_AWREADY,
  output wire [C_M_AXI_GMEM_ADDR_WIDTH-1:0]   m0_axi_gmem_AWADDR,
  output wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m0_axi_gmem_AWID,
  output wire [7:0]                           m0_axi_gmem_AWLEN,
  output wire [2:0]                           m0_axi_gmem_AWSIZE,
  // Tie-off AXI4 transaction options that are not being used.
  output wire [1:0]                           m0_axi_gmem_AWBURST,
  output wire [1:0]                           m0_axi_gmem_AWLOCK,
  output wire [3:0]                           m0_axi_gmem_AWCACHE,
  output wire [2:0]                           m0_axi_gmem_AWPROT,
  output wire [3:0]                           m0_axi_gmem_AWQOS,
  output wire [3:0]                           m0_axi_gmem_AWREGION,
  output wire                                 m0_axi_gmem_WVALID,
  input  wire                                 m0_axi_gmem_WREADY,
  output wire [C_M_AXI_GMEM_DATA_WIDTH-1:0]   m0_axi_gmem_WDATA,
  output wire [C_M_AXI_GMEM_DATA_WIDTH/8-1:0] m0_axi_gmem_WSTRB,
  output wire                                 m0_axi_gmem_WLAST,
  output wire                                 m0_axi_gmem_ARVALID,
  input  wire                                 m0_axi_gmem_ARREADY,
  output wire [C_M_AXI_GMEM_ADDR_WIDTH-1:0]   m0_axi_gmem_ARADDR,
  output wire [C_M_AXI_GMEM_ID_WIDTH-1:0]     m0_axi_gmem_ARID,
  output wire [7:0]                           m0_axi_gmem_ARLEN,
  output wire [2:0]                           m0_axi_gmem_ARSIZE,
  output wire [1:0]                           m0_axi_gmem_ARBURST,
  output wire [1:0]                           m0_axi_gmem_ARLOCK,
  output wire [3:0]                           m0_axi_gmem_ARCACHE,
  output wire [2:0]                           m0_axi_gmem_ARPROT,
  output wire [3:0]                           m0_axi_gmem_ARQOS,
  output wire [3:0]                           m0_axi_gmem_ARREGION,
  input  wire                                 m0_axi_gmem_RVALID,
  output wire                                 m0_axi_gmem_RREADY,
  input  wire [C_M_AXI_GMEM_DATA_WIDTH - 1:0] m0_axi_gmem_RDATA,
  input  wire                                 m0_axi_gmem_RLAST,
  input  wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m0_axi_gmem_RID,
  input  wire [1:0]                           m0_axi_gmem_RRESP,
  input  wire                                 m0_axi_gmem_BVALID,
  output wire                                 m0_axi_gmem_BREADY,
  input  wire [1:0]                           m0_axi_gmem_BRESP,
  input  wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m0_axi_gmem_BID,

  // AXI4 master interface m1 
  output wire                                 m1_axi_gmem_AWVALID,
  input  wire                                 m1_axi_gmem_AWREADY,
  output wire [C_M_AXI_GMEM_ADDR_WIDTH-1:0]   m1_axi_gmem_AWADDR,
  output wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m1_axi_gmem_AWID,
  output wire [7:0]                           m1_axi_gmem_AWLEN,
  output wire [2:0]                           m1_axi_gmem_AWSIZE,
  // Tie-off AXI4 transaction options that are not being used.
  output wire [1:0]                           m1_axi_gmem_AWBURST,
  output wire [1:0]                           m1_axi_gmem_AWLOCK,
  output wire [3:0]                           m1_axi_gmem_AWCACHE,
  output wire [2:0]                           m1_axi_gmem_AWPROT,
  output wire [3:0]                           m1_axi_gmem_AWQOS,
  output wire [3:0]                           m1_axi_gmem_AWREGION,
  output wire                                 m1_axi_gmem_WVALID,
  input  wire                                 m1_axi_gmem_WREADY,
  output wire [C_M_AXI_GMEM_DATA_WIDTH-1:0]   m1_axi_gmem_WDATA,
  output wire [C_M_AXI_GMEM_DATA_WIDTH/8-1:0] m1_axi_gmem_WSTRB,
  output wire                                 m1_axi_gmem_WLAST,
  output wire                                 m1_axi_gmem_ARVALID,
  input  wire                                 m1_axi_gmem_ARREADY,
  output wire [C_M_AXI_GMEM_ADDR_WIDTH-1:0]   m1_axi_gmem_ARADDR,
  output wire [C_M_AXI_GMEM_ID_WIDTH-1:0]     m1_axi_gmem_ARID,
  output wire [7:0]                           m1_axi_gmem_ARLEN,
  output wire [2:0]                           m1_axi_gmem_ARSIZE,
  output wire [1:0]                           m1_axi_gmem_ARBURST,
  output wire [1:0]                           m1_axi_gmem_ARLOCK,
  output wire [3:0]                           m1_axi_gmem_ARCACHE,
  output wire [2:0]                           m1_axi_gmem_ARPROT,
  output wire [3:0]                           m1_axi_gmem_ARQOS,
  output wire [3:0]                           m1_axi_gmem_ARREGION,
  input  wire                                 m1_axi_gmem_RVALID,
  output wire                                 m1_axi_gmem_RREADY,
  input  wire [C_M_AXI_GMEM_DATA_WIDTH - 1:0] m1_axi_gmem_RDATA,
  input  wire                                 m1_axi_gmem_RLAST,
  input  wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m1_axi_gmem_RID,
  input  wire [1:0]                           m1_axi_gmem_RRESP,
  input  wire                                 m1_axi_gmem_BVALID,
  output wire                                 m1_axi_gmem_BREADY,
  input  wire [1:0]                           m1_axi_gmem_BRESP,
  input  wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m1_axi_gmem_BID,

  // AXI4-Lite slave interface
  input  wire                                    s_axi_control_AWVALID,
  output wire                                    s_axi_control_AWREADY,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_AWADDR,
  input  wire                                    s_axi_control_WVALID,
  output wire                                    s_axi_control_WREADY,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_WDATA,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_WSTRB,
  input  wire                                    s_axi_control_ARVALID,
  output wire                                    s_axi_control_ARREADY,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_ARADDR,
  output wire                                    s_axi_control_RVALID,
  input  wire                                    s_axi_control_RREADY,
  output wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_RDATA,
  output wire [1:0]                              s_axi_control_RRESP,
  output wire                                    s_axi_control_BVALID,
  input  wire                                    s_axi_control_BREADY,
  output wire [1:0]                              s_axi_control_BRESP 
);
///////////////////////////////////////////////////////////////////////////////
// Local Parameters (constants)
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_NUM_READ_CHANNELS  = 2;
localparam integer LP_LENGTH_WIDTH       = 32;
localparam integer LP_DW_BYTES           = C_M_AXI_GMEM_DATA_WIDTH/8;
localparam integer LP_AXI_BURST_LEN      = 4096/LP_DW_BYTES < 256 ? 4096/LP_DW_BYTES : 256;
localparam integer LP_LOG_BURST_LEN      = $clog2(LP_AXI_BURST_LEN);
localparam integer LP_RD_MAX_OUTSTANDING = 3;
localparam integer LP_RD_FIFO_DEPTH      = LP_AXI_BURST_LEN*(LP_RD_MAX_OUTSTANDING + 1);
localparam integer LP_WR_FIFO_DEPTH      = LP_AXI_BURST_LEN;


///////////////////////////////////////////////////////////////////////////////
// Variables
///////////////////////////////////////////////////////////////////////////////
logic areset = 1'b0;  
logic areset_n = 1'b1;  
logic areset_2 = 1'b0;  
logic ap_start;
logic ap_start_pulse = 1'b0;
logic ap_start_pulse_r0 = 1'b0;
logic ap_start_pulse_P0 = 1'b0;
logic ap_start_pulse_P1 = 1'b0;
logic ap_start_r;
logic ap_ready;
logic ap_done_to_XRT;
logic ap_continue;
logic ap_idle = 1'b1;
logic [C_M_AXI_GMEM_ADDR_WIDTH-1:0] a;
logic [C_M_AXI_GMEM_ADDR_WIDTH-1:0] b;
logic [C_M_AXI_GMEM_ADDR_WIDTH-1:0] c;
logic [C_M_AXI_GMEM_ADDR_WIDTH-1:0] d;
logic [LP_LENGTH_WIDTH-1:0]         length_r;
logic [31:0]         pipeline_num;

reg [C_M_AXI_GMEM_ADDR_WIDTH-1:0] reg_a;
reg [C_M_AXI_GMEM_ADDR_WIDTH-1:0] reg_b;
reg [C_M_AXI_GMEM_ADDR_WIDTH-1:0] reg_c;
reg [C_M_AXI_GMEM_ADDR_WIDTH-1:0] reg_d;
reg [LP_LENGTH_WIDTH-1:0]         reg_length_r;
reg [31:0]         reg_pipeline_num = 32'h1;


reg    int_ready = 1'b0;

logic ap_rd_done_P0;
logic ap_rd_done_P1;
logic ap_rd_done_coalased = 1'b0;
logic ap_wr_done_P0;
logic ap_wr_done_P1;
logic ap_wr_done_coalased = 1'b0;
logic [LP_NUM_READ_CHANNELS-1:0] rd_tvalid;
logic [LP_NUM_READ_CHANNELS-1:0] rd_tready_n; 
logic [LP_NUM_READ_CHANNELS-1:0] [C_M_AXI_GMEM_DATA_WIDTH-1:0] rd_tdata;
logic [LP_NUM_READ_CHANNELS-1:0] ctrl_rd_fifo_prog_full;
logic [LP_NUM_READ_CHANNELS-1:0] rd_fifo_tvalid_n;
logic [LP_NUM_READ_CHANNELS-1:0] rd_fifo_tready; 
logic [LP_NUM_READ_CHANNELS-1:0] [C_M_AXI_GMEM_DATA_WIDTH-1:0] rd_fifo_tdata;

logic                               adder_tvalid;
logic                               adder_tready_n; 
logic [C_M_AXI_GMEM_DATA_WIDTH-1:0] adder_tdata;
logic                               wr_fifo_tvalid_n;
logic                               wr_fifo_tready; 
logic [C_M_AXI_GMEM_DATA_WIDTH-1:0] wr_fifo_tdata;


///////////////////////////////////////////////////////////////////////////////
// RTL Logic 
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal for better timing.
always @(posedge ap_clk) begin 
  areset <= ~ap_rst_n; 
  areset_n <= ap_rst_n; 
end

// Register and invert reset signal for better timing.
always @(posedge ap_clk_2) begin 
  areset_2 <= ~ap_rst_n_2; 
end


// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin 
  begin 
    ap_start_r <= ap_start;
  end
end

// _SRAI Assumes pipeline_num is one hot encoded

// _SRAI followingn is only to test parallel pipline paths - ie, since the donce gets return with an OR condition, it
// assmes only one PIPE is actibe it the vector pipeline_num is onehot
assign  ap_done_to_XRT = reg_pipeline_num[31] ? ap_wr_done_coalased : ap_start_pulse_r0;

// ap_idle is asserted when done is assert, it is de-asserted when ap_start_pulse 
// is asserted

always @(posedge ap_clk) begin 
  if (areset) begin 
    ap_idle <= 1'b1;
    ap_start_pulse <=  1'b0;
    ap_start_pulse_r0 <= 1'b0; 
    ap_start_pulse_P0 <= 1'b0; 
    ap_start_pulse_P1 <= 1'b0; 
    ap_rd_done_coalased <= 1'b0; 
    ap_wr_done_coalased <= 1'b0;
  end
  else begin 
    ap_idle <= int_ready; 
    ap_start_pulse <= (~ap_start & ap_start_r); //__SRAI Pulse on  the trailing edge of ap_start
    ap_start_pulse_P0 <= ap_start_pulse & pipeline_num[0];
    ap_start_pulse_P1 <= ap_start_pulse & pipeline_num[1];
    ap_start_pulse_r0 <= ap_start_pulse; 
    ap_rd_done_coalased <= ((ap_rd_done_P0 & reg_pipeline_num[0]) | (ap_rd_done_P1 & reg_pipeline_num[1])); // _SRAI assumes vector pipeline_num is One hot encoded
    ap_wr_done_coalased <= ((ap_wr_done_P0 & reg_pipeline_num[0]) | (ap_wr_done_P1 & reg_pipeline_num[1])); // _SRAI assumes vector pipeline_num is One hot encoded
  end
end

always @(posedge ap_clk) begin 
  if (areset) begin 
    int_ready <= 1'b1;
  end else if (ap_start_pulse) begin
    int_ready <= 1'b0;
    reg_a <= a;
    reg_b <= b;
    reg_c <= c;
    reg_d <= d;
    reg_length_r <=  length_r;
    reg_pipeline_num <= pipeline_num;
  end else if (ap_wr_done_coalased) begin
    int_ready <= 1'b1;
end
end

assign ap_ready = int_ready; 

ila_ctrl_logic U_ila_ctrl_logic (
	.clk(ap_clk), // input wire clk
	.probe0({reg_length_r[7:0], reg_pipeline_num[31], ap_done_to_XRT, ap_idle, ap_continue, ap_ready, ap_rd_done_coalased, ap_wr_done_coalased, ap_start_pulse}) // input wire [15:0] probe0
);


// AXI4-Lite slave
krnl_vadd_2clk_rtl_control_s_axi #(
  .C_S_AXI_ADDR_WIDTH( C_S_AXI_CONTROL_ADDR_WIDTH ),
  .C_S_AXI_DATA_WIDTH( C_S_AXI_CONTROL_DATA_WIDTH )
) 
inst_krnl_vadd_control_s_axi (
  .AWVALID   ( s_axi_control_AWVALID      ) ,
  .AWREADY   ( s_axi_control_AWREADY      ) ,
  .AWADDR    ( s_axi_control_AWADDR       ) ,
  .WVALID    ( s_axi_control_WVALID       ) ,
  .WREADY    ( s_axi_control_WREADY       ) ,
  .WDATA     ( s_axi_control_WDATA        ) ,
  .WSTRB     ( s_axi_control_WSTRB        ) ,
  .ARVALID   ( s_axi_control_ARVALID      ) ,
  .ARREADY   ( s_axi_control_ARREADY      ) ,
  .ARADDR    ( s_axi_control_ARADDR       ) ,
  .RVALID    ( s_axi_control_RVALID       ) ,
  .RREADY    ( s_axi_control_RREADY       ) ,
  .RDATA     ( s_axi_control_RDATA        ) ,
  .RRESP     ( s_axi_control_RRESP        ) ,
  .BVALID    ( s_axi_control_BVALID       ) ,
  .BREADY    ( s_axi_control_BREADY       ) ,
  .BRESP     ( s_axi_control_BRESP        ) ,
  .ACLK      ( ap_clk                        ) ,
  .ARESET    ( areset                        ) ,
  .ACLK_EN   ( 1'b1                          ) ,
  .ap_start  ( ap_start                      ) ,
  .interrupt (                               ) , // Not used
  .ap_ready  ( ap_ready                      ) ,
  .ap_done   ( ap_done_to_XRT                ) , // Pulsed on the Trailing edge of Start for immedeate done - Which works fine until the last buffer which will require host transfer only after wr_done
  .ap_continue(ap_continue                   ) ,
  .ap_idle   ( ap_idle                       ) ,
  .a         ( a[0+:C_M_AXI_GMEM_ADDR_WIDTH] ) ,
  .b         ( b[0+:C_M_AXI_GMEM_ADDR_WIDTH] ) ,
  .c         ( c[0+:C_M_AXI_GMEM_ADDR_WIDTH] ) ,
  .d         ( d[0+:C_M_AXI_GMEM_ADDR_WIDTH] ) ,
  .length_r  ( length_r[0+:LP_LENGTH_WIDTH]  ) ,
  .pipeline_num( pipeline_num                )
);

krnl_vadd_2clk_proc_pipeline #( 
  .C_S_AXI_CONTROL_DATA_WIDTH(C_S_AXI_CONTROL_DATA_WIDTH),
  .C_S_AXI_CONTROL_ADDR_WIDTH(C_S_AXI_CONTROL_ADDR_WIDTH),
  .C_M_AXI_GMEM_ID_WIDTH(C_M_AXI_GMEM_ID_WIDTH),
  .C_M_AXI_GMEM_ADDR_WIDTH(C_M_AXI_GMEM_ADDR_WIDTH),
  .C_M_AXI_GMEM_DATA_WIDTH(C_M_AXI_GMEM_DATA_WIDTH)
) U_krnl_vadd_2clk_proc_pipeline_P0 (
  // System signals
  .ap_clk(ap_clk),
  .areset(areset),
  .ap_clk_2(ap_clk_2),
  .areset_2(areset_2),
  .ap_start_pulse(ap_start_pulse_P0),
  .ap_wr_done(ap_wr_done_P0),
  .ap_rd_done(ap_rd_done_P0),
  .a(reg_a),
  .b(reg_b),
  .c(reg_c),
  .length_r(reg_length_r),

  // AXI4 master interface 
  .m_axi_gmem_AWVALID(m0_axi_gmem_AWVALID),
  .m_axi_gmem_AWREADY(m0_axi_gmem_AWREADY),
  .m_axi_gmem_AWADDR(m0_axi_gmem_AWADDR),
  .m_axi_gmem_AWID(m0_axi_gmem_AWID),
  .m_axi_gmem_AWLEN(m0_axi_gmem_AWLEN),
  .m_axi_gmem_AWSIZE(m0_axi_gmem_AWSIZE),
  .m_axi_gmem_AWBURST(m0_axi_gmem_AWBURST),
  .m_axi_gmem_AWLOCK(m0_axi_gmem_AWLOCK),
  .m_axi_gmem_AWCACHE(m0_axi_gmem_AWCACHE),
  .m_axi_gmem_AWPROT(m0_axi_gmem_AWPROT),
  .m_axi_gmem_AWQOS(m0_axi_gmem_AWQOS),
  .m_axi_gmem_AWREGION(m0_axi_gmem_AWREGION),
  .m_axi_gmem_WVALID(m0_axi_gmem_WVALID),
  .m_axi_gmem_WREADY(m0_axi_gmem_WREADY),
  .m_axi_gmem_WDATA(m0_axi_gmem_WDATA),
  .m_axi_gmem_WSTRB(m0_axi_gmem_WSTRB),
  .m_axi_gmem_WLAST(m0_axi_gmem_WLAST),
  .m_axi_gmem_ARVALID(m0_axi_gmem_ARVALID),
  .m_axi_gmem_ARREADY(m0_axi_gmem_ARREADY),
  .m_axi_gmem_ARADDR(m0_axi_gmem_ARADDR),
  .m_axi_gmem_ARID(m0_axi_gmem_ARID),
  .m_axi_gmem_ARLEN(m0_axi_gmem_ARLEN),
  .m_axi_gmem_ARSIZE(m0_axi_gmem_ARSIZE),
  .m_axi_gmem_ARBURST(m0_axi_gmem_ARBURST),
  .m_axi_gmem_ARLOCK(m0_axi_gmem_ARLOCK),
  .m_axi_gmem_ARCACHE(m0_axi_gmem_ARCACHE),
  .m_axi_gmem_ARPROT(m0_axi_gmem_ARPROT),
  .m_axi_gmem_ARQOS(m0_axi_gmem_ARQOS),
  .m_axi_gmem_ARREGION(m0_axi_gmem_ARREGION),
  .m_axi_gmem_RVALID(m0_axi_gmem_RVALID),
  .m_axi_gmem_RREADY(m0_axi_gmem_RREADY),
  .m_axi_gmem_RDATA(m0_axi_gmem_RDATA),
  .m_axi_gmem_RLAST(m0_axi_gmem_RLAST),
  .m_axi_gmem_RID(m0_axi_gmem_RID),
  .m_axi_gmem_RRESP(m0_axi_gmem_RRESP),
  .m_axi_gmem_BVALID(m0_axi_gmem_BVALID),
  .m_axi_gmem_BREADY(m0_axi_gmem_BREADY),
  .m_axi_gmem_BRESP(m0_axi_gmem_BRESP),
  .m_axi_gmem_BID(m0_axi_gmem_BID)
);

krnl_vadd_2clk_proc_pipeline #( 
  .C_S_AXI_CONTROL_DATA_WIDTH(C_S_AXI_CONTROL_DATA_WIDTH),
  .C_S_AXI_CONTROL_ADDR_WIDTH(C_S_AXI_CONTROL_ADDR_WIDTH),
  .C_M_AXI_GMEM_ID_WIDTH(C_M_AXI_GMEM_ID_WIDTH),
  .C_M_AXI_GMEM_ADDR_WIDTH(C_M_AXI_GMEM_ADDR_WIDTH),
  .C_M_AXI_GMEM_DATA_WIDTH(C_M_AXI_GMEM_DATA_WIDTH)
) U_krnl_vadd_2clk_proc_pipeline_P1 (
  // System signals
  .ap_clk(ap_clk),
  .areset(areset),
  .ap_clk_2(ap_clk_2),
  .areset_2(areset_2),
  .ap_start_pulse(ap_start_pulse_P1),
  .ap_wr_done(ap_wr_done_P1),
  .ap_rd_done(ap_rd_done_P1),
  .a(reg_a),
  .b(reg_b),
  .c(reg_d),
  .length_r(reg_length_r),

  // AXI4 master interface 
  .m_axi_gmem_AWVALID(m1_axi_gmem_AWVALID),
  .m_axi_gmem_AWREADY(m1_axi_gmem_AWREADY),
  .m_axi_gmem_AWADDR(m1_axi_gmem_AWADDR),
  .m_axi_gmem_AWID(m1_axi_gmem_AWID),
  .m_axi_gmem_AWLEN(m1_axi_gmem_AWLEN),
  .m_axi_gmem_AWSIZE(m1_axi_gmem_AWSIZE),
  .m_axi_gmem_AWBURST(m1_axi_gmem_AWBURST),
  .m_axi_gmem_AWLOCK(m1_axi_gmem_AWLOCK),
  .m_axi_gmem_AWCACHE(m1_axi_gmem_AWCACHE),
  .m_axi_gmem_AWPROT(m1_axi_gmem_AWPROT),
  .m_axi_gmem_AWQOS(m1_axi_gmem_AWQOS),
  .m_axi_gmem_AWREGION(m1_axi_gmem_AWREGION),
  .m_axi_gmem_WVALID(m1_axi_gmem_WVALID),
  .m_axi_gmem_WREADY(m1_axi_gmem_WREADY),
  .m_axi_gmem_WDATA(m1_axi_gmem_WDATA),
  .m_axi_gmem_WSTRB(m1_axi_gmem_WSTRB),
  .m_axi_gmem_WLAST(m1_axi_gmem_WLAST),
  .m_axi_gmem_ARVALID(m1_axi_gmem_ARVALID),
  .m_axi_gmem_ARREADY(m1_axi_gmem_ARREADY),
  .m_axi_gmem_ARADDR(m1_axi_gmem_ARADDR),
  .m_axi_gmem_ARID(m1_axi_gmem_ARID),
  .m_axi_gmem_ARLEN(m1_axi_gmem_ARLEN),
  .m_axi_gmem_ARSIZE(m1_axi_gmem_ARSIZE),
  .m_axi_gmem_ARBURST(m1_axi_gmem_ARBURST),
  .m_axi_gmem_ARLOCK(m1_axi_gmem_ARLOCK),
  .m_axi_gmem_ARCACHE(m1_axi_gmem_ARCACHE),
  .m_axi_gmem_ARPROT(m1_axi_gmem_ARPROT),
  .m_axi_gmem_ARQOS(m1_axi_gmem_ARQOS),
  .m_axi_gmem_ARREGION(m1_axi_gmem_ARREGION),
  .m_axi_gmem_RVALID(m1_axi_gmem_RVALID),
  .m_axi_gmem_RREADY(m1_axi_gmem_RREADY),
  .m_axi_gmem_RDATA(m1_axi_gmem_RDATA),
  .m_axi_gmem_RLAST(m1_axi_gmem_RLAST),
  .m_axi_gmem_RID(m1_axi_gmem_RID),
  .m_axi_gmem_RRESP(m1_axi_gmem_RRESP),
  .m_axi_gmem_BVALID(m1_axi_gmem_BVALID),
  .m_axi_gmem_BREADY(m1_axi_gmem_BREADY),
  .m_axi_gmem_BRESP(m1_axi_gmem_BRESP),
  .m_axi_gmem_BID(m1_axi_gmem_BID)
);

endmodule : krnl_vadd_2clk_rtl_int

`default_nettype wire
