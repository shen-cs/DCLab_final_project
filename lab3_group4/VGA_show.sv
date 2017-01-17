module VGA_SHOW_E (
	input i_clk,
	input i_rst,
	input [11:0] x,
	input [11:0] y,
	input [3:0] i_size,
	input [1:0] i_direction,
	input i_done,
	output o_e_chart_color


);

localparam ZERO_ONE = 0;
localparam ZERO_TWO = 1;
localparam ZERO_THREE = 2;
localparam ZERO_FOUR = 3;
localparam ZERO_FIVE = 4;
localparam ZERO_SIX = 5;
localparam ZERO_SEVEN = 6;
localparam ZERO_EIGHT = 7;
localparam ZERO_NINE = 8;
localparam ONE_ZERO = 9;
localparam ONE_TWO = 10;
localparam ONE_FIVE = 11;
localparam TWO_ZERO = 12;

localparam UP = 0;
localparam DOWN = 1;
localparam LEFT = 2;
localparam RIGHT = 3;

localparam X_location = 260;
localparam Y_location = 220;


logic  o_e_chart_color_r, o_e_chart_color_w;


assign o_e_chart_color = o_e_chart_color_r;

task point_up;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((x >= (translator_x + string_up) && x <= (translator_x + string_up + interval)) || (x >= (translator_x + weight - string_down - interval) && x <= (translator_x + weight - string_down))) && y <= (translator_y + weight - string_up))
			o_e_chart_color_w = 1;
		else 
			o_e_chart_color_w = 0;		
	end

	else 
		o_e_chart_color_w = 1;	 
endtask

task point_down;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((x >= (translator_x + string_up) && x <= (translator_x + string_up + interval)) || (x >= (translator_x + weight - string_down - interval) && x <= (translator_x + weight - string_down))) && y >= (translator_y + string_up))
			o_e_chart_color_w = 1;
		else
			o_e_chart_color_w = 0;
	end

	else 
		o_e_chart_color_w = 1;	

endtask

task point_left;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((y >= (translator_y + string_up) && y <= (translator_y + string_up + interval)) || (y >= (translator_y + weight - string_down - interval) && y <= (translator_y + weight - string_down))) && x <= (translator_x + weight - string_up))
			o_e_chart_color_w = 1;
		else
			o_e_chart_color_w = 0;	
	end

	else 
		o_e_chart_color_w = 1;	

endtask

task point_right;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((y >= (translator_y + string_up) && y <= (translator_y + string_up + interval)) || (y >= (translator_y + weight - string_down - interval) && y <= (translator_y + weight - string_down))) && x >= (translator_x + string_up))
			o_e_chart_color_w = 1;
		else
			o_e_chart_color_w = 0;	
	end

	else 
		o_e_chart_color_w = 1;	

endtask							//   0		  7
								//   __		  __
								// 1|__|2  8 |__| 9	
								// 4|__|5  11|__| 12
								//   3 6  14* 10 13

task show_0;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_1;
	if(x > 200 && x <= 206 && y > 146 && y <= 237)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask	

task show_2;
	if(x > 294 && x <= 300 && y > 146 && y <= 237)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_3;
	if(x > 200 && x <= 300 && y > 237 && y <= 243)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;
endtask

task show_4;
	if(x > 200 && x <= 206 && y > 243 && y <= 334)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_5;
	if(x > 294 && x <= 300 && y > 243 && y <= 334)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_6;
	if(x > 200 && x <= 300 && y > 334 && y <= 340)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;
endtask

task show_7;
	if(x > 340 && x <= 440 && y > 140 && y <= 146)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;
endtask

task show_8;
	if(x > 340 && x <= 346 && y > 146 && y <= 237)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_9;
	if(x > 434 && x <= 440 && y > 146 && y <= 237)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_10;
	if(x > 340 && x <= 440 && y > 237 && y <= 243)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;
endtask

task show_11;
	if(x > 340 && x <= 346 && y > 243 && y <= 334)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_12;
	if(x > 434 && x <= 440 && y > 243 && y <= 334)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;	
endtask

task show_13;
	if(x> 340 && x <= 440 && y > 334 && y <= 340)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;
endtask
task show_14;
	if(x >= 317 && x <=322 && y > 334 && y <= 340)
		o_e_chart_color_w = 0;
	else
		o_e_chart_color_w = 1;
endtask


always_comb begin
	o_e_chart_color_w = o_e_chart_color_r;

	case(i_size)
		ZERO_ONE: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_12();
				show_9();
			end

			else begin
				case(i_direction)
					UP: 
						point_up(120,24,24,24,24,X_location,Y_location);
					DOWN:
						point_down(120,24,24,24,24,X_location,Y_location);
					LEFT:
						point_left(120,24,24,24,24,X_location,Y_location);
					RIGHT:
						point_right(120,24,24,24,24,X_location,Y_location);
				endcase
			end
			end

		ZERO_TWO: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_9();
				show_10();
				show_11();
				show_13();
			end

			else begin
				case(i_direction)
					UP: 
						point_up(60,12,12,12,12,X_location,Y_location);
					DOWN:
						point_down(60,12,12,12,12,X_location,Y_location);
					LEFT:
						point_left(60,12,12,12,12,X_location,Y_location);
					RIGHT:
						point_right(60,12,12,12,12,X_location,Y_location);
				endcase
			end
			end

		ZERO_THREE: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_9();
				show_10();
				show_12();
				show_13();
			end

			else begin		
				case(i_direction)
					UP: 
						point_up(40,8,8,8,8,X_location,Y_location);
					DOWN:
						point_down(40,8,8,8,8,X_location,Y_location);
					LEFT:
						point_left(40,8,8,8,8,X_location,Y_location);
					RIGHT:
						point_right(40,8,8,8,8,X_location,Y_location);
				endcase
			end
			end

		ZERO_FOUR: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_8();
				show_9();
				show_10();
				show_12();
			end

			else begin	
			case(i_direction)
				UP: 
					point_up(30,6,6,6,6,X_location,Y_location);
				DOWN:
					point_down(30,6,6,6,6,X_location,Y_location);
				LEFT:
					point_left(30,6,6,6,6,X_location,Y_location);
				RIGHT:
					point_right(30,6,6,6,6,X_location,Y_location);
			endcase
			end
			end

		ZERO_FIVE: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_8();
				show_10();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(24,5,4,5,5,X_location,Y_location);
				DOWN:
					point_down(24,5,4,5,5,X_location,Y_location);
				LEFT:
					point_left(24,5,4,5,5,X_location,Y_location);
				RIGHT:
					point_right(24,5,4,5,5,X_location,Y_location);
			endcase
			end
			end

		ZERO_SIX: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_8();
				show_10();
				show_11();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(20,4,4,4,4,X_location,Y_location);
				DOWN:
					point_down(20,4,4,4,4,X_location,Y_location);
				LEFT:
					point_left(20,4,4,4,4,X_location,Y_location);
				RIGHT:
					point_right(20,4,4,4,4,X_location,Y_location);
			endcase
			end
			end

		ZERO_SEVEN: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_9();
				show_12();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(17,3,3,3,4,X_location,Y_location);
				DOWN:
					point_down(17,3,3,3,4,X_location,Y_location);
				LEFT:
					point_left(17,3,3,3,4,X_location,Y_location);
				RIGHT:
					point_right(17,3,3,3,4,X_location,Y_location);
			endcase
			end
			end

		ZERO_EIGHT: begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_8();
				show_9();
				show_10();
				show_11();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(15,3,3,3,3,X_location,Y_location);
				DOWN:
					point_down(15,3,3,3,3,X_location,Y_location);
				LEFT:
					point_left(15,3,3,3,3,X_location,Y_location);
				RIGHT:
					point_right(15,3,3,3,3,X_location,Y_location);
			endcase
			end
			end

		ZERO_NINE:begin
			if(i_done == 1) begin
				show_0();
				show_1();
				show_2();
				show_4();
				show_5();
				show_6();
				show_14();
				show_7();
				show_8();
				show_9();
				show_10();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(13,3,3,3,2,X_location,Y_location);
				DOWN:
					point_down(13,3,3,3,2,X_location,Y_location);
				LEFT:
					point_left(13,3,3,3,2,X_location,Y_location);
				RIGHT:
					point_right(13,3,3,3,2,X_location,Y_location);
			endcase
			end
			end

		ONE_ZERO: begin
			if(i_done == 1) begin
				show_2();
				show_5();
				show_14();
				show_7();
				show_8();
				show_9();
				show_11();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(12,2,2,2,3,X_location,Y_location);
				DOWN:
					point_down(12,2,2,2,3,X_location,Y_location);
				LEFT:
					point_left(12,2,2,2,3,X_location,Y_location);
				RIGHT:
					point_right(12,2,2,2,3,X_location,Y_location);
			endcase
			end
			end

		ONE_TWO: begin
			if(i_done == 1) begin
				show_2();
				show_5();
				show_14();
				show_7();
				show_9();
				show_10();
				show_11();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(10,2,2,2,2,X_location,Y_location);
				DOWN:
					point_down(10,2,2,2,2,X_location,Y_location);
				LEFT:
					point_left(10,2,2,2,2,X_location,Y_location);
				RIGHT:
					point_right(10,2,2,2,2,X_location,Y_location);
			endcase
			end
			end

		ONE_FIVE: begin
			if(i_done == 1) begin
				show_2();
				show_5();
				show_14();
				show_7();
				show_8();
				show_10();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(8,2,2,2,1,X_location,Y_location);
				DOWN:
					point_down(8,2,2,2,1,X_location,Y_location);
				LEFT:
					point_left(8,2,2,2,1,X_location,Y_location);
				RIGHT:
					point_right(8,2,2,2,1,X_location,Y_location);
			endcase
			end
			end

		TWO_ZERO: begin
			if(i_done == 1) begin
				show_0();
				show_2();
				show_3();
				show_4();
				show_6();
				show_14();
				show_7();
				show_8();
				show_9();
				show_11();
				show_12();
				show_13();
			end

			else begin
			case(i_direction)
				UP: 
					point_up(6,1,2,1,1,X_location,Y_location);
				DOWN:
					point_down(6,1,2,1,1,X_location,Y_location);
				LEFT:
					point_left(6,1,2,1,1,X_location,Y_location);
				RIGHT:
					point_right(6,1,2,1,1,X_location,Y_location);
			endcase
			end
			end
		
		default: 
			o_e_chart_color_w = 100;   // debug

	endcase
end

always_ff @(posedge i_clk or negedge i_rst) begin
	if (~i_rst) begin
		o_e_chart_color_r <= 255;


	end else begin
		o_e_chart_color_r <= o_e_chart_color_w;
	end


end

endmodule
