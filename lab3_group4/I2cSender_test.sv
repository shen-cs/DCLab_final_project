module I2cSender #(parameter BYTE=3) (
	input   i_start,
	input   [BYTE*8-1:0] i_dat,
	input   i_clk,
	input   i_rst,
	output  o_finished,
	output  o_sclk,
	inout   o_sdat
);
	localparam  CLK     =   10;
    localparam  BITS    =   BYTE*8;
    localparam  C1_BIT  =   $clog2(BITS+1);
    logic [1:0] clk_count_r, clk_count_w;
    logic [C1_BIT-1:0] counter_r, counter_w;
    logic [3:0] check_r, check_w; //check_r == 8 check
    logic oe;		//output enable
    logic [2:0] state_r, state_w;
    logic SDAT;
    logic sclk_r, sclk_w;
    logic o_finish;
    localparam  S_STOP  =   0;
    localparam  S_START =   1;
    localparam  S_SEND  =   2;
    localparam  S_ACK   =   3;
    localparam  S_FIN   =   4;
    assign o_finished = o_finish;
    assign o_sclk = sclk_r;
    assign o_sdat = oe ? 1'bz : SDAT;
	//  combinational part
    //  state
    always_comb begin
        case(state_r)
            S_STOP: begin
                if(i_start == 1) state_w = S_START;
                else state_w = state_r;
            end
            S_START:begin
                if(o_sdat == 0 && o_sclk == 0) state_w = S_SEND;
                else state_w = state_r;
            end
            S_SEND: begin
                if(counter_r == BITS) state_w = S_ACK;
                else if(check_r == 8) state_w = S_ACK;
                else state_w = state_r;
            end
            S_ACK: begin
                if(clk_count_r == 1) begin
                    if(counter_r == BITS) state_w = S_FIN;
                    else state_w = S_SEND;
                end
                else state_w = state_r;
            end
            S_FIN: begin
                if(o_sdat == 0 && o_sclk == 1) state_w = S_STOP;
                else state_w = state_r;
            end
            default:begin
                state_w = state_r;
            end
        endcase
    end
	//  o_finish
    always_comb begin
        if(state_r == S_STOP) o_finish = 1;
        else o_finish = 0;
    end
    //  counter
    always_comb begin
		case(state_r)
			S_SEND: begin
                if(clk_count_r == 1) begin
                    if(counter_r == 0) counter_w = BITS;
                    else counter_w = counter_r - 1;
                end
                else counter_w = counter_r;
			end
            S_FIN:  begin
                counter_w = BITS - 1;
            end
            default:begin
                counter_w = counter_r;
            end
		endcase
	end 
    always_comb begin
		case(state_r)
			S_SEND: begin
                if(o_sclk == 1) begin
                    if(check_r == 8) check_w = check_r;
                    else check_w = check_r + 1;
                end
                else check_w = check_r;
			end
            S_ACK:  begin
                check_w = 0;
            end
            S_FIN:  begin
                check_w = 0;
            end
            default:begin
                check_w = check_r;
            end
		endcase
	end 
    // oe, SDA
	always_comb begin
		case(state_r)
			S_STOP: begin
				oe = 0;
                SDAT = 1;
			end
			S_START:begin
				oe = 0;
                SDAT = 0;
			end
			S_SEND: begin
                oe = 0;
                SDAT = i_dat[counter_r];
			end
			S_ACK:  begin
                oe = 1;
                SDAT = 0;
			end
            S_FIN:  begin
                oe = 0;
                SDAT = 0;
            end
            default:begin
                oe = 0;
                SDAT = 0;            
            end
		endcase
	end 
    //  sclk, clk_count
    always_comb begin
		case(state_r)
			S_STOP: begin
                clk_count_w = 0;
                sclk_w = 1;
			end
            S_FIN:  begin
                clk_count_w = 0;           
                sclk_w = 1;
            end
            default:begin
                if(clk_count_r == 0) begin
                    clk_count_w = 1;
                    sclk_w = 0;
                end
                else if(clk_count_r == 1) begin
                    clk_count_w = 2;
                    sclk_w = 0;
                end
                else begin
                    clk_count_w = 0;
                    sclk_w = 1;
                end
            end
		endcase
	end 
	always_ff @(posedge i_clk) begin
		if(i_rst) begin
			state_r     <=  0;
			counter_r   <=  BITS-1;
            clk_count_r <=  0;
            check_r     <=  0;
            sclk_r      <=  1;
		end
		else begin
            state_r     <=  state_w;
			counter_r   <=  counter_w;
            clk_count_r <=  clk_count_w;
            check_r     <=  check_w;
            sclk_r      <=  sclk_w;
		end
	end
endmodule
