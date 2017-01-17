module Point_detection (
	input clk,    // Clock rate same as pixel rate
	input rst,  // Asynchronous reset active low
	input i_start, // from detection controller
	input i_finish, // from detection controller
	input [9:0] i_left_edge, // from vga x 
	input [9:0] i_y, // from vga y
	output o_finished,
	output [9:0] o_centerX, // output x for camera or vga to store its value
	output [8:0] o_centerY,
	output [2:0] o_mask
);
	// TODO : only detect point at 120th frame, fix the bug that lower half of point
	localparam [3:0] MAX_NUM = 4;
	localparam [3:0] IDLE = 0, START = 1, COMPARE = 2, WAIT_WHITE = 3. FINISH = 4, FINISH_ALL = 5;
	logic [2:0] state_w, state_r;
	logic [8:0] x_counter_w, x_counter_r;
	logic [8:0] px_counter_w, px_counter_r; //previous width
	logic [9:0] p_left_edge_w, p_left_edge_r; //previous edge point
	
	logic [9:0] centerX;
	logic finished;

	logic [2:0] counter_w, counter_r;

	assign o_finished = finished;
	assign o_centerX = centerX;
	assign o_centerY = i_y;
	assign o_mask = counter_r;

	always_comb begin 
		state_w = state_r;
		x_counter_w = x_counter_r;
		px_counter_w = px_counter_r;
		p_left_edge_w = p_left_edge_r;
		counter_w = counter_r;
		centerX = 0;
		finished = 0;
		case(state_r)
			IDLE: begin
				if(i_start) begin
					state_w = START;
					x_counter_w = 0;
					counter_w = 0;
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
					state_w = WAIT_WHITE;
				end
				else begin
					px_counter_w = x_counter_r;
					p_left_edge_w = i_left_edge;
					state_w = IDLE;
					
				end
			end

			WAIT_WHITE: begin
				centerX = p_left_edge_r + px_counter_r / 2;
				if(i_start) begin
					state_w = FINISH;
					counter_w = counter_r + 1;
				end
			end

			FINISH: begin
				centerX = p_left_edge_r + px_counter_r / 2;
				finished = 1;
				state_w = (counter_r == MAX_NUM) ? FINISH_ALL : IDLE;
			end

			FINISH_ALL :begin 
				state_w = FINISH_ALL;
				counter_w = 0;
				finished = 0;
			end
		endcase
	end




	always_ff @(posedge clk or negedge rst) begin :
		if(~rst) begin
			state_r <= IDLE;
			x_counter_r <= 0;
			px_counter_r <= 0;
			p_left_edge_r <= 0;
			counter_r <= 0;
		end 
		else begin
			state_r <= state_w;
			x_counter_r <= x_counter_w;
			px_counter_r <= px_counter_w;
			p_left_edge_r <= p_left_edge_w;
			counter_r <= counter_w;
		end
	end
endmodule