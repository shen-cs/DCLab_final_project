module Detection_controller (
	input clk,    // Clock
	input rst,  // Asynchronous reset active low
	input [9:0] vga_x,
	input [9:0] vga_y,
	input [7:0] vga_r, 
	input [7:0] vga_g,
	input [7:0] vga_b,
	input [9:0] centerX,
	input  video_active,
	output start_detect,
	output finish_detect
);
	localparam WHITE = 0; BLACK = 1; 
	logic state_w, state_r;
	logic start_detect_r, finish_detect_r;
	logic [5:0] frame_counter_w, frame_counter_r;
	assign start_detect = video_active ? start_detect_r : 0;
	assign finish_detect = video_active ? finish_detect_r : 0;
	always_comb begin
		frame_counter_w = frame_counter_r;
		case (state_r)
			WHITE: begin 
				start_detect_r = 0;
				finish_detect_r = (frame_counter == 120) ? 1 : 0;
				if(vga_b < 8'b00011111 && vga_g < 8'b00011111 && vga_r < 8'b00011111) begin
					state_w = BLACK;		
				end
			end
			BLACK: begin
				start_detect_r = (frame_counter == 120) ? 1 : 0;
				finish_detect_r = 0;
				if(vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111) begin
					state_w = WHITE;
				end
			end
			default : begin
				start_detect_r = 0;
				finish_detect_r = 0;
			end
		endcase
		if(centerX != 0 && vga_x == centerX) begin
			start_detect_r = (vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111);
		end
	end
	

	always_ff @(posedge clk or negedge rst) begin 
		if(~rst) begin
			state_r <= WHITE;
		end else begin
			state_r <= state_w;
		end
	end

	always_ff @(posedge video_active or negedge rst) begin 
		if(~rst) begin
			frame_counter_r <= 0;
		end else begin
			frame_counter_r <= frame_counter_w + 1;;
		end
	end
endmodule