`timescale 1ns/100ps

module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;

	logic clk, sta, rst, sclk, fin_Sender,
		rst_Initial, sta_Iniital, fin_Initial;
	logic [23:0] data; 
	wire sdat;
	initial clk = 0;
	always #HCLK clk = ~clk;
	
	I2cInitial Initial(
		.in_start(sta),
		.in_clk(clk),
		.in_rst(rst),
		.in_finished(fin_Sender),
		.out_rst(rst_Initial),
		.out_start(sta_Iniital),
		.out_data(data),
		.out_finished(fin_Initial)	
	);
	I2cSender #(.BYTE(3))Sender(
		.i_clk(clk),
		.i_rst(rst_Initial),
		.i_start(sta_Iniital),
		.i_dat(data),
		.o_finished(fin_Sender),
		.o_sclk(sclk),
		.o_sdat(sdat)
	);

	initial begin
		$fsdbDumpfile("lab3_i2cInitial.fsdb");
		$fsdbDumpvars;
		rst = 1;
		#(2*CLK)
		rst = 0;
		#(2*CLK)
		rst = 1;
		for (int j = 0; j < 3; j++) begin
			@(posedge clk);
		end
		
		/*sta = 1;
		#(CLK);
		sta = 0;
		#(150*CLK);
		*/
		sta <= 1;
		@(posedge clk)
		sta <= 0;
		@(posedge fin_Initial)
		// again
		/*
		@(posedge clk)
		sta <= 1;
		@(posedge clk)
		sta <= 0;
		@(posedge fin)
		*/
		#(10*CLK)
		
		$finish;
	end

	initial begin
		#(10000*CLK)
		$display("Too slow, abort.");
		$finish;
	end
	
	

endmodule
