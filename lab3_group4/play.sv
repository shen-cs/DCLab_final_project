 module PLAY(
    //total reset signal
    input i_rst,
    //clock signal
    input i_clk,
    //key, sw
	input i_stop,
	input i_playorpause,
	input i_spdup,
    input i_spddown,
	input i_record,	//SW[0], play(0), record(1)
    input i_interpolation, //SW[1]
    
    //outputs to LCD
    output [1:0] o_state,
    output [3:0] o_play_speed,
    
    //  inputs/outputs from/to codec
    input i_aud_DAClrck, //AUD_DACCLRCK
    output o_aud_DACdat, //AUD_DACDAT
    
    //  inputs/outputs from/to SRAM Communicator
    output o_sram_start,
    input [15:0]i_sram_data,
	input i_sram_play_complete,
    output [3:0] o_speedup_parameter
	 
);
localparam LEFT = 0;
localparam RIGHT = 1;

localparam STOP = 0;
localparam PLAY_LEFT = 1;
localparam PLAY_RIGHT = 2;
localparam PAUSE = 3;

logic [1:0] state_w, state_r;
logic [3:0] play_speed_w, play_speed_r;
logic [2:0]  speed_down_wait_count;
logic [15:0] sram_data_prev_r, sram_data_prev_w;
logic [15:0] data_to_play_r, data_to_play_w;
logic [15:0] sssss, sram_data_prev;
logic [3:0]  speedup_parameter_r, speedup_parameter_w;

// data to codec
logic aud_DACdata_r, aud_DACdata_w;
    
logic [15:0] sram_DataL_r, sram_DataL_w, sram_DataR_r, sram_DataR_w;
    
// controling signals for other modules
logic sram_start, prev_start;

logic aud_DACdata;


assign o_sram_start = sram_start;
assign o_aud_DACdat = aud_DACdata;
assign o_state = state_r;
assign o_play_speed = play_speed_r;
assign o_speedup_parameter = speedup_parameter_r;


always_comb begin

// sent data, state transition
	case (state_r) 
		STOP : begin
			if ((i_record == 1)||(i_sram_play_complete == 1))
			state_w = state_r;
			else if (i_playorpause == 1) begin
				if (i_aud_DAClrck == 0)                 //Left
				state_w = PLAY_LEFT;
				else									//Right
				state_w = PLAY_RIGHT;
			end
			else
			state_w = state_r;
		end
		
		PLAY_LEFT : begin
			if ((i_stop == 1)||(i_record == 1)||(i_sram_play_complete == 1))
			state_w = STOP;
			else if (i_playorpause == 1)
			state_w = PAUSE;
			else if (i_aud_DAClrck == 1) 			    //Right
			state_w = PLAY_RIGHT;
			else
			state_w = state_r;

		end
		
		PLAY_RIGHT : begin
			if ((i_stop == 1)||(i_record == 1)||(i_sram_play_complete == 1))
			state_w = STOP;
			else if (i_playorpause == 1)
			state_w = PAUSE;
			else if (i_aud_DAClrck == 0) 			    //Left
			state_w = PLAY_LEFT;
			else
			state_w = state_r;
		end
		
		PAUSE : begin
			if ((i_record == 1)||(i_stop == 1))
			state_w = STOP;
			else if (i_playorpause == 1) begin
				if (i_aud_DAClrck == 0)					//Left
				state_w = PLAY_LEFT;
				else
				state_w = PLAY_RIGHT;					//Right
			end
			else 
			state_w = state_r;
		end
	endcase
end

//  
always_comb begin
	case(state_r)
		PLAY_LEFT :
			if (i_aud_DAClrck == RIGHT) begin
				if (speed_down_wait_count == 0)
					prev_start = 1;
				else 
					prev_start = 0;

				sram_start = 0;
				aud_DACdata = 0;								// Original is "aud_DACdata_r"
				sram_DataL_w = sram_DataL_r;
				sram_DataR_w = sram_DataR_r;
			end
				
			else begin
				prev_start = 0;
				sram_start = 0;
				aud_DACdata = sram_DataL_r[15];
				sram_DataL_w = sram_DataL_r << 1;
				sram_DataR_w = data_to_play_r;					// 銝?
			end

		PLAY_RIGHT :
			if (i_aud_DAClrck == LEFT) begin
				if(speed_down_wait_count == 0)
					sram_start = 1;								// It obtains values from SRAM when state == play_right
				else 
					sram_start = 0;
				
				prev_start = 0;
				aud_DACdata = 0;								// Original is "aud_DACdata_r"
				sram_DataR_w = sram_DataR_r;
				sram_DataL_w = sram_DataL_r;
			end

			else begin
				prev_start = 0;
				sram_start = 0;
				aud_DACdata = sram_DataR_r[15];
				sram_DataR_w = sram_DataR_r << 1;
				sram_DataL_w = data_to_play_r;					// 銝?
			end 


		default: begin
				prev_start = 0;
				sram_start = 0;
				aud_DACdata = 0;
				sram_DataR_w = 0;
				sram_DataL_w = 0;
				end
	endcase
