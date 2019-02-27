`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2019 10:10:04 AM
// Design Name: 
// Module Name: async_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module async_fifo_tb();

parameter  FIFO_DEPTH = 7;
parameter  FIFO_WIDTH = 3;
parameter  DATA_WIDTH = 8;
parameter  R_CLK_T    = 6;
parameter  W_CLK_T    = 8;

reg  wrst, wclk;
reg  rrst, rclk;
reg  wen , ren;

reg  [DATA_WIDTH-1:0] wdata;
wire [DATA_WIDTH-1:0] rdata;
wire w_full, r_empty;

initial begin
	wclk = 1'b0;
	rclk = 1'b0;
	wrst = 1'b0;
	rrst = 1'b0;
# 10
	wrst = 1'b1;
	rrst = 1'b1;
# 10 
	wrst = 1'b0;
	rrst = 1'b0;
end 

always #(R_CLK_T/2) rclk = ~rclk;
always #(W_CLK_T/2) wclk = ~wclk;

always @ (posedge wclk or wrst) begin
	if (wrst) begin
		wdata = 'd0;
	end 
	else if (wen) begin
		wdata = wdata + 1'b1;
	end 
end 
 
always @ (posedge wclk or wrst) begin
	if (wrst) begin
		wen = 1'b0;
	end 
	else if (r_empty) begin
		wen = 1'b1;
	end 
	else if (w_full) begin
		wen = 1'b0;
	end 
end 

always @ (posedge rclk or posedge rrst) begin
	if (rrst) begin
		ren = 1'b0;
	end 
	else if (!r_empty) begin
		ren = 1'b1;
	end 
	else begin
		ren = 1'b0;
	end 
end 

initial begin
	#1000 $stop;
end 

async_fifo
#(
	.FIFO_WIDTH(FIFO_WIDTH),
	.FIFO_DEPTH(FIFO_DEPTH),
	.DATA_WIDTH(DATA_WIDTH)
)DUT (
	.wrst	   ( wrst   ),
	.wclk      ( wclk   ),
	.wen       ( wen    ),
	.wdata     ( wdata  ),
	.w_full    ( w_full ),
	.rrst      ( rrst   ),
	.rclk      ( rclk   ),
	.ren       ( ren    ),
	.rdata     ( rdata  ),
	.r_empty   (r_empty )
);

endmodule
