module DE2_115(
	input CLOCK_50,
	input CLOCK2_50,
	input CLOCK3_50,
	input ENETCLK_25,
	input SMA_CLKIN,
	output SMA_CLKOUT,
	output [8:0] LEDG,
	output [17:0] LEDR,
	input [3:0] KEY,
	input [17:0] SW,
	//*********************SevenHex******************* 
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	//*********************SevenHex******************* 
    //*********************LCD*******************    
	output LCD_BLON,    
	inout [7:0] LCD_DATA,
	output LCD_EN,
	output LCD_ON,
	output LCD_RS,
	output LCD_RW,
    //*********************LCD*******************
	output UART_CTS,
	input UART_RTS,
	input UART_RXD,
	output UART_TXD,
	inout PS2_CLK,
	inout PS2_DAT,
	inout PS2_CLK2,
	inout PS2_DAT2,
	output SD_CLK,
	inout SD_CMD,
	inout [3:0] SD_DAT,
	input SD_WP_N,
	output [7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_CLK,
	output [7:0] VGA_G,
	output VGA_HS,
	output [7:0] VGA_R,
	output VGA_SYNC_N,
	output VGA_VS,
    //*********************CODEC*******************
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output AUD_DACDAT,
	inout AUD_DACLRCK,
	output AUD_XCK,
	output EEP_I2C_SCLK,
	inout EEP_I2C_SDAT,
	output I2C_SCLK,
	inout I2C_SDAT,
    //*********************CODEC*******************
	output ENET0_GTX_CLK,
	input ENET0_INT_N,
	output ENET0_MDC,
	input ENET0_MDIO,
	output ENET0_RST_N,
	input ENET0_RX_CLK,
	input ENET0_RX_COL,
	input ENET0_RX_CRS,
	input [3:0] ENET0_RX_DATA,
	input ENET0_RX_DV,
	input ENET0_RX_ER,
	input ENET0_TX_CLK,
	output [3:0] ENET0_TX_DATA,
	output ENET0_TX_EN,
	output ENET0_TX_ER,
	input ENET0_LINK100,
	output ENET1_GTX_CLK,
	input ENET1_INT_N,
	output ENET1_MDC,
	input ENET1_MDIO,
	output ENET1_RST_N,
	input ENET1_RX_CLK,
	input ENET1_RX_COL,
	input ENET1_RX_CRS,
	input [3:0] ENET1_RX_DATA,
	input ENET1_RX_DV,
	input ENET1_RX_ER,
	input ENET1_TX_CLK,
	output [3:0] ENET1_TX_DATA,
	output ENET1_TX_EN,
	output ENET1_TX_ER,
	input ENET1_LINK100,
	input TD_CLK27,
	input [7:0] TD_DATA,
	input TD_HS,
	output TD_RESET_N,
	input TD_VS,
	inout [15:0] OTG_DATA,
	output [1:0] OTG_ADDR,
	output OTG_CS_N,
	output OTG_WR_N,
	output OTG_RD_N,
	input OTG_INT,
	output OTG_RST_N,
	input IRDA_RXD,
	output [12:0] DRAM_ADDR,
	output [1:0] DRAM_BA,
	output DRAM_CAS_N,
	output DRAM_CKE,
	output DRAM_CLK,
	output DRAM_CS_N,
	inout [31:0] DRAM_DQ,
	output [3:0] DRAM_DQM,
	output DRAM_RAS_N,
	output DRAM_WE_N,
    //*********************SRAM********************
	output [19:0] SRAM_ADDR,
	output SRAM_CE_N,
	inout [15:0] SRAM_DQ,
	output SRAM_LB_N,
	output SRAM_OE_N,
	output SRAM_UB_N,
	output SRAM_WE_N,
    //*********************SRAM********************
	output [22:0] FL_ADDR,
	output FL_CE_N,
	inout [7:0] FL_DQ,
	output FL_OE_N,
	output FL_RST_N,
	input FL_RY,
	output FL_WE_N,
	output FL_WP_N,
	//////////// GPIO, GPIO connect to D5M - 5M Pixel Camera //////////
	input [11:0] D5M_D,
	input D5M_FVAL,
	input D5M_LVAL,
	input D5M_PIXLCLK,
	output D5M_RESET_N,
	output D5M_SCLK,
	inout D5M_SDATA,
	input D5M_STROBE,
	output D5M_TRIGGER,
	output D5M_XCLKIN,
	//////////// GPIO, GPIO connect to D5M - 5M Pixel Camera //////////
	input HSMC_CLKIN_P1,
	input HSMC_CLKIN_P2,
	input HSMC_CLKIN0,
	output HSMC_CLKOUT_P1,
	output HSMC_CLKOUT_P2,
	output HSMC_CLKOUT0,
	inout [3:0] HSMC_D,
	input [16:0] HSMC_RX_D_P,
	output [16:0] HSMC_TX_D_P,
	inout [6:0] EX_IO
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire	[15:0]	Read_DATA1;
wire	[15:0]	Read_DATA2;

wire	[11:0]	mCCD_DATA;
wire			mCCD_DVAL;
wire			mCCD_DVAL_d;
wire	[15:0]	X_Cont;
wire	[15:0]	Y_Cont;
wire	[9:0]	X_ADDR;
wire	[31:0]	Frame_Cont;
wire			DLY_RST_0;
wire			DLY_RST_1;
wire			DLY_RST_2;
wire			DLY_RST_3;
wire			DLY_RST_4;
wire			Read;
reg		[11:0]	rCCD_DATA;
reg				rCCD_LVAL;
reg				rCCD_FVAL;
wire	[11:0]	sCCD_R;
wire	[11:0]	sCCD_G;
wire	[11:0]	sCCD_B;
wire			sCCD_DVAL;

wire			sdram_ctrl_clk;
wire	[9:0]	oVGA_R;   				//	VGA Red[9:0]
wire	[9:0]	oVGA_G;	 				//	VGA Green[9:0]
wire	[9:0]	oVGA_B;   				//	VGA Blue[9:0]

//power on start
wire             auto_start;

// point detection
wire start_detect;
wire finish_detect;
wire finished;
wire [9:0] center_x;
wire [9:0] center_y;
wire [9:0] vga_x;
wire [9:0] vga_y;

// sound playing
wire [2:0] sound_num;
//reg state_w, state_r;
wire [2:0] mask;
//=======================================================
//  Structural coding
//=======================================================
// D5M
assign	D5M_TRIGGER	=	1'b1;  // tRIGGER
assign	D5M_RESET_N	=	DLY_RST_1;
assign  VGA_CTRL_CLK = ~VGA_CLK;

assign	LEDR		=	SW;
assign	LEDG		=	Y_Cont;
assign	UART_TXD = UART_RXD;

//fetch the high 8 bits
assign  VGA_R = oVGA_R[9:2];
assign  VGA_G = oVGA_G[9:2];
assign  VGA_B = oVGA_B[9:2];
//D5M read 
always@(posedge D5M_PIXLCLK)
begin
	rCCD_DATA	<=	D5M_D;
	rCCD_LVAL	<=	D5M_LVAL;
	rCCD_FVAL	<=	D5M_FVAL;
end

//auto start when power on
assign auto_start = ((KEY[0])&&(DLY_RST_3)&&(!DLY_RST_4))? 1'b1:1'b0;
//Reset module
Reset_Delay			u2	(	.iCLK(CLOCK2_50),
							.iRST(KEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2),
							.oRST_3(DLY_RST_3),
							.oRST_4(DLY_RST_4)
						);
//D5M image capture
CCD_Capture			u3	(	.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(!KEY[3]|auto_start),
							.iEND(!KEY[2]),
							.iCLK(~D5M_PIXLCLK),
							.iRST(DLY_RST_2)
						);
//D5M raw date convert to RGB data
`ifdef VGA_640x480p60
RAW2RGB				u4	(	.iCLK(D5M_PIXLCLK),
							.iRST(DLY_RST_1),
							.iDATA(mCCD_DATA),
							.iDVAL(mCCD_DVAL),
							.oRed(sCCD_R),
							.oGreen(sCCD_G),
							.oBlue(sCCD_B),
							.oDVAL(sCCD_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont)
						);
`else
RAW2RGB				u4	(	.iCLK(D5M_PIXLCLK),
							.iRST_n(DLY_RST_1),
							.iData(mCCD_DATA),
							.iDval(mCCD_DVAL),
							.oRed(sCCD_R),
							.oGreen(sCCD_G),
							.oBlue(sCCD_B),
							.oDval(sCCD_DVAL),
							.iZoom(SW[16]),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont)
						);
`endif
//Frame count display
SEG7_LUT_8 			u5	(	.oSEG0(HEX0),.oSEG1(HEX1),
							.oSEG2(HEX2),.oSEG3(HEX3),
							.oSEG4(HEX4),.oSEG5(HEX5),
							.oSEG6(HEX6),.oSEG7(HEX7),
							.iDIG(Frame_Cont[31:0])
						);

sdram_pll 			u6	(
							.inclk0(CLOCK2_50),
							.c0(sdram_ctrl_clk),
							.c1(DRAM_CLK),
							.c2(D5M_XCLKIN), //25M
`ifdef VGA_640x480p60
							.c3(VGA_CLK)     //25M 
`else
						    .c4(VGA_CLK)     //40M 	
`endif
						);