end


//play speed

always_comb begin
	if(i_record == 0 && i_spdup == 1 && play_speed_r < 14)
		play_speed_w = play_speed_r + 1;
	else if (i_record == 0 && i_spddown == 1 && play_speed_r > 0)
		play_speed_w = play_speed_r - 1;
	else 
		play_speed_w = play_speed_r;
end

// speedup parameter

always_comb begin
	if( (state_r == PLAY_RIGHT || state_r == PLAY_LEFT) && play_speed_r > 7)			// 
		speedup_parameter_w = play_speed_r - 6;
	else 
		speedup_parameter_w = 1; 								// tate != 1隞暻潔摮
end

// Data to be played

always_comb begin
	if (play_speed_r > 6) begin					// Normal or speed-up mode
		data_to_play_w[15] = i_sram_data[15];
		data_to_play_w[14] = i_sram_data[15];
		data_to_play_w[13:0] = i_sram_data[14:1];	// Some problems in here
	end	
	else begin									// Slow down mode
		if (i_interpolation == 0) begin 		// Zero interpolation
			if (speed_down_wait_count == 0)
				data_to_play_w = i_sram_data;
			else
				data_to_play_w = data_to_play_r;
		end
		else begin								// Linear interpolation
			if (speed_down_wait_count == 0) begin	
				data_to_play_w = sram_data_prev_r;
			end
			else begin
				if (sram_data_prev[15] == 0) begin
					if (i_sram_data[15] == 0)
						data_to_play_w = i_sram_data - speed_down_wait_count*((i_sram_data - sram_data_prev)/(8 - play_speed_r));
					else
						data_to_play_w = speed_down_wait_count *( sram_data_prev/(8 - play_speed_r)) + ~(((8 - play_speed_r) - speed_down_wait_count) * ((~i_sram_data+1)/(8 - play_speed_r))) + 1;
				end
				else begin
					if (i_sram_data[15] == 0)
						data_to_play_w =  ~(speed_down_wait_count * ((~sram_data_prev+1)/ (8 - play_speed_r))) + ((8 - play_speed_r) - speed_down_wait_count) * (i_sram_data/(8 - play_speed_r)) + 1;
					else
						data_to_play_w =  ~(speed_down_wait_count * ((~sram_data_prev+1)/ (8 - play_speed_r))) + ~(((8 - play_speed_r) - speed_down_wait_count) * ((~i_sram_data+1)/(8 - play_speed_r))) + 2;
				end
			end
		end
	end
end

// Handling sram_data_prev

always_comb begin
	if (prev_start) begin
		sram_data_prev_w = i_sram_data;
	end
	else begin
		sram_data_prev_w = sram_data_prev_r;
	end
	sssss = sram_data_prev_r;
end

// Handling speed_down_wait_count

always_ff@ (negedge i_aud_DAClrck) begin
	if (!i_rst) begin
		speed_down_wait_count <= 0;
	end
	else if (((state_r == PLAY_LEFT)||(state_r == PLAY_RIGHT))&&(play_speed_r < 7))begin
		if (speed_down_wait_count == 0) 
			speed_down_wait_count <= 7 - play_speed_r;
		else
			speed_down_wait_count <= speed_down_wait_count - 1;
	end
	else begin
		speed_down_wait_count <= 0;
	end
end

always_ff@(posedge i_clk) begin 
	if (!i_rst) begin
	state_r <= STOP;
	play_speed_r <= 7;
	speedup_parameter_r <= 1;
	sram_DataL_r <= 16'b0;
	sram_DataR_r <= 16'b0;
	sram_data_prev_r <= 16'b0;
	data_to_play_r <= 16'b0;
	end

	else begin
	state_r <= state_w;
	play_speed_r <= play_speed_w;
	speedup_parameter_r <= speedup_parameter_w;
	sram_DataL_r <= sram_DataL_w;
	sram_DataR_r <= sram_DataR_w;
	sram_data_prev_r <= sram_data_prev_w;
	data_to_play_r <= data_to_play_w;
	end 
end

always_ff@ (negedge i_aud_DAClrck) begin
	sram_data_prev <= sssss;
end

endmodule
