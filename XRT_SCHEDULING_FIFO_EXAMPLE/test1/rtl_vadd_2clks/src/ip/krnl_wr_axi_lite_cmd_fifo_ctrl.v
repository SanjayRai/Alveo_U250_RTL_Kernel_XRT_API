
`timescale 1ns/1ps
module krnl_wr_axi_lite_cmd_fifo_ctrl (
    input  wire          ACLK,
    input  wire          ARESETN,
    input  wire          WVALID,
    input wire           WREADY,
    output  wire         BREADY,
    output wire [1:0]    BRESP,
    output wire          BVALID

);

reg r0_BVALID = 1'b0;
reg r1_BVALID = 1'b0;
reg r2_BVALID = 1'b0;

assign BREADY  = 1'b1;  // OKAY
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (r1_BVALID & ~r2_BVALID); 

always @(posedge ACLK) begin
    if (~ARESETN) begin
        r0_BVALID <= 1'b0;
        r1_BVALID <= 1'b0;
        r2_BVALID <= 1'b0;
    end else begin
        r0_BVALID <= (WVALID & WREADY); 
        r1_BVALID <= r0_BVALID;
        r2_BVALID <= r1_BVALID;
    end
end

endmodule