//SDRam Read and Write as Frame Buffer
Sdram_Control	u7	(	//	HOST Side						
						    .RESET_N(KEY[0]),
							.CLK(sdram_ctrl_clk),

							//	FIFO Write Side 1
							.WR1_DATA({1'b0,sCCD_G[11:7],sCCD_B[11:2]}),
							.WR1(sCCD_DVAL),
							.WR1_ADDR(0),
`ifdef VGA_640x480p60
						    .WR1_MAX_ADDR(640*480/2),
						    .WR1_LENGTH(8'h50),
`else
							.WR1_MAX_ADDR(800*600/2),
							.WR1_LENGTH(8'h80),
`endif							
							.WR1_LOAD(!DLY_RST_0),
							.WR1_CLK(D5M_PIXLCLK),

							//	FIFO Write Side 2
							.WR2_DATA({1'b0,sCCD_G[6:2],sCCD_R[11:2]}),
							.WR2(sCCD_DVAL),
							.WR2_ADDR(23'h100000),
`ifdef VGA_640x480p60
						    .WR2_MAX_ADDR(23'h100000+640*480/2),
							.WR2_LENGTH(8'h50),
`else							
							.WR2_MAX_ADDR(23'h100000+800*600/2),
							.WR2_LENGTH(8'h80),
`endif	
							.WR2_LOAD(!DLY_RST_0),
							.WR2_CLK(D5M_PIXLCLK),

							//	FIFO Read Side 1
						    .RD1_DATA(Read_DATA1),
				        	.RD1(Read),
				        	.RD1_ADDR(0),
`ifdef VGA_640x480p60
						    .RD1_MAX_ADDR(640*480/2),
							.RD1_LENGTH(8'h50),
`else
							.RD1_MAX_ADDR(800*600/2),
							.RD1_LENGTH(8'h80),
`endif
							.RD1_LOAD(!DLY_RST_0),
							.RD1_CLK(~VGA_CTRL_CLK),
							
							//	FIFO Read Side 2
						    .RD2_DATA(Read_DATA2),
							.RD2(Read),
							.RD2_ADDR(23'h100000),
`ifdef VGA_640x480p60
						    .RD2_MAX_ADDR(23'h100000+640*480/2),
							.RD2_LENGTH(8'h50),
`else
							.RD2_MAX_ADDR(23'h100000+800*600/2),
							.RD2_LENGTH(8'h80),
`endif
				        	.RD2_LOAD(!DLY_RST_0),
							.RD2_CLK(~VGA_CTRL_CLK),
							
							//	SDRAM Side
						    .SA(DRAM_ADDR),
							.BA(DRAM_BA),
							.CS_N(DRAM_CS_N),
							.CKE(DRAM_CKE),
							.RAS_N(DRAM_RAS_N),
							.CAS_N(DRAM_CAS_N),
							.WE_N(DRAM_WE_N),
							.DQ(DRAM_DQ),
							.DQM(DRAM_DQM)
						);
//D5M I2C control
I2C_CCD_Config 		u8	(	//	Host Side
							.iCLK(CLOCK2_50),
							.iRST_N(DLY_RST_2),
							.iEXPOSURE_ADJ(KEY[1]),
							.iEXPOSURE_DEC_p(SW[0]),
							.iZOOM_MODE_SW(SW[16]),
							//	I2C Side
							.I2C_SCLK(D5M_SCLK),
							.I2C_SDAT(D5M_SDATA)
						);
//VGA DISPLAY
VGA_Controller		u1	(	//	Host Side
							.oRequest(Read),
							.iRed(Read_DATA2[9:0]),
							.iGreen({Read_DATA1[14:10],Read_DATA2[14:10]}),
							.iBlue(Read_DATA1[9:0]),
							//	VGA Side
							.oVGA_R(oVGA_R),
							.oVGA_G(oVGA_G),
							.oVGA_B(oVGA_B),
							.o_x(vga_x),
							.o_y(vga_y),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST_2),
							.iZOOM_MODE_SW(SW[16])
						);

Point_detection    pd(.clk(VGA_CTRL_CLK), .rst(DLY_RST_2), .i_start(start_detect), .i_finish(finish_detect), 
					  .i_left_edge(o_x), .i_y(o_y), o_finished(finished), o_centerX(center_x), o_centerY(center_y), .o_mask(mask));

Detection_controller dc(.clk(VGA_CTRL_CLK), .rst(DLY_RST_2), .vga_r(VGA_R), .vga_g(VGA_G), .vga_b(VGA_B), .video_active(o_request), .start_detect(start_detect), .finish_detect(finish_detect));

wire [9:0] x_cor, y_cor;
assign x_cor = finished ? center_x : vga_x;
assign y_cor = finished ? center_y : vga_y;

//SoundContro   	   sc(.i_x(x_cor), .i_y(y_cor), i_vga_r(VGA_R) , i_vga_g(VGA_G), i_vga_b(VGA_B), .i_mask(mask), .state(SW[0]), .o_sound_num(o_sound_num));
SoundController   	   sc(.clk(VGA_CTRL_CLK), .rst(DLY_RST_2), .detect_finished(finish_detect), .i_x(x_cor), .i_y(y_cor), i_vga_r(VGA_R) , i_vga_g(VGA_G), i_vga_b(VGA_B), .i_mask(mask), .state(SW[0]), .sound_num(o_sound_num));

//*********************CLKgenerator********************
	logic clk12M, clk100K;
	logic DLY_RST; 
	assign AUD_XCK = clk12M;				// 餵12M的clk訊號到AUD_XCK(WM8731)

	clkgen clkg(
		.inclk0(CLOCK_50),
		.c0(clk12M),
		.c1(clk100K)
	);

    Reset_Delay rst0(
        .iCLK(clk12M),
        .oRESET(DLY_RST)
    );
	
	//  KEYs
   logic keydown_rst;
	logic keydown_playorpause;
	logic keydown_spdup;
	logic keydown_spddown;

//*********************Debounce********************
	//  Debounce
	Debounce deb_rst(
		.i_in(KEY[0]),
		.i_clk(AUD_BCLK),
		.o_neg(keydown_rst)
	);
	Debounce deb_playorpause(
		.i_in(KEY[1]),
		.i_clk(AUD_BCLK),
		.o_neg(keydown_playorpause)
	);
    Debounce deb_spdup(
		.i_in(KEY[2]),
		.i_clk(AUD_BCLK),
		.o_neg(keydown_spdup)
	);
	Debounce deb_spddown(
		.i_in(KEY[3]),
		.i_clk(AUD_BCLK),
		.o_neg(keydown_spddown)
	);
//

	 Initialize i0(
       .i_clk(clk100K),
		.i_rst(DLY_RST),
		.o_sclk(I2C_SCLK),
		.o_sdat(I2C_SDAT)
	);


//*********************Record********************

Record record(
	.i_rst(DLY_RST),				
	.i_stop(keydown_rst),				
	.i_playpause(keydown_playorpause),			
	.i_record(SW[0]),						
	// codec
	.i_BCLK(AUD_BCLK),				
	.i_LRC(AUD_ADCLRCK),
	.i_DAT(AUD_ADCDAT),
	// LCD
	.state_denote(rec_state),     							// 做LCD的請留意!!!!
	// SRAM 
	.i_Memory_full_flag(memory_full),  	   								
	.sram_start(sram_record_start),											
	.o_reset_all_sram_addr(address_reset),       						
	.o_sram_data(sram_data)												
);



//*********************PLAY********************
PLAY p1(
	.i_rst(DLY_RST),
	.i_clk(AUD_BCLK),
	.i_stop(keydown_rst),
	.i_playorpause(keydown_playorpause),
	.i_spdup(keydown_spdup),
	.i_spddown(keydown_spddown),
	.i_record(SW[0]),
	.i_interpolation(SW[1]),
	
	.o_state(play_state),
	.o_play_speed(play_speed),
	
	.i_aud_DAClrck(AUD_DACLRCK),
	.o_aud_DACdat(AUD_DACDAT),
	
	.o_sram_start(sram_play_start),
	.i_sram_data(SRAM_DQ),
	.i_sram_play_complete(i_sram_play_complete),
	.o_speedup_parameter(speedup_parameter)
);


//*********************SRAM_Communicator*******
	logic [15:0] sram_data;
	logic address_reset;
	logic memory_full;
	logic sram_record_start, sram_play_start;
	logic i_sram_play_complete;
	logic [3:0]speedup_parameter;


SRAMCommunicator s1(
	.i_clk(AUD_BCLK),
	.i_rst(DLY_RST),
	.i_write(SW[0]),
	
	.i_start_play(sram_play_start),
	.i_play_state(play_state),
	.i_speedup_parameter(speedup_parameter),
	
	.i_start_rec(sram_record_start),
	.i_record_rst(address_reset),
	.i_data_write(sram_data),
	
	.o_sram_addr(SRAM_ADDR),
	.o_sram_ce_n(SRAM_CE_N),
    .io_sram_dq(SRAM_DQ),
    .o_sram_lb_n(SRAM_LB_N),
    .o_sram_oe_n(SRAM_OE_N),
    .o_sram_ub_n(SRAM_UB_N),
    .o_sram_we_n(SRAM_WE_N),
	
	.o_full(memory_full),
	.o_play_complete(i_sram_play_complete)
);
//*********************SRAM_Communicator*******







//*********************Debug********************
 //  LCD  
    logic [1:0]rec_state;
    logic [1:0]play_state;
    logic [3:0]play_speed;
//  LCD
    assign LCD_BLON = 0;
    assign LCD_ON = 1;  
	
	 localparam	S_STOP          =	0;
    localparam	S_REC	        =	1;
    localparam	S_PLAY	        =	2;
    localparam	S_PAUSE_REC	    =	3;
    localparam  S_PAUSE_PLAY    =   4;
    logic [2:0]ST;
    always_comb begin
        if(SW[0] == 1) begin
            case(rec_state)
                0:    ST = S_STOP;  
                1:    ST = S_REC;  
                2:    ST = S_PAUSE_REC; 
			 default:    ST = S_STOP;
            endcase
        end
        else begin
            case(play_state)
                0:   ST = S_STOP;
                1:   ST = S_PLAY;
			    2:   ST = S_PLAY;
                3:   ST = S_PAUSE_PLAY;                
            endcase
        end
	end
    LCD_SHOW lcd0(
        .iCLK(AUD_BCLK), 
        .iRST_N(DLY_RST),
        .iST(ST),
        .iSPEED(play_speed),
        .LCD_DATA(LCD_DATA),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_EN(LCD_EN)
);

// Seven Decoder
SevenDecoder sevendecoder(
	.i_dec_rec(rec_state),
	.o_dec_rec_seven(HEX0),
	.i_dec_pla(play_state),
	.o_dec_pla_seven(HEX1),
	.i_dec_key(i_sram_play_complete),
	.o_dec_key_seven(HEX2),
	.i_dec_sw(SW[0]),
	.o_dec_sw_seven(HEX3),
	.i_dec_speed(speedup_parameter),
	.o_dec_speed_seven(HEX6),
	.i_hex(play_speed),
	.o_seven_ten(HEX5),
	.o_seven_one(HEX4),
//	.i_play_state(play_state),
//	.i_rec_state(rec_state),
	.o_txt_seven(HEX7)	

);



endmodule
