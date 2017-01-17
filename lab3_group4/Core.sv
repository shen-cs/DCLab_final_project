module Core (
	// Input from IR module
	input [2:0] user_direction,
	input	reset,
	
	input	i_clk,
	input	i_rst,
	
	// Output to VGA module
	output [1:0] random_direction,
	output [3:0] size,
	output	done
);
logic [2:0] state_w, state_r;
logic [1:0] random_direction_w, random_direction_r;
logic [1:0] counter_w, counter_r;
logic [3:0] size_w, size_r;
logic done_w, done_r;

localparam start = 0;
localparam O = 1;
localparam X = 2;
localparam OO = 3;
localparam XO = 4;
localparam XX = 5;

localparam up = 3'b000;
localparam down = 3'b001;
localparam left = 3'b010;
localparam right = 3'b011;
localparam No_signal = 3'b100;

assign random_direction = random_direction_r;
assign size = size_r;
assign done = done_r;

always begin
	// State transition
	case (state_r) 
		start : begin
			if (reset == 1) begin
				state_w = state_r;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction == random_direction_r) begin
				state_w = O;
				random_direction_w = counter_r;
			end	
			else begin
				state_w = X;
				random_direction_w = counter_r;
			end
		end
		
		O : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction == random_direction_r) begin
				state_w = OO;
				random_direction_w = counter_r;
			end
			else begin
				state_w = X;
				random_direction_w = counter_r;
			end
		end
		
		X : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction == random_direction_r) begin
				state_w = XO;
				random_direction_w = counter_r;
			end
			else begin
				state_w = XX;
				random_direction_w = counter_r;
			end
		end
		
		OO : begin
			if ((reset == 1)||(size_r == 4'b1100)) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction == random_direction_r) begin
				state_w = O;
				random_direction_w = counter_r;
			end
			else begin
				state_w = X;
				random_direction_w = counter_r;
			end
		end
		
		XO : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction == random_direction_r) begin
				state_w = OO;
				random_direction_w = counter_r;
			end
			else begin
				state_w = XX;
				random_direction_w = counter_r;
			end
		end
		
		XX : begin
			state_w = start;
		end
		
	endcase
	
	// To do in each state_r
	counter_w = counter_r + 1; // Independent of state transition
	
	if (state_r == start) begin
		size_w = 4'b0000;
		done_w = 0;
	end
	else if (state_r == O) begin
		size_w = size_r;
		done_w = done_r;
	end
	else if (state_r == X) begin
		size_w = size_r;
		done_w = done_r;
	end
	else if (state_r == OO) begin
		if (size_r == 4'b1100) begin
			done_w = 1;
			size_w = size_r;
		end
		else begin
			done_w = done_r;
			size_w = size_r + 1;
		end
	end
	else if (state_r == XO) begin
		size_w = size_r;
		done_w = done_r;
	end
	else begin
		done_w = 1;
		if (size_r == 4'b0000)
			size_w = size_r;
		else
			size_w = size_r - 1;
	end
end

always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state_r <= start;
		random_direction_r <= 2'b00;
		size_r <= 4'b0000;
		counter_r <= 2'b00;
		done_r <= 0;
	end
	else begin
		state_r <= state_w;
		random_direction_r <= random_direction_w;
		size_r <= size_w;
		counter_r <= counter_w;
		done_r <= done_w;
	end
end
endmodule