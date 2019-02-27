`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Fudan BCRC
// Engineer: Shaobao Cheng 
// 
// Create Date: 01/11/2119 01:54:54 PM
// Design Name: cordic rotate
// Module Name: cordic_top
// Project Name: 
// Target Devices: zedboard
// Tool Versions: 
// Description: for cordic rotate
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_top(
input           clk,
input 	        rst,
input	        cordic_start,

input  	signed [21:0] 	input_x,
input  	signed [21:0]	input_y,
input   signed [24:0]   input_angle,

output	wire signed	[21:0]	output_x,
output 	wire signed	[21:0]  output_y,
output  reg  signed [24:0]  output_angle,
output  reg                 cordic_finish
    );

parameter         ERROR       = 25'b0_0000000_00000000000001110;
parameter  signed K_FACTOR    = 21'b0_10011010100011000001;
parameter         ITER_LIMIT  = 5'd20;


reg   signed   [21:0]   cur_y, cur_x;
reg   signed   [21:0]   nxt_y, nxt_x;
reg   signed   [24:0]   cur_angle;
reg   signed   [24:0]   nxt_angle;

reg   cordic_active;
reg   signed  [1:0]  sgn;

// fsm control signal generation
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		cordic_active <= 1'b0;
	end 
	else if (cordic_start) begin
		cordic_active <= 1'b1;
	end 
	else if (cordic_finish) begin
		cordic_active <= 1'b0;
	end 
end 

always @ ( posedge clk or posedge rst) begin
	if (rst) begin
		cordic_finish <= 0;
		sgn           <= 0;
	end 
	else if (cordic_start) begin
		cordic_finish <= 1'b0;
	end
	else if (cordic_active) begin
		if (iter_cnt == ITER_LIMIT - 1'b1) begin
			cordic_finish <= 1'b1;
		end 
		else begin
			if (nxt_angle > input_angle) begin
				cordic_finish <= ((nxt_angle - input_angle) < ERROR) ? 1'b1 : 1'b0;
				sgn           <= -2'd1;
			end
			else begin
				cordic_finish <= ((input_angle - nxt_angle) < ERROR) ? 1'b1 : 1'b0;
				sgn           <= 2'd1;
			end
		end
	end 
end 

reg          [4:0]    iter_cnt;
reg          [4:0]    iter_cnt_d1;
wire  signed [24:0]   iter_angle;
wire  signed [24:0]   r_angle;
wire  signed [21:0]   cur_x_shift;
wire  signed [21:0]   cur_y_shift;

// fsm state change
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		iter_cnt  <= 'd0;
        cur_x     <= 'd0;
        cur_y     <= 'd0;
       	cur_angle <= 'd0;
    end 
    else if (cordic_start) begin
    	iter_cnt  <= 'd0;
    	cur_x     <= input_x;
    	cur_y     <= input_y;
    	cur_angle <= 'd0;
    end
    else if (cordic_active) begin
    	cur_x     <= nxt_x;
    	cur_y     <= nxt_y;
    	cur_angle <= nxt_angle;
    	iter_cnt  <= (cordic_finish) ? iter_cnt : (iter_cnt + 1'b1);
    end 	
end 

always @ (*) begin
	nxt_x     = cur_x - sgn * cur_y_shift;
	nxt_y     = cur_y + sgn * cur_x_shift;
	nxt_angle = cur_angle + sgn * iter_angle;
end 		

always @ (posedge clk) begin
	iter_cnt_d1 <= iter_cnt;
end 

coordinate_shift xy_shift(
   .shift_boundary       ( iter_cnt_d1 ),
   .b_shift_x            ( cur_x       ),
   .b_shift_y            ( cur_y       ),
   .a_shift_x            ( cur_x_shift ),
   .a_shift_y            ( cur_y_shift )
);

assign iter_angle = (iter_cnt_d1 < ITER_LIMIT)? r_angle : 'd0;

blk_mem_gen_0 angle_rom (
  .clka                 (  clk           ),    
  .addra                (  iter_cnt      ),  
  .douta                (  r_angle       )  
);

// output stage
reg   signed  [42:0]   output_x_tmp;
reg   signed  [42:0]   output_y_tmp;

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		output_x_tmp <= 'd0;
		output_y_tmp <= 'd0;
		output_angle <= 'd0;
	end 
	else if (cordic_finish && cordic_active) begin
		output_x_tmp <= cur_x * K_FACTOR;
		output_y_tmp <= cur_y * K_FACTOR;
		output_angle <= cur_angle;
	end 
end 

assign output_x = {output_x_tmp[42], output_x_tmp[40:20]};
assign output_y = {output_y_tmp[42], output_y_tmp[40:20]};

endmodule
