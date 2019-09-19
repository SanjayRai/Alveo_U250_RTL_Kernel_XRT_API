
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1 ns / 1 ps 

module krnl_vadd_2clk_proc_pipeline #( 
  parameter integer  C_S_AXI_CONTROL_DATA_WIDTH = 32,
  parameter integer  C_S_AXI_CONTROL_ADDR_WIDTH = 32,
  parameter integer  C_M_AXI_GMEM_ID_WIDTH = 1,
  parameter integer  C_M_AXI_GMEM_ADDR_WIDTH = 64,
  parameter integer  C_M_AXI_GMEM_DATA_WIDTH = 32
)
(
  // System signals
  input  wire  ap_clk,
  input  wire areset,
  input  wire  ap_clk_2,
  input  wire areset_2,
  input wire  ap_start_pulse,
  output wire  ap_wr_done,
  output wire  ap_rd_done,
  input wire  [C_M_AXI_GMEM_ADDR_WIDTH-1:0] a,
  input wire  [C_M_AXI_GMEM_ADDR_WIDTH-1:0] b,
  input wire  [C_M_AXI_GMEM_ADDR_WIDTH-1:0] c,
  input wire  [LP_LENGTH_WIDTH-1:0]         length_r,

  // AXI4 master interface 
  output wire                                 m_axi_gmem_AWVALID,
  input  wire                                 m_axi_gmem_AWREADY,
  output wire [C_M_AXI_GMEM_ADDR_WIDTH-1:0]   m_axi_gmem_AWADDR,
  output wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m_axi_gmem_AWID,
  output wire [7:0]                           m_axi_gmem_AWLEN,
  output wire [2:0]                           m_axi_gmem_AWSIZE,
  // Tie-off AXI4 transaction options that are not being used.
  output wire [1:0]                           m_axi_gmem_AWBURST,
  output wire [1:0]                           m_axi_gmem_AWLOCK,
  output wire [3:0]                           m_axi_gmem_AWCACHE,
  output wire [2:0]                           m_axi_gmem_AWPROT,
  output wire [3:0]                           m_axi_gmem_AWQOS,
  output wire [3:0]                           m_axi_gmem_AWREGION,
  output wire                                 m_axi_gmem_WVALID,
  input  wire                                 m_axi_gmem_WREADY,
  output wire [C_M_AXI_GMEM_DATA_WIDTH-1:0]   m_axi_gmem_WDATA,
  output wire [C_M_AXI_GMEM_DATA_WIDTH/8-1:0] m_axi_gmem_WSTRB,
  output wire                                 m_axi_gmem_WLAST,
  output wire                                 m_axi_gmem_ARVALID,
  input  wire                                 m_axi_gmem_ARREADY,
  output wire [C_M_AXI_GMEM_ADDR_WIDTH-1:0]   m_axi_gmem_ARADDR,
  output wire [C_M_AXI_GMEM_ID_WIDTH-1:0]     m_axi_gmem_ARID,
  output wire [7:0]                           m_axi_gmem_ARLEN,
  output wire [2:0]                           m_axi_gmem_ARSIZE,
  output wire [1:0]                           m_axi_gmem_ARBURST,
  output wire [1:0]                           m_axi_gmem_ARLOCK,
  output wire [3:0]                           m_axi_gmem_ARCACHE,
  output wire [2:0]                           m_axi_gmem_ARPROT,
  output wire [3:0]                           m_axi_gmem_ARQOS,
  output wire [3:0]                           m_axi_gmem_ARREGION,
  input  wire                                 m_axi_gmem_RVALID,
  output wire                                 m_axi_gmem_RREADY,
  input  wire [C_M_AXI_GMEM_DATA_WIDTH - 1:0] m_axi_gmem_RDATA,
  input  wire                                 m_axi_gmem_RLAST,
  input  wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m_axi_gmem_RID,
  input  wire [1:0]                           m_axi_gmem_RRESP,
  input  wire                                 m_axi_gmem_BVALID,
  output wire                                 m_axi_gmem_BREADY,
  input  wire [1:0]                           m_axi_gmem_BRESP,
  input  wire [C_M_AXI_GMEM_ID_WIDTH - 1:0]   m_axi_gmem_BID
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

// -------------------------------------------------------
// -------------------------------------------------------
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
// Tie-off unused AXI protocol features
assign m_axi_gmem_AWID     = {C_M_AXI_GMEM_ID_WIDTH{1'b0}};
assign m_axi_gmem_AWBURST  = 2'b01;
assign m_axi_gmem_AWLOCK   = 2'b00;
assign m_axi_gmem_AWCACHE  = 4'b0011;
assign m_axi_gmem_AWPROT   = 3'b000;
assign m_axi_gmem_AWQOS    = 4'b0000;
assign m_axi_gmem_AWREGION = 4'b0000;
assign m_axi_gmem_ARBURST  = 2'b01;
assign m_axi_gmem_ARLOCK   = 2'b00;
assign m_axi_gmem_ARCACHE  = 4'b0011;
assign m_axi_gmem_ARPROT   = 3'b000;
assign m_axi_gmem_ARQOS    = 4'b0000;
assign m_axi_gmem_ARREGION = 4'b0000;

// AXI4 Read Master
krnl_vadd_2clk_rtl_axi_read_master #( 
  .C_ADDR_WIDTH       ( C_M_AXI_GMEM_ADDR_WIDTH ) ,
  .C_DATA_WIDTH       ( C_M_AXI_GMEM_DATA_WIDTH ) ,
  .C_ID_WIDTH         ( C_M_AXI_GMEM_ID_WIDTH   ) ,
  .C_NUM_CHANNELS     ( LP_NUM_READ_CHANNELS    ) ,
  .C_LENGTH_WIDTH     ( LP_LENGTH_WIDTH         ) ,
  .C_BURST_LEN        ( LP_AXI_BURST_LEN        ) ,
  .C_LOG_BURST_LEN    ( LP_LOG_BURST_LEN        ) ,
  .C_MAX_OUTSTANDING  ( LP_RD_MAX_OUTSTANDING   )
)
inst_axi_read_master( 
  .aclk           ( ap_clk                 ) ,
  .areset         ( areset                 ) ,

  .ctrl_start     ( ap_start_pulse         ) ,
  .ctrl_done      ( ap_rd_done              ) ,
  .ctrl_offset    ( {b,a}                  ) ,
  .ctrl_length    ( length_r               ) ,
  .ctrl_prog_full ( ctrl_rd_fifo_prog_full ) ,

  .arvalid        ( m_axi_gmem_ARVALID     ) ,
  .arready        ( m_axi_gmem_ARREADY     ) ,
  .araddr         ( m_axi_gmem_ARADDR      ) ,
  .arid           ( m_axi_gmem_ARID        ) ,
  .arlen          ( m_axi_gmem_ARLEN       ) ,
  .arsize         ( m_axi_gmem_ARSIZE      ) ,
  .rvalid         ( m_axi_gmem_RVALID      ) ,
  .rready         ( m_axi_gmem_RREADY      ) ,
  .rdata          ( m_axi_gmem_RDATA       ) ,
  .rlast          ( m_axi_gmem_RLAST       ) ,
  .rid            ( m_axi_gmem_RID         ) ,
  .rresp          ( m_axi_gmem_RRESP       ) ,

  .m_tvalid       ( rd_tvalid              ) ,
  .m_tready       ( ~rd_tready_n           ) ,
  .m_tdata        ( rd_tdata               ) 
);

// xpm_fifo_async: Asynchronous FIFO
// Xilinx Parameterized Macro, Version 2016.4
xpm_fifo_async # (
  .FIFO_MEMORY_TYPE          ("auto"),           //string; "auto", "block", "distributed", or "ultra";
  .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
  .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
  .FIFO_WRITE_DEPTH          (LP_RD_FIFO_DEPTH),   //positive integer
  .WRITE_DATA_WIDTH          (C_M_AXI_GMEM_DATA_WIDTH),        //positive integer
  .WR_DATA_COUNT_WIDTH       ($clog2(LP_RD_FIFO_DEPTH)+1),       //positive integer, Not used
  .PROG_FULL_THRESH          (LP_AXI_BURST_LEN-2),               //positive integer
  .FULL_RESET_VALUE          (1),                //positive integer; 0 or 1
  .READ_MODE                 ("fwft"),            //string; "std" or "fwft";
  .FIFO_READ_LATENCY         (1),                //positive integer;
  .READ_DATA_WIDTH           (C_M_AXI_GMEM_DATA_WIDTH),               //positive integer
  .RD_DATA_COUNT_WIDTH       ($clog2(LP_RD_FIFO_DEPTH)+1),               //positive integer, not used
  .PROG_EMPTY_THRESH         (10),               //positive integer, not used 
  .DOUT_RESET_VALUE          ("0"),              //string, don't care
  .CDC_SYNC_STAGES           (3),                //positive integer
  .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;

) inst_rd_xpm_fifo_async[LP_NUM_READ_CHANNELS-1:0] (
  .rst           ( areset           ) ,
  .wr_clk        ( ap_clk           ) ,
  .wr_en         ( rd_tvalid        ) ,
  .din           ( rd_tdata         ) ,
  .full          ( rd_tready_n      ) ,
  .overflow      (                  ) ,
  .wr_rst_busy   (                  ) ,
  .rd_clk        ( ap_clk_2         ) ,
  .rd_en         ( rd_fifo_tready   ) ,
  .dout          ( rd_fifo_tdata    ) ,
  .empty         ( rd_fifo_tvalid_n ) ,
  .underflow     (                  ) ,
  .rd_rst_busy   (                  ) ,
  .prog_full     ( ctrl_rd_fifo_prog_full) ,
  .wr_data_count (                  ) ,
  .prog_empty    (                  ) ,
  .rd_data_count (                  ) ,
  .sleep         ( 1'b0             ) ,
  .injectsbiterr ( 1'b0             ) ,
  .injectdbiterr ( 1'b0             ) ,
  .sbiterr       (                  ) ,
  .dbiterr       (                  ) 
);

// Combinatorial Adder
krnl_vadd_2clk_rtl_adder #( 
  .C_DATA_WIDTH   ( C_M_AXI_GMEM_DATA_WIDTH ) ,
  .C_NUM_CHANNELS ( LP_NUM_READ_CHANNELS    ) 
)
inst_adder ( 
  .aclk     ( ap_clk_2          ) ,
  .areset   ( areset_2          ) ,

  .s_tvalid ( ~rd_fifo_tvalid_n ) ,
  .s_tready ( rd_fifo_tready    ) ,
  .s_tdata  ( rd_fifo_tdata     ) ,

  .m_tvalid ( adder_tvalid      ) ,
  .m_tready ( ~adder_tready_n   ) ,
  .m_tdata  ( adder_tdata       ) 
);

// xpm_fifo_async: Asynchronous FIFO
// Xilinx Parameterized Macro, Version 2016.4
xpm_fifo_async # (
  .FIFO_MEMORY_TYPE          ("auto"),           //string; "auto", "block", "distributed", or "ultra";
  .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
  .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
  .FIFO_WRITE_DEPTH          (LP_WR_FIFO_DEPTH),   //positive integer
  .WRITE_DATA_WIDTH          (C_M_AXI_GMEM_DATA_WIDTH),               //positive integer
  .WR_DATA_COUNT_WIDTH       ($clog2(LP_WR_FIFO_DEPTH)),               //positive integer, Not used
  .PROG_FULL_THRESH          (10),               //positive integer, Not used 
  .FULL_RESET_VALUE          (1),                //positive integer; 0 or 1
  .READ_MODE                 ("fwft"),            //string; "std" or "fwft";
  .FIFO_READ_LATENCY         (1),                //positive integer;
  .READ_DATA_WIDTH           (C_M_AXI_GMEM_DATA_WIDTH),               //positive integer
  .RD_DATA_COUNT_WIDTH       ($clog2(LP_WR_FIFO_DEPTH)),               //positive integer, not used
  .PROG_EMPTY_THRESH         (10),               //positive integer, not used 
  .DOUT_RESET_VALUE          ("0"),              //string, don't care
  .CDC_SYNC_STAGES           (3),                //positive integer
  .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;

) inst_wr_xpm_fifo_async (
  .rst           ( areset_2         ) ,
  .wr_clk        ( ap_clk_2         ) ,
  .wr_en         ( adder_tvalid     ) ,
  .din           ( adder_tdata      ) ,
  .full          ( adder_tready_n   ) ,
  .overflow      (                  ) ,
  .wr_rst_busy   (                  ) ,
  .rd_clk        ( ap_clk           ) ,
  .rd_en         ( wr_fifo_tready   ) ,
  .dout          ( wr_fifo_tdata    ) ,
  .empty         ( wr_fifo_tvalid_n ) ,
  .underflow     (                  ) ,
  .rd_rst_busy   (                  ) ,
  .prog_full     (                  ) ,
  .wr_data_count (                  ) ,
  .prog_empty    (                  ) ,
  .rd_data_count (                  ) ,
  .sleep         ( 1'b0             ) ,
  .injectsbiterr ( 1'b0             ) ,
  .injectdbiterr ( 1'b0             ) ,
  .sbiterr       (                  ) ,
  .dbiterr       (                  ) 

);


// AXI4 Write Master
krnl_vadd_2clk_rtl_axi_write_master #( 
  .C_ADDR_WIDTH       ( C_M_AXI_GMEM_ADDR_WIDTH ) ,
  .C_DATA_WIDTH       ( C_M_AXI_GMEM_DATA_WIDTH ) ,
  .C_MAX_LENGTH_WIDTH ( LP_LENGTH_WIDTH     ) ,
  .C_BURST_LEN        ( LP_AXI_BURST_LEN        ) ,
  .C_LOG_BURST_LEN    ( LP_LOG_BURST_LEN        ) 
)
inst_axi_write_master ( 
  .aclk        ( ap_clk             ) ,
  .areset      ( areset             ) ,

  .ctrl_start  ( ap_start_pulse     ) ,
  .ctrl_offset ( c                  ) ,
  .ctrl_length ( length_r           ) ,
  .ctrl_done   ( ap_wr_done         ) ,

  .awvalid     ( m_axi_gmem_AWVALID ) ,
  .awready     ( m_axi_gmem_AWREADY ) ,
  .awaddr      ( m_axi_gmem_AWADDR  ) ,
  .awlen       ( m_axi_gmem_AWLEN   ) ,
  .awsize      ( m_axi_gmem_AWSIZE  ) ,

  .s_tvalid    ( ~wr_fifo_tvalid_n   ) ,
  .s_tready    ( wr_fifo_tready     ) ,
  .s_tdata     ( wr_fifo_tdata      ) ,

  .wvalid      ( m_axi_gmem_WVALID  ) ,
  .wready      ( m_axi_gmem_WREADY  ) ,
  .wdata       ( m_axi_gmem_WDATA   ) ,
  .wstrb       ( m_axi_gmem_WSTRB   ) ,
  .wlast       ( m_axi_gmem_WLAST   ) ,

  .bvalid      ( m_axi_gmem_BVALID  ) ,
  .bready      ( m_axi_gmem_BREADY  ) ,
  .bresp       ( m_axi_gmem_BRESP   ) 
);


ila_axi_MM_rtl U_ila_axi_MM_rtl (
	.clk(ap_clk), // input wire clk
	.probe0( m_axi_gmem_WREADY), // input wire [0:0] probe0  
	.probe1( m_axi_gmem_AWADDR), // input wire [63:0]  probe1 
	.probe2( m_axi_gmem_BRESP), // input wire [1:0]  probe2 
	.probe3( m_axi_gmem_BVALID), // input wire [0:0]  probe3 
	.probe4( m_axi_gmem_BREADY), // input wire [0:0]  probe4 
	.probe5( m_axi_gmem_ARADDR), // input wire [63:0]  probe5 
	.probe6( m_axi_gmem_RREADY), // input wire [0:0]  probe6 
	.probe7( m_axi_gmem_WVALID), // input wire [0:0]  probe7 
	.probe8( m_axi_gmem_ARVALID), // input wire [0:0]  probe8 
	.probe9( m_axi_gmem_ARREADY), // input wire [0:0]  probe9 
	.probe10( m_axi_gmem_RDATA), // input wire [63:0]  probe10 
	.probe11( m_axi_gmem_AWVALID), // input wire [0:0]  probe11 
	.probe12( m_axi_gmem_AWREADY), // input wire [0:0]  probe12 
	.probe13( m_axi_gmem_RRESP), // input wire [1:0]  probe13 
	.probe14( m_axi_gmem_WDATA), // input wire [63:0]  probe14 
	.probe15( m_axi_gmem_WSTRB), // input wire [7:0]  probe15 
	.probe16( m_axi_gmem_RVALID), // input wire [0:0]  probe16 
	.probe17( m_axi_gmem_ARPROT), // input wire [2:0]  probe17 
	.probe18( m_axi_gmem_AWPROT), // input wire [2:0]  probe18 
	.probe19( m_axi_gmem_AWID), // input wire [0:0]  probe19 
	.probe20( m_axi_gmem_BID), // input wire [0:0]  probe20 
	.probe21( m_axi_gmem_AWLEN), // input wire [7:0]  probe21 
	.probe22( ap_start_pulse), // input wire [0:0]  probe22 
	.probe23( m_axi_gmem_AWSIZE), // input wire [2:0]  probe23 
	.probe24( m_axi_gmem_AWBURST), // input wire [1:0]  probe24 
	.probe25( m_axi_gmem_ARID), // input wire [0:0]  probe25 
	.probe26( m_axi_gmem_AWLOCK), // input wire [0:0]  probe26 
	.probe27( m_axi_gmem_ARLEN), // input wire [7:0]  probe27 
	.probe28( m_axi_gmem_ARSIZE), // input wire [2:0]  probe28 
	.probe29( m_axi_gmem_ARBURST), // input wire [1:0]  probe29 
	.probe30( m_axi_gmem_ARLOCK), // input wire [0:0]  probe30 
	.probe31( m_axi_gmem_ARCACHE), // input wire [3:0]  probe31 
	.probe32( m_axi_gmem_AWCACHE), // input wire [3:0]  probe32 
	.probe33( m_axi_gmem_ARREGION), // input wire [3:0]  probe33 
	.probe34( m_axi_gmem_ARQOS), // input wire [3:0]  probe34 
	.probe35( ap_wr_done), // input wire [0:0]  probe35 
	.probe36( m_axi_gmem_AWREGION), // input wire [3:0]  probe36 
	.probe37( m_axi_gmem_AWQOS), // input wire [3:0]  probe37 
	.probe38( m_axi_gmem_RID), // input wire [0:0]  probe38 
	.probe39( ap_rd_done), // input wire [0:0]  probe39 
	.probe40( 1'b0), // input wire [0:0]  probe40 
	.probe41( m_axi_gmem_RLAST), // input wire [0:0]  probe41 
	.probe42( 1'b0), // input wire [0:0]  probe42  
	.probe43( m_axi_gmem_WLAST) // input wire [0:0]  probe43
);


endmodule : krnl_vadd_2clk_proc_pipeline

`default_nettype wire
