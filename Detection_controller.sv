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
		
	end
	

	always_ff @(posedge clk or negedge rst) begin 
		if(~rst) begin
			 <= 0;
		end else begin
			 <= ;
		end
	end
endmodule