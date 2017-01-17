module Initialize (
	input i_clk,
	input i_rst,
	output o_sclk,
	inout o_sdat,
	output o_finish,
	output [3:0] o_index //???
);

logic finished, i2c_finished, start_r, start_w;
logic [3:0] index_r, index_w;
logic [23:0] i2c_data_r, i2c_data_w;

assign o_finish = finished;
assign o_index = index_r;

I2cSender #(.BYTE(3)) i2c0 (
	.i_start(start_w),      // start_r ??
	.i_dat(i2c_data_r),
	.i_clk(i_clk),
	.i_rst(i_rst),
	.o_finished(i2c_finished),
	.o_sclk(o_sclk),
	.o_sdat(o_sdat)
);

always_comb begin
	if ((i2c_finished == 1) && (index_r == 10)) begin
		start_w = 0;
		i2c_data_w = 0; 
		finished = 1;
		index_w = index_r + 1;
	end

	else if (i2c_finished == 1) begin
		finished = 0;
		index_w = index_r + 1;
		
		case(index_r)
			0 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000000010010111;
			end
			1 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000001010010111;
			end
			2 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000010001111001;
			end
			3 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000011001111001;
			end
			4 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000100000010101;
			end
			5 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000101000000000;
			end
			6 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000110000000000;
			end
			7 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000000111001000010;
			end
			8 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000001000000011001;
			end
			9 : begin
			start_w = 1;
			i2c_data_w = 24'b001101000001001000000001;
			end
			default : begin
			start_w = start_r;
			i2c_data_w = i2c_data_r;
			end
		endcase
	end

	else begin
		finished = 0;
		index_w = index_r;
		i2c_data_w = i2c_data_r; 
		start_w = 0;
	end
end

always_ff@(posedge i_clk or negedge i_rst) begin 
	if (!i_rst) begin
		start_r <= 0;
		index_r <= 0;
		i2c_data_r <= 0;
	end
	else begin
		start_r <= start_w;
		index_r <= index_w;
		i2c_data_r <= i2c_data_w;
	end
end

endmodule
