module Sound_controller (
	input clk,    // Clock
	input rst,  // Asynchronous reset active low
	input detect_finished,
	input state, // 0 play, 1 record
	input [2:0] mask, // 001 store point1, 010 point2, etc.
	input [9:0] i_x,
	input [9:0] i_y,
	input [7:0] vga_r, 
	input [7:0] vga_g, 
	input [7:0] vga_b,
	output [2:0] sound_num
);

logic [9:0] point1x_w, point1x_r, point2x_w, point2x_r, point3x_w, point3x_r, point4x_w, point4x_r;
logic [9:0] point1y_w, point1y_r, point2y_w, point2y_r, point3y_w, point3y_r, point4y_w, point4y_r;


always_comb begin
	point1x_w = point1x_r;
	point1y_w = point1y_r;
	point2x_w = point2x_r;
	point2y_w = point2y_r;
	point3x_w = point3x_r;
	point3y_w = point3y_r;
	point4x_w = point4x_r;
	point4y_w = point4y_r;
	sound_num = 0;
	if(state == 0) begin
		if(i_x == point1x_r && i_y == point1y_r) begin
			if(vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111)
				sound_num = 1;
		end
		else if (i_x == point2x_r && i_y == point2y_r) begin
			if(vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111)
				sound_num = 2;
		end
		else if (i_x == point3x_r && i_y == point3y_r) begin
			if(vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111)
				sound_num = 3;
		end
		else if (i_x == point4x_r && i_y == point4y_r) begin
			if(vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111)
				sound_num = 4;
		end
		else 
			sound_num = 0;
	end
	else begin
		if(detect_finished) begin
			case(mask) 
				3'b001: begin
					point1x_w = i_x;
					point1y_w = i_y;
				end
				3'b010: begin
					point2x_w = i_x;
					point2y_w = i_y;
				end
				3'b011: begin
					point3x_w = i_x;
					point3y_w = i_y;
				end
				3'b100: begin
					point4x_w = i_x;
					point4y_w = i_y;
				end
				default: begin

				end
			endcase // mask
		end
		
	end
end



always_ff @(posedge clk or negedge rst) begin 
	if(~rst) begin
		point1x_r <= 0;
		point1y_r <= 0;
		point2x_r <= 0;
		point2y_r <= 0;
		point3x_r <= 0;
		point3y_r <= 0;
		point4x_r <= 0;
		point4y_r <= 0;
	end else begin
		point1x_r <= point1x_w;
		point1y_r <= point1y_w;
		point2x_r <= point2x_w;
		point2y_r <= point2y_w;
		point3x_r <= point3x_w;
		point3y_r <= point3y_w;
		point4x_r <= point4x_w;
		point4y_r <= point4y_w;
	end
end
endmodule