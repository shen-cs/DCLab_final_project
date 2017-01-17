module vga_top(
	input i_clk,
	input i_rst,
	input [3:0] i_size,
	input [1:0]	i_direction,
	input i_done,					// 視力已經判斷完了
	output vga_sync,	
	output vga_h_sync,
	output vga_v_sync,
	output inDisplayArea,	
	output [7:0] vga_R,				// 最top的 R G B 是8 bit
	output [7:0] vga_G, 				
	output [7:0] vga_B
);


	logic [11:0] CounterX;
	logic [11:0] CounterY;
	logic pixel_show;
//	logic [7:0]  display_w, display_r;
	logic [7:0] vga_R_buffer_w, vga_R_buffer_r, vga_G_buffer_w, vga_G_buffer_r, vga_B_buffer_w, vga_B_buffer_r;
	
	assign  vga_sync=1;	
/*
	assign	vga_R = 8'b11111111;
	assign	vga_G = 8'b11111111;
	assign	vga_B = 8'b11111111;
*/
	assign	vga_R = vga_R_buffer_r;
	assign	vga_G = vga_G_buffer_r;
	assign	vga_B = vga_B_buffer_r;

	//////SoundOff Key///////

always_comb begin
	vga_R_buffer_w = vga_R_buffer_r;
	vga_G_buffer_w = vga_G_buffer_r;
	vga_B_buffer_w = vga_B_buffer_r;


	if(pixel_show && inDisplayArea) begin
		vga_R_buffer_w = 255;
		vga_B_buffer_w = 255;
		vga_G_buffer_w = 255;
	end

	else begin
		vga_R_buffer_w = 0;
		vga_B_buffer_w = 0;
		vga_G_buffer_w = 0;		
	end
		
end
		
	
///////640X480 VGA-Timing-generater///////


	vga_time_generator vga0(
		.pixel_clk(i_clk),
		.h_disp   (640),
		.h_fporch (16),
		.h_sync   (96), 
		.h_bporch (48),
		.v_disp   (480),
		.v_fporch (10),
		.v_sync   (2),
		.v_bporch (33),
		.vga_hs   (vga_h_sync),
		.vga_vs   (vga_v_sync),
		.vga_blank(inDisplayArea),
		.CounterY(CounterY),
		.CounterX(CounterX) 
	);

	VGA_SHOW_E vga_show_0(
		.i_clk(i_clk),		
		.i_rst(i_rst),   				// not defined yet
		.x(CounterX),
		.y(CounterY),
		.i_size(i_size),
		.i_direction(i_direction),
		.i_done(i_done),
		.o_e_chart_color(pixel_show)  	// not defined yet
	);
always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
//		display_r <= 0;
		vga_R_buffer_r <= 0;
		vga_B_buffer_r <= 0;
		vga_G_buffer_r <= 0;
	end
	else begin
//		display_r <= display_w;
		vga_R_buffer_r <= vga_R_buffer_w;
		vga_B_buffer_r <= vga_B_buffer_w;
		vga_G_buffer_r <= vga_G_buffer_w;
	end
end

	

endmodule