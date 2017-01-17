module I2cSender #(parameter BYTE=3) (
	input i_start,
	input [BYTE*8-1:0] i_dat,
	input i_clk,
	input i_rst,
	output o_finished,
	output o_sclk,
	inout o_sdat

);

logic [2:0] state_w, state_r;
logic [4:0] counter_sendBit_w, counter_sendBit_r;
logic [3:0] counter_send_w, counter_send_r;
logic [1:0] counter_ack_w, counter_ack_r;
logic [1:0] counter_sclk_w, counter_sclk_r;
logic sclk_w, sclk_r;
logic o_e, SDAT;
logic finished;

localparam stop = 0;
localparam start = 1;
localparam send = 2;
localparam ack = 3;
localparam finish = 4;

assign o_sdat = o_e ? SDAT : 1'bz;
assign o_sclk = sclk_r;
assign o_finished = finished;

always_comb begin
	//default
	counter_send_w = counter_send_r;
	counter_sendBit_w = counter_sendBit_r;
	counter_ack_w = counter_ack_r;
	counter_sclk_w = counter_sclk_r;
	sclk_w = sclk_r;
	state_w = state_r;
	o_e = 1;
	finished = 0;
	case (state_r)
		stop : begin
			SDAT = 1;
			sclk_w = 1;
			finished = 1;
			if (i_start) begin
			state_w = start;
			end
			else begin
			state_w = state_r;
			end
		end
		
		start : begin
			SDAT = 0;
			//counter_sclk_w = counter_sclk_r + 1;
			if (counter_sclk_r == 0) begin
				counter_sclk_w = counter_sclk_r + 1;
				sclk_w = 0;
			end
			else if (counter_sclk_r == 1) begin
				counter_sclk_w = counter_sclk_r + 1;
				sclk_w = 0;
			end
			else begin
				counter_sclk_w = 0;
				sclk_w = 1;
			end
			if ((o_sdat == 0)&&(o_sclk == 0)) begin
				counter_sendBit_w = 0;
				state_w = send;
			end
			else begin
				state_w = state_r;
			end
		end
		
		send : begin
			if(counter_sclk_r == 1) begin
				if(counter_sendBit_r == 0) begin 
					counter_sendBit_w = counter_sendBit_r;
				end
				else begin
					counter_sendBit_w = counter_sendBit_r - 1;
				end
				counter_send_w = counter_send_r + 1;
			end
			SDAT = i_dat[counter_sendBit_r];
			if (counter_sclk_r == 0) begin
				counter_sclk_w = counter_sclk_r + 1;
				sclk_w = 0;
			end
			else if (counter_sclk_r == 1) begin
				counter_sclk_w = counter_sclk_r + 1;
				sclk_w = 0;
			end
			else begin
				counter_sclk_w = 0;
				sclk_w = 1;
			end
			if (counter_send_w == 8) begin
				o_e = 0;
				state_w = ack;
			end
			else begin
				state_w = state_r;
			end
		end
      
		ack : begin
			counter_send_w = 0;
//		counter_ack_w = counter_ack_r + 1;
			counter_sendBit_w = counter_sendBit_r;
			o_e = 0;
			SDAT = 0;
			finished = 0;
			if (counter_sclk_r == 0) begin
				counter_sclk_w = counter_sclk_r + 1;
				counter_ack_w = counter_ack_r;
				sclk_w = 0;
			end
			else if (counter_sclk_r == 1) begin
				counter_sclk_w = counter_sclk_r + 1;
				counter_ack_w = counter_ack_r + 1;
				sclk_w = 0;
			end
			else begin
				counter_sclk_w = 0;
				counter_ack_w = counter_ack_r;
				sclk_w = 1;
			end
			if (counter_sclk_r == 1) begin
				if (counter_ack_r == 2)
				state_w = finish;
				else
				state_w = send;
			end
			else begin
			state_w = state_r;
			end
		end
		
		finish : begin
			counter_send_w = 0;
			counter_ack_w = 0;
			counter_sclk_w = 0;
			counter_sendBit_w = 23;
			o_e = 1;
			SDAT = 0;
			sclk_w = 1;
			finished = 0;
			if ((o_sdat == 0)&&(o_sclk == 1)) begin
            state_w = stop;
			end
			else begin
			state_w = state_r;
			end
		end
		
		default : begin
			counter_send_w = counter_send_r;
			counter_ack_w = counter_ack_r;
			counter_sclk_w = counter_sclk_r;
			counter_sendBit_w = counter_sendBit_r;
			o_e = 0;
			SDAT = 1;
			sclk_w = 1;
			finished = 1;
			state_w = state_r;
		end
	endcase
	
	// if(state_r == stop) begin
	// 	counter_send_w = counter_send_r;
	// 	counter_ack_w = counter_ack_r;
	// 	counter_sclk_w = counter_sclk_r;
	// 	counter_sendBit_w = counter_sendBit_r;
	// 	o_e = 0;
	// 	SDAT = 1;
	// 	sclk_w = 1;
	// 	finished = 1;
	// end
	// else if(state_r == start) begin
	// 	counter_send_w = counter_send_r;
	// 	counter_ack_w = counter_ack_r;
	// 	counter_sendBit_w = counter_sendBit_r;
	// 	o_e = 0;
	// 	SDAT = 0;
	// 	finished = 0;
	// 	if (counter_sclk_r == 0) begin
	// 	counter_sclk_w = counter_sclk_r + 1;
	// 	sclk_w = 0;
	// 	end
	// 	else if (counter_sclk_r == 1) begin
	// 	counter_sclk_w = counter_sclk_r + 1;
	// 	sclk_w = 0;
	// 	end
	// 	else begin
	// 	counter_sclk_w = 0;
	// 	sclk_w = 1;
	// 	end
	// end
// 	else if(state_r == send) begin
// //      	counter_send_w = counter_send_r + 1;
// 		counter_ack_w = counter_ack_r;
// 		if (counter_sclk_r == 1) begin
// 			if (counter_sendBit_r == 0) begin
// 				counter_sendBit_w = counter_sendBit_r;
// 			end
// 			else begin
// 				counter_sendBit_w = counter_sendBit_r - 1;
// 			end
// 			counter_send_w = counter_send_r + 1;
// 		end
// 		else begin
// 			counter_sendBit_w = counter_sendBit_r;
// 			counter_send_w = counter_send_r;
// 		end
// 		o_e = 0;
// 		SDAT = i_dat[counter_sendBit_r];
// 		finished = 0;
// 		if (counter_sclk_r == 0) begin
// 			counter_sclk_w = counter_sclk_r + 1;
// 			sclk_w = 0;
// 		end
// 		else if (counter_sclk_r == 1) begin
// 			counter_sclk_w = counter_sclk_r + 1;
// 			sclk_w = 0;
// 		end
// 		else begin
// 			counter_sclk_w = 0;
// 			sclk_w = 1;
// 		end
// 	end
// 	else if (state_r == ack) begin
// 		counter_send_w = 0;
// //		counter_ack_w = counter_ack_r + 1;
// 		counter_sendBit_w = counter_sendBit_r;
// 		o_e = 0;
// 		SDAT = 0;
// 		finished = 0;
// 		if (counter_sclk_r == 0) begin
// 		counter_sclk_w = counter_sclk_r + 1;
// 		counter_ack_w = counter_ack_r;
// 		sclk_w = 0;
// 		end
// 		else if (counter_sclk_r == 1) begin
// 		counter_sclk_w = counter_sclk_r + 1;
// 		counter_ack_w = counter_ack_r + 1;
// 		sclk_w = 0;
// 		end
// 		else begin
// 		counter_sclk_w = 0;
// 		counter_ack_w = counter_ack_r;
// 		sclk_w = 1;
// 		end
// 	end
	// else if (state_r == finish) begin
	// 	counter_send_w = 0;
	// 	counter_ack_w = 0;
	// 	counter_sclk_w = 0;
	// 	counter_sendBit_w = 23;
	// 	o_e = 1;
	// 	SDAT = 0;
	// 	sclk_w = 1;
	// 	finished = 0;
	// end
	// else begin
	// 	counter_send_w = counter_send_r;
	// 	counter_ack_w = counter_ack_r;
	// 	counter_sclk_w = counter_sclk_r;
	// 	counter_sendBit_w = counter_sendBit_r;
	// 	o_e = 0;
	// 	SDAT = 1;
	// 	sclk_w = 1;
	// 	finished = 1;
	// end
end

always_ff@(posedge i_clk) begin 
	if (!i_rst) begin
	state_r <= stop;
	counter_send_r <= 0;
	counter_ack_r <= 0;
	counter_sclk_r <= 0;
	counter_sendBit_r <= 23;
	sclk_r = 1;
	end
	else begin
	state_r <= state_w;
	counter_send_r <= counter_send_w;
	counter_ack_r <= counter_ack_w;
	counter_sclk_r <= counter_sclk_w;
	counter_sendBit_r <= counter_sendBit_w;
	sclk_r <= sclk_w;
	end
end
endmodule
