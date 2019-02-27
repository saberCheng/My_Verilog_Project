`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2119 03:52:02 PM
// Design Name: 
// Module Name: coordinate_shift
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


module coordinate_shift(
input	     [4:0] 	shift_boundary,
input	     [21:0]	b_shift_x,
input     	 [21:0]	b_shift_y,
// a for after, b for before
output  reg  [21:0]	a_shift_x,
output  reg  [21:0] a_shift_y

    );

always @ (*) begin
	a_shift_y = 'd0;
	a_shift_x = 'd0;
	case (shift_boundary) 
		5'd0: begin
			a_shift_x = b_shift_x;
			a_shift_y = b_shift_y;
		end 
		5'd1: begin
			a_shift_x = {b_shift_x[21], b_shift_x[21:1]};
			a_shift_y = {b_shift_y[21], b_shift_y[21:1]};
		end
		5'd2: begin
			a_shift_x = { {2{b_shift_x[21]}}, b_shift_x[21:2]};
			a_shift_y = { {2{b_shift_y[21]}}, b_shift_y[21:2]};
		end
		5'd3: begin
			a_shift_x = { {3{b_shift_x[21]}}, b_shift_x[21:3]};
			a_shift_y = { {3{b_shift_y[21]}}, b_shift_y[21:3]};
		end 
		5'd4: begin
			a_shift_x = { {4{b_shift_x[21]}}, b_shift_x[21:4]};
			a_shift_y = { {4{b_shift_y[21]}}, b_shift_y[21:4]};
		end
		5'd5: begin
			a_shift_x = { {5{b_shift_x[21]}}, b_shift_x[21:5]};
			a_shift_y = { {5{b_shift_y[21]}}, b_shift_y[21:5]};
		end
		5'd6: begin
			a_shift_x = { {6{b_shift_x[21]}}, b_shift_x[21:6]};
			a_shift_y = { {6{b_shift_y[21]}}, b_shift_y[21:6]};
		end
		5'd7: begin
			a_shift_x = { {7{b_shift_x[21]}}, b_shift_x[21:7]};
			a_shift_y = { {7{b_shift_y[21]}}, b_shift_y[21:7]};
		end
		5'd8: begin
			a_shift_x = { {8{b_shift_x[21]}}, b_shift_x[21:8]};
			a_shift_y = { {8{b_shift_y[21]}}, b_shift_y[21:8]};
		end
		5'd9: begin
			a_shift_x = { {9{b_shift_x[21]}}, b_shift_x[21:9]};
			a_shift_y = { {9{b_shift_y[21]}}, b_shift_y[21:9]};
		end
		5'd10: begin
			a_shift_x = { {10{b_shift_x[21]}}, b_shift_x[21:10]};
			a_shift_y = { {10{b_shift_y[21]}}, b_shift_y[21:10]};
		end
		5'd11: begin
			a_shift_x = { {11{b_shift_x[21]}}, b_shift_x[21:11]};
			a_shift_y = { {11{b_shift_y[21]}}, b_shift_y[21:11]};
		end
		5'd12: begin
			a_shift_x = { {12{b_shift_x[21]}}, b_shift_x[21:12]};
			a_shift_y = { {12{b_shift_y[21]}}, b_shift_y[21:12]};
		end
		5'd13: begin
			a_shift_x = { {13{b_shift_x[21]}}, b_shift_x[21:13]};
			a_shift_y = { {13{b_shift_y[21]}}, b_shift_y[21:13]};
		end
		5'd14: begin
			a_shift_x = { {14{b_shift_x[21]}}, b_shift_x[21:14]};
			a_shift_y = { {14{b_shift_y[21]}}, b_shift_y[21:14]};
		end
		5'd15: begin
			a_shift_x = { {15{b_shift_x[21]}}, b_shift_x[21:15]};
			a_shift_y = { {15{b_shift_y[21]}}, b_shift_y[21:15]};
		end
		5'd16: begin
			a_shift_x = { {16{b_shift_x[21]}}, b_shift_x[21:16]};
			a_shift_y = { {16{b_shift_y[21]}}, b_shift_y[21:16]};
		end
		5'd17: begin
			a_shift_x = { {17{b_shift_x[21]}}, b_shift_x[21:17]};
			a_shift_y = { {17{b_shift_y[21]}}, b_shift_y[21:17]};
		end
		5'd18: begin
			a_shift_x = { {18{b_shift_x[21]}}, b_shift_x[21:18]};
			a_shift_y = { {18{b_shift_y[21]}}, b_shift_y[21:18]};
		end
		5'd19: begin
			a_shift_x = { {19{b_shift_x[21]}}, b_shift_x[21:19]};
			a_shift_y = { {19{b_shift_y[21]}}, b_shift_y[21:19]};
		end
	endcase 
end 

endmodule
