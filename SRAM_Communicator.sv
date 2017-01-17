module SRAMCommunicator (
    //  CLK, RST, SW
    input   i_clk,
    input   i_rst,  //DLY_RST
    input   i_write,//SW[0] or signal to play(0) or record(1)
    //  from PLAY
    input   i_sound_number, //TODO
    input   i_start_play,              // o_sram_start in Play module
    input   [1:0] i_play_state,		   // o_state ?
    input   [3:0] i_speedup_parameter, // o_speedup_parameter in Play module
    //  from RECORD
    input   i_start_rec,			   // o_sram_start in Record module
    input   i_record_rst,			   // o_sram_reset in Record module, set to 1 when KEY0 is pushed in record mode
    input   [15:0]i_data_write,		   // o_sram_data in Record module
    //  SRAM
    output  [19:0]o_sram_addr,
    inout   [15:0]io_sram_dq,
    output  o_sram_we_n,
    output  o_sram_ce_n,
    output  o_sram_oe_n,
    output  o_sram_lb_n,
    output  o_sram_ub_n,
    //  outputs for PLAY and RECORD
    output  o_full,
    output  o_play_complete
    //DEBUG
    //output[3:0]debug_rec_add,
    //output[3:0]debug_add
);

logic [1:0] state_w, state_r;
logic [19:0] o_sram_addr_r, o_sram_addr_w;				// Current address to read/write
logic [19:0] sram_rec_addr_r, sram_rec_addr_w;			// The address that is recorded so far
logic full_r, full_w, play_complete_r, play_complete_w, sram_ce_n;

logic [1:0] sound_counter; //TODO

logic [19:0] start_play_position;
logic [19:0] end_play_position;

logic [19:0] start_play_1; logic [19:0] end_play_1;
logic [19:0] start_play_2; logic [19:0] end_play_2;
logic [19:0] start_play_3; logic [19:0] end_play_3;
logic [19:0] start_play_4; logic [19:0] end_play_4;

localparam Wait = 0;
localparam Read = 1;
localparam Write = 2;
localparam Delay = 3;

assign o_sram_addr = o_sram_addr_r;
assign io_sram_dq = i_write ? i_data_write : 'bz;
assign o_sram_we_n = !i_write;
assign o_sram_oe_n = 0;
assign  o_sram_ce_n     = sram_ce_n;
assign o_sram_lb_n = 0;
assign o_sram_ub_n = 0;
assign o_full = full_r;
assign o_play_complete = play_complete_r;

