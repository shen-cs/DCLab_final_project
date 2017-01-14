module Point_detection (
	input clk,    // Clock rate same as pixel rate
	input rst,  // Asynchronous reset active low
	input i_start,
	input i_finish,
	input [9:0] i_left_edge,
	input [8:0] i_y,
	output o_finished,
	output [9:0] o_centerX, // output x for camera or vga to store its value
	output [8:0] o_centerY
);
	//localparam [3:0] MAX_NUM = 4;
	localparam [2:0] IDLE = 0, START = 1, COMPARE = 2, FINISH = 3;
	logic [2:0] state_w, state_r;
	logic [8:0] x_counter_w, x_counter_r;
	logic [8:0] px_counter_w, px_counter_r; //previous width
	logic [9:0] p_left_edge_w, p_left_edge_r; //previous edge point


	logic [9:0] centerX;
	logic finished;

	assign o_finished = finished;
	assign o_centerX = centerX;
	assign o_centerY = i_y;

	always_comb begin 
		state_w = state_r;
		x_counter_w = x_counter_r;
		px_counter_w = px_counter_r;
		p_left_edge_w = p_left_edge_r;
		switch(state_r)
			IDLE: begin
				if(i_start) begin
					state_w = START;
					x_counter_w = 0;
				end
			end
			START: begin
				x_counter_w = x_counter_r + 1;
				if(i_finish) begin
					state_w = COMPARE;
				end

			end
			COMPARE: begin
				if(px_counter_r > x_counter_r) begin
					state_w = FINISH;
				end
				else begin
					px_counter_w = x_counter_r;
					p_left_edge_w = i_left_edge;
					state_w = IDLE;
				end
			end

			FINISH: begin
				centerX = p_left_edge_r + px_counter_r / 2;
				finished = 1;
			end
	end




	always_ff @(posedge clk or negedge rst) begin :
		if(~rst) begin
			state_r <= IDLE;
			x_counter_r <= 0;
			px_counter_r <= 0;
			p_left_edge_r <= 0;
		end 
		else begin
			state_r <= state_w;
			x_counter_r <= x_counter_w;
			px_counter_r <= px_counter_w;
			p_left_edge_r <= p_left_edge_w;
		end
	end
endmodule