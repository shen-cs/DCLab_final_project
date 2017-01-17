module LCD_controller (
	input iCLK, iRST_N,
    input ctrl_RS,
    input ctrl_Start,
    input [7:0] ctrl_DATA,
    output ctrl_Done,
    output [7:0] LCD_DATA,
    output LCD_RS,
    output LCD_RW,
    output LCD_EN
);

logic [1:0] state_r, state_w;
logic [4:0] counter_r, counter_w;
logic start_r, start_w, oDone_r, oDone_w, en_r, en_w;

localparam S_IDLE = 0;
localparam S_SETUP = 1;
localparam S_DELAY = 2;
localparam S_DONE = 3;

parameter CLK_Divide = 4;

assign LCD_DATA = ctrl_DATA;
assign LCD_RS = ctrl_RS;
assign LCD_RW = 1'b0;
assign LCD_EN = en_r;
assign ctrl_Done = oDone_r;

always_comb begin
	case(state_r)
		S_IDLE : begin
			if(start_r) begin
				state_w = S_SETUP;
			end
			else begin
				state_w = state_r;
			end
		end

		S_SETUP : begin
			state_w = S_DELAY;
		end

		S_DELAY : begin
			if(counter_r >= CLK_Divide) begin
				state_w = S_DONE;
			end
			else begin
				state_w = state_r;
			end
		end

		S_DONE : begin
			state_w = S_IDLE;
		end
	endcase
	
	if (state_r == S_SETUP) begin
		counter_w =counter_r;
		start_w = start_r;
		oDone_w = oDone_r;

		en_w = 1;
	end
	
	else if(state_r == S_DELAY) begin
		start_w = start_r;
		oDone_w = oDone_r;
		en_w = en_r;

		counter_w = counter_r + 1;
	end
	
	else if(state_r == S_DONE) begin
		counter_w = 0;
		start_w = 0;
		oDone_w = 1;
		en_w = 0;
	end
	else begin
		if(ctrl_Start) begin
			counter_w = counter_r;
			en_w = en_r;

			start_w = 1;
			oDone_w = 0;
		end
		else begin
			counter_w = counter_r;
			start_w = start_r;
			oDone_w = oDone_r;
			en_w = en_r;
		end
	end
end

always_ff@(posedge iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		state_r <= S_IDLE;
		counter_r <= 0;
		start_r <= 0;
		oDone_r <= 0;
		en_r <= 0;
	end
	else begin
		state_r <= state_w;
		counter_r <= counter_w;
		start_r <= start_w;
		oDone_r <= oDone_w;
		en_r <= en_w;
	end
end

endmodule
