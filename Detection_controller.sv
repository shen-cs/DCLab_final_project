module Detection_controller (
	input clk,    // Clock
	input rst,  // Asynchronous reset active low
	input [7:0] vga_r, 
	input [7:0] vga_g,
	input [7:0] vga_b,
	output start_detect,
	output finish_detect
);
	localparam WHITE = 0; BLACK = 1; 
	logic state_w, state_r;

	always_comb begin
		
		case (state_r)
			WHITE: begin 
				start_detect = 0;
				finish_detect = 1;
				if(vga_b > 8'b10101111 && vga_g > 8'b10101111 && vga_r > 8'b10101111) begin
					state_w = BLACK;		
				end
			end
			BLACK: begin
				start_detect = 1;
				finish_detect = 0;
				if(vga_b < 8'b00011111 && vga_g < 8'b00011111 && vga_r < 8'b00011111) begin
					state_w = WHITE;
				end
			end
			default : /* default */;
		endcase
	end
	

	always_ff @(posedge clk or negedge rst) begin 
		if(~rst) begin
			state_r <= WHITE;
		end else begin
			state_r <= state_w;
		end
	end
endmodule