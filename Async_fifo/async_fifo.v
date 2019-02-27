`timescale 1ns / 1ps


module async_fifo 
#(
parameter FIFO_DEPTH  = 4,
parameter FIFO_WIDTH  = 2,
parameter DATA_WIDTH  = 8
)(
input                            wrst,
input                            wclk,
input                            wen,
input        [DATA_WIDTH-1 : 0]  wdata,
output  reg                      w_full,

input                            rrst,
input                            rclk,
input                            ren,
output  reg  [DATA_WIDTH-1 : 0]  rdata,
output  reg                      r_empty
);


reg [DATA_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
reg [FIFO_WIDTH-1:0] w_ptr_g, w_ptr_g_d1, w_ptr_g_sync;
reg [FIFO_WIDTH-1:0] r_ptr_g, r_ptr_g_d1, r_ptr_g_sync;

// sync the w_ptr to rclk domain
always @ (posedge rclk or posedge rrst) begin
	if (rrst) begin
		w_ptr_g_d1   <= 'd0;
		w_ptr_g_sync <= 'd0; 
	end 
	else begin
		w_ptr_g_d1   <= w_ptr_g;
		w_ptr_g_sync <= w_ptr_g_d1;
	end 
end 
// sync the r_ptr to rclk domain
always @ (posedge wclk or posedge wrst) begin
	if (wrst) begin
		r_ptr_g_d1   <= 'd0;
		r_ptr_g_sync <= 'd0;
	end 
	else begin
		r_ptr_g_d1   <= r_ptr_g;
		r_ptr_g_sync <= r_ptr_g_d1;
	end 
end 

// ptr increase
wire w_ptr_inc;
wire r_ptr_inc;

assign w_ptr_inc = wen && (~w_full);
assign r_ptr_inc = ren && (~r_empty);

wire [FIFO_WIDTH-1:0] w_ptr_b, r_ptr_b;
wire [FIFO_WIDTH:0]   w_ptr_b_nxt, r_ptr_b_nxt;
wire [FIFO_WIDTH-1:0] w_ptr_g_nxt, r_ptr_g_nxt;
// write ptr increase
generate 
	for (genvar i = 0; i < FIFO_WIDTH; i=i+1) begin
		assign w_ptr_b[i] = ^(w_ptr_g >> i);
	end 
endgenerate 

assign w_ptr_b_nxt = w_ptr_b + w_ptr_inc;
assign w_ptr_g_nxt = (w_ptr_b_nxt>>1) ^ w_ptr_b_nxt;


always @ (posedge wclk or posedge wrst) begin
	if (wrst) begin
		w_ptr_g <= 'd0;
	end 
	else if (w_ptr_b == FIFO_DEPTH-1) begin
		w_ptr_g <= 'd0;
	end 
	else begin
		w_ptr_g <= w_ptr_g_nxt;
	end 
end 

// read ptr increase 
generate 
	for (genvar i = 0; i < FIFO_WIDTH; i=i+1) begin
		assign r_ptr_b[i] = ^(r_ptr_g >> i);
	end 
endgenerate 

assign r_ptr_b_nxt = r_ptr_b + r_ptr_inc;
assign r_ptr_g_nxt = (r_ptr_b_nxt>>1) ^ r_ptr_b_nxt;


always @ (posedge rclk or posedge rrst) begin
	if (rrst) begin
		r_ptr_g <= 'd0;
	end 
	else if (r_ptr_b == FIFO_DEPTH-1) begin
		r_ptr_g <= 'd0;
	end 
	else begin
		r_ptr_g <= r_ptr_g_nxt;
	end 
end 

// empty and full signal generation
reg   full_flag, empty_flag;

always @ (posedge wclk or posedge wrst) begin
	if (wrst) begin
		full_flag <= 1'b0;
	end 
	else if (w_ptr_b == FIFO_DEPTH - 1) begin
		full_flag <= ~full_flag;
	end 
end 

always @ (posedge rclk or posedge rrst) begin
	if (rrst) begin
		empty_flag <= 1'b0;
	end 
	else if (r_ptr_b == FIFO_DEPTH - 1) begin
		empty_flag <= ~empty_flag;
	end 
end 


always @ (posedge rclk or posedge rrst) begin
	if (rrst) begin
		r_empty <= 1'b1;
	end 
	else begin
		r_empty <= (r_ptr_g == w_ptr_g_sync) && (empty_flag == full_flag);
	end 
end 

always @ (posedge wclk or posedge wrst) begin
	if (wrst) begin
		w_full <= 1'b0;
	end 
	else begin
		w_full <= (w_ptr_g == r_ptr_g_sync) && (empty_flag != full_flag);
	end 
end 

always @ (posedge wclk) begin
	if (wen) begin
		fifo[w_ptr_b] <= wdata;
	end 
end 

always @ (posedge rclk or posedge rrst) begin
	if (rrst) begin
		rdata <= 'd0;
	end 
	else if (ren) begin
		rdata <= fifo[r_ptr_b];
	end 
end 

endmodule
