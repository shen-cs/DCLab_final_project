module Initialize(
	input   i_clk,
	input   i_rst,
	output  o_sclk,
	inout   o_sdat,
    output  o_finish,
    output  [3:0] o_index
);
    
    logic i2c_finished, finished;
    logic start_i2c_r, start_i2c_w;
    logic [3:0]  index_r, index_w;
    logic [23:0] i2c_data_r, i2c_data_w;
    
    assign o_finish = finished;
    assign o_index  = index_r;
    always_comb begin
        if(i2c_finished) begin
            if(index_r == 0) finished = 1;
            else finished = 0;
        end
        else finished = 0;
    end
    I2cSender #(.BYTE(3)) i2c0(
        .i_start(start_i2c_w),
        .i_dat(i2c_data_r),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_finished(i2c_finished),
        .o_sclk(o_sclk),
        .o_sdat(o_sdat)
    );
    always_comb begin
        if(i2c_finished == 1) begin
            case(index_r)
                10:begin i2c_data_w = 24'b0011010_0_000_0000_0_1001_0111; start_i2c_w = 1; end
                9: begin i2c_data_w = 24'b0011010_0_000_0001_0_1001_0111; start_i2c_w = 1; end
                8: begin i2c_data_w = 24'b0011010_0_000_0010_0_0111_1001; start_i2c_w = 1; end
                7: begin i2c_data_w = 24'b0011010_0_000_0011_0_0111_1001; start_i2c_w = 1; end
                6: begin i2c_data_w = 24'b0011010_0_000_0100_0_0001_0101; start_i2c_w = 1; end
                5: begin i2c_data_w = 24'b0011010_0_000_0101_0_0000_0000; start_i2c_w = 1; end
                4: begin i2c_data_w = 24'b0011010_0_000_0110_0_0000_0000; start_i2c_w = 1; end
                3: begin i2c_data_w = 24'b0011010_0_000_0111_0_0100_0010; start_i2c_w = 1; end
                2: begin i2c_data_w = 24'b0011010_0_000_1000_0_0001_1001; start_i2c_w = 1; end
                1: begin i2c_data_w = 24'b0011010_0_000_1001_0_0000_0001; start_i2c_w = 1; end
                0: begin i2c_data_w = 0; start_i2c_w = 0; end
                default:begin i2c_data_w = i2c_data_r; start_i2c_w = start_i2c_r; end
            endcase
                index_w = index_r - 1;
        end
        else begin
            i2c_data_w  =   i2c_data_r;
            start_i2c_w =   0;
            index_w     =   index_r;
        end
    end
        //****************  handling i2c start signals and data to send  ******************
    always_ff @(posedge i_clk or negedge i_rst) begin
        if(i_rst == 0) begin
            index_r     <=  10;
            start_i2c_r <=  0;
            i2c_data_r  <=  0;
        end
        else begin
            index_r     <=  index_w;
            start_i2c_r <=  start_i2c_w;
            i2c_data_r  <=  i2c_data_w;
        end
    end
endmodule