always_comb begin
	// State transition
    n_sound_counter = sound_counter; // TODO

    case(i_sound_number)
        1 : begin
            start_play_position = start_play_1; //need this when play->stop
            o_sram_addr_r = start_play_1;
            end_play_position = end_play_1;
        end
        2 : begin
            start_play_position = start_play_2;
            o_sram_addr_r = start_play_2;
            end_play_position = end_play_2;
        end
        3 : begin
            start_play_position = start_play_3;
            o_sram_addr_r = start_play_3;
            end_play_position = end_play_3;
        end
        4 : begin
            start_play_position = start_play_4;
            o_sram_addr_r = start_play_4;
            end_play_position = end_play_4;
        end
        default : begin

        end
    endcase

	case (state_r)
		Wait : begin
			if (i_start_play == 1)
			state_w = Read;
			else if (i_start_rec == 1)
			state_w = Write;
			else
			state_w = state_r;
		end

		Read : begin
			state_w = Delay;
		end

		Write : begin
			state_w = Wait;
		end

		Delay : begin             // Delay one cycle after
			state_w = Wait;
		end
	endcase
	// End of state transition
	// To do in each state
	if (state_r == Wait) begin
		o_sram_addr_w = o_sram_addr_r;
		sram_rec_addr_w = sram_rec_addr_r;
		full_w = full_r;
		play_complete_w = play_complete_r;
		sram_ce_n = 1;					// Set the sram as unselected
	end

	else if (state_r == Read) begin
		o_sram_addr_w = o_sram_addr_r;
		sram_rec_addr_w = sram_rec_addr_r;
		full_w = full_r;
		play_complete_w = play_complete_r;
		sram_ce_n = 0;
	end

	else if (state_r == Write) begin //Starting to record
		if (o_sram_addr_r == 20'hFFFFF) begin	// End of sram address
			o_sram_addr_w = o_sram_addr_r;
			sram_rec_addr_w = sram_rec_addr_r;
			full_w = 1;
		end
		else begin
			/*o_sram_addr_w = o_sram_addr_r + 1;
			if (o_sram_addr_r == sram_rec_addr_r) begin
				sram_rec_addr_w = sram_rec_addr_r + 1; //o_sram_addr updates sram_rec_addr
			end
            else begin
                sram_rec_addr_w = sram_rec_addr_r;
            end */
            sram_rec_addr_w = sram_rec_addr_r + 1;
			full_w = 0;
		end
		sram_ce_n = 0;
		play_complete_w = 0;
	end

	else if (state_r == Delay) begin									// state_r == Delay
		if (( end_play_position - o_sram_addr_r == i_speedup_parameter)||(end_play_position - o_sram_addr_r < i_speedup_parameter))begin   // original <=
			o_sram_addr_w = o_sram_addr_r;
			play_complete_w = 1;
		end
		else begin
			o_sram_addr_w = o_sram_addr_r + i_speedup_parameter;
			play_complete_w = 0;
		end
		sram_ce_n = 0;
		full_w = full_r;
		sram_rec_addr_w = sram_rec_addr_r;
	end

	else begin
		play_complete_w = play_complete_r;
		sram_ce_n = 1;
		full_w = full_r;
		sram_rec_addr_w = sram_rec_addr_r;
		o_sram_addr_w = o_sram_addr_r;
	end
end

always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state_r <= Wait;
		o_sram_addr_r <= 0;
		sram_rec_addr_r <= 0;
		full_r <= 0;
		play_complete_r <= 0;
        //TODO
        sound_counter <= 1;
        start_play_1 <= 20'hFFFFF;
        end_play_1 <= 20'hFFFFF;
        start_play_2 <= 20'hFFFFF;
        end_play_2 <= 20'hFFFFF;
        start_play_3 <= 20'hFFFFF;
        end_play_3 <= 20'hFFFFF;
        start_play_4 <= 20'hFFFFF;
        end_play_4 <= 20'hFFFFF;
	end
	else if (i_record_rst == 1 && i_write == 1) begin 			// pressed KEY0 in record mode, assume this part will only run ONCE (counter)
		state_r <= state_w;										// state_r <= Wait
		//TODO o_sram_addr_r <= 0;
		//TODO sram_rec_addr_r <= 0;

        case(sound_counter)
            1 : begin
                start_play_1 <= 0
                end_play_1 <= sram_rec_addr_w;

                start_play_2 <= sram_rec_addr_w + 1;
                end_play_2 <= sram_rec_addr_w + 1;
            end
            2 : begin
                end_play_2 <= sram_rec_addr_w;

                start_play_3 <= sram_rec_addr_w + 1;
                end_play_3 <= sram_rec_addr_w + 1;
            end
            3 : begin
                end_play_3 <= sram_rec_addr_w;

                start_play_4 <= sram_rec_addr_w + 1;
                end_play_4 <= sram_rec_addr_w + 1;
            end
            4 : begin
                end_play_4 <= sram_rec_addr_w;
            end
        endcase
        n_sound_counter <= sound_counter + 1; //TODO


        o_sram_addr_r <= 0;
        sram_rec_addr_r <= sram_rec_addr_w;
		full_r <= full_w;
		play_complete_r <= play_complete_w;
	end
	else if ((i_play_state == 0)&&(i_write == 0)) begin		// When the state is in Play = Stop and is indicated to play then back to start address
		state_r <= state_w;
		o_sram_addr_r <= start_play_position;
		sram_rec_addr_r <= sram_rec_addr_w;
		full_r <= full_w;
		play_complete_r <= 0;
	end
	else begin
		state_r <= state_w;
		o_sram_addr_r <= o_sram_addr_w;
		sram_rec_addr_r <= sram_rec_addr_w;
		full_r <= full_w;
		play_complete_r <= play_complete_w;
        //n_sound_counter <= sound_counter + 1; //TODO
	end
    sound_counter <= n_sound_counter;
end
endmodule
