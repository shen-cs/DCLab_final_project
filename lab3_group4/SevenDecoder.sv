// this file include the function of SevenDec(rec_state, play_state, key[0], SW[0], speedup_parameter), SevenHex(playspeed), Seventxt decoder, 
//why this lab is so fucking difficult >_<
	/* The layout of seven segment display, 1: dark
	 *    00
	 *   5  1
	 *    66
	 *   4  2
	 *    33
	 */
module SevenDecoder(
	input [1:0] i_dec_rec,
	output logic [6:0] o_dec_rec_seven,			// hex[0]

	input [1:0] i_dec_pla,
	output logic [6:0] o_dec_pla_seven,			// hex[1]

	input i_dec_key,
	output logic [6:0] o_dec_key_seven,			// hex[2]

	input i_dec_sw,
	output logic [6:0] o_dec_sw_seven,			// hex[3]

	input [3:0] i_dec_speed,					// speedup parameter
	output logic [6:0] o_dec_speed_seven,		// hex[6]

	input [3:0] i_hex,							// play_speed
	output logic [6:0] o_seven_ten,         // hex[5]
	output logic [6:0] o_seven_one,		    // hex[4]

//	input [1:0]i_play_state,
//	input [1:0]i_rec_state,
	output logic [6:0] o_txt_seven			    // hex[7]
);
	parameter D0 = 7'b1000000;
	parameter D1 = 7'b1111001;
	parameter D2 = 7'b0100100;
	parameter D3 = 7'b0110000;
	parameter D4 = 7'b0011001;
	parameter D5 = 7'b0010010;
	parameter D6 = 7'b0000010;
	parameter D7 = 7'b1011000;
	parameter D8 = 7'b0000000;
	parameter D9 = 7'b0010000;
	parameter D_OFF = 7'b0000000;

	parameter T0 = 7'b0001100;   			// P  play mode
	parameter T1 = 7'b0001000;				// R  record mode
	parameter T2 = 7'b1001000;				// A  pause mode
	parameter T3 = 7'b0010010;				// S  stop mode
	parameter T4 = 7'b1000001; 				// U  unknown mode					


// rec 
	always_comb begin
		case (i_dec_rec)
			4'd0: o_dec_rec_seven = D0;
			4'd1: o_dec_rec_seven = D1;
			4'd2: o_dec_rec_seven = D2;   
            default: o_dec_rec_seven = D_OFF;
		endcase
	end
// rec end

// pla 
	always_comb begin
		case (i_dec_pla)
			4'd0: o_dec_pla_seven = D0;
			4'd1: o_dec_pla_seven = D1;
			4'd3: o_dec_pla_seven = D3;
            default: o_dec_pla_seven = D_OFF;
		endcase
	end
// pla end

// key
	always_comb begin
		case (i_dec_key)
			4'd0: o_dec_key_seven = D0;
			4'd1: o_dec_key_seven = D1;
			4'd2: o_dec_key_seven = D2;
			4'd3: o_dec_key_seven = D3;
			4'd4: o_dec_key_seven = D4;
			4'd5: o_dec_key_seven = D5;
			4'd6: o_dec_key_seven = D6;
			4'd7: o_dec_key_seven = D7;
			4'd8: o_dec_key_seven = D8;
			4'd9: o_dec_key_seven = D9;
            default: o_dec_key_seven = D_OFF;		
		endcase
	end
// key end

// sw 
	always_comb begin
		case (i_dec_sw)
			4'd0: o_dec_sw_seven = D0;
			4'd1: o_dec_sw_seven = D1;
            default: o_dec_sw_seven = D_OFF;
		endcase
	end
// sw end

// speed 
	always_comb begin
		case (i_dec_speed)
			4'd0: o_dec_speed_seven = D0;
			4'd1: o_dec_speed_seven = D1;
			4'd2: o_dec_speed_seven = D2;
			4'd3: o_dec_speed_seven = D3;
			4'd4: o_dec_speed_seven = D4;
			4'd5: o_dec_speed_seven = D5;
			4'd6: o_dec_speed_seven = D6;
			4'd7: o_dec_speed_seven = D7;
			4'd8: o_dec_speed_seven = D8;
			4'd9: o_dec_speed_seven = D9;
            default: o_dec_speed_seven = D_OFF;
		endcase
	end
// speed end


// hex

	always_comb begin
		case(i_hex)
			4'h0: begin o_seven_ten = D0; o_seven_one = D0; end
			4'h1: begin o_seven_ten = D0; o_seven_one = D1; end
			4'h2: begin o_seven_ten = D0; o_seven_one = D2; end
			4'h3: begin o_seven_ten = D0; o_seven_one = D3; end
			4'h4: begin o_seven_ten = D0; o_seven_one = D4; end
			4'h5: begin o_seven_ten = D0; o_seven_one = D5; end
			4'h6: begin o_seven_ten = D0; o_seven_one = D6; end
			4'h7: begin o_seven_ten = D0; o_seven_one = D7; end
			4'h8: begin o_seven_ten = D0; o_seven_one = D8; end
			4'h9: begin o_seven_ten = D0; o_seven_one = D9; end
			4'ha: begin o_seven_ten = D1; o_seven_one = D0; end
			4'hb: begin o_seven_ten = D1; o_seven_one = D1; end
			4'hc: begin o_seven_ten = D1; o_seven_one = D2; end
			4'hd: begin o_seven_ten = D1; o_seven_one = D3; end
			4'he: begin o_seven_ten = D1; o_seven_one = D4; end
			4'hf: begin o_seven_ten = D1; o_seven_one = D5; end
			default: begin o_seven_ten = D8; o_seven_one = D8; end
		endcase
	end
// hex end

// txt 
	always_comb begin
		//stop -> S
		if(i_dec_rec == 0 && i_dec_pla == 0) begin
			o_txt_seven = T3;
		end
		//pause -> A
		else if(i_dec_rec == 2 || i_dec_pla == 3) begin
			o_txt_seven = T2;
		end
		//record -> R
		else if(i_dec_rec == 1) begin
			o_txt_seven = T1;
		end
		//play -> P
		else if(i_dec_pla == 1 || i_dec_pla == 2) begin
			o_txt_seven = T0;
		end
		//unknown -> U
		else begin
			o_txt_seven = T4;
		end
	end
// txt end

endmodule


