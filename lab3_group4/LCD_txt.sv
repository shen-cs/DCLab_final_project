module	LCD_txt (	
    input iCLK,
    input iRST_N,
    input [2:0] iST,
    input [4:0] iSPEED,
    output [8:0] oTx1,
    output [8:0] oTx2,
    output [8:0] oTx3,
    output [8:0] oTx4,
    output [8:0] oTx5,
    output [8:0] oTx6,
    output [8:0] oNu1,
    output [8:0] oNu2,
    output [8:0] oTx7,
    output [8:0] oTx8,
    output [8:0] oTx9,
    output [8:0] oTx0,
    output [8:0] oNu3
);
    logic [26:0]mDLY;
    logic [8:0] REC_SEC, PLAY_SEC;
    logic [26:0]speed_sec;
    localparam  ONE_SEC	    =	12000000;
    localparam  S_STOP	    =	0;
    localparam	S_REC       =	1;
    localparam	S_PLAY	    =	2;
    localparam	S_PAUSE_REC	=	3;
    localparam  S_PAUSE_PLAY=   4;
//  SPEED
//  0	x1/8
//  1	x1/7
//  2	x1/6
//  3	x1/5
//  4	x1/4
//  5	x1/3
//  6	x1/2
//  7   normal
//  8   normal
//  9   x2
//  10  x3
//  11  x4
//  12  x5
//  13  x6
//  14  x7
//  15  x8
    //tasks
    task SPEED_tx7;
        begin
            case(iSPEED)
                7:      oTx7    =   9'h120;
                default:oTx7    =   9'h17E; // →
            endcase
        end
    endtask
    task SPEED_tx8;
        begin
            case(iSPEED)
                7:      oTx8    =   9'h120; //
                8:      oTx8    =   9'h132; // 2
                9:      oTx8    =   9'h133; // 3
                10:     oTx8    =   9'h134; // 4
                11:     oTx8    =   9'h135; // 5
                12:     oTx8    =   9'h136; // 6
                13:     oTx8    =   9'h137; // 7
                14:     oTx8    =   9'h138; // 8
                default:oTx8    =   9'h131; // 1
            endcase
        end
    endtask
    task SPEED_tx9;
        begin
            if(iSPEED < 7) oTx9    =   9'h12F; // /
            else           oTx9    =   9'h120; //
        end
    endtask
    task SPEED_tx0;
        begin
            case(iSPEED)
            0:      oTx0    =   9'h138; // 8
            1:      oTx0    =   9'h137; // 7
            2:      oTx0    =   9'h136; // 6
            3:      oTx0    =   9'h135; // 5
            4:      oTx0    =   9'h134; // 4
            5:      oTx0    =   9'h133; // 3
            6:      oTx0    =   9'h132; // 2
            default:oTx0    =   9'h120; //
            endcase
        end
    endtask
    task CountMin_One;
        input [9:0] Sec;
        begin
            logic [2:0] Min;
            Min = Sec/60;
            case(Min)
                0:  oNu3    =   9'h130;
                1:  oNu3    =   9'h131;
                2:  oNu3    =   9'h132;
                3:  oNu3    =   9'h133;
                4:  oNu3    =   9'h134;
                default:oNu1=   9'h120;
            endcase
        end
    endtask
    task CountSec_TEN;
        input [9:0] Sec;
        begin
            logic [1:0] Ten;
            if(Sec < 10)                    Ten = 0;
            else if(Sec >= 10 && Sec < 20)  Ten = 1;
            else if(Sec >= 20 && Sec < 30)  Ten = 2;
            else                            Ten = 3;

            case(Ten)
                0:  oNu1    =   9'h130;
                1:  oNu1    =   9'h131;
                2:  oNu1    =   9'h132;
                3:  oNu1    =   9'h133;
                default:oNu1=   9'h120;
            endcase
        end
    endtask
    task CountSec_ONE;
        input [9:0] Sec;
        begin
            logic [3:0] One;
            if(Sec < 10)                    One = Sec;
            else if(Sec >= 10 && Sec < 20)  One = Sec - 10;
            else if(Sec >= 20 && Sec < 30)  One = Sec - 20;
            else                            One = Sec - 30;
            
            case(One)
                0:  oNu2    =   9'h130;
                1:  oNu2    =   9'h131;
                2:  oNu2    =   9'h132;
                3:  oNu2    =   9'h133;
                4:  oNu2    =   9'h134;
                5:  oNu2    =   9'h135;
                6:  oNu2    =   9'h136;
                7:  oNu2    =   9'h137;
                8:  oNu2    =   9'h138;
                9:  oNu2    =   9'h139;
                default:oNu2=   9'h120;
            endcase
        end
    endtask
//

    always begin
        if(iST == S_PLAY) begin
            case(iSPEED)
                0:  speed_sec = ONE_SEC*8;
                1:  speed_sec = ONE_SEC*7;
                2:  speed_sec = ONE_SEC*6;
                3:  speed_sec = ONE_SEC*5;
                4:  speed_sec = ONE_SEC*4;
                5:  speed_sec = ONE_SEC*3;
                6:  speed_sec = ONE_SEC*2;
					 8:  speed_sec = ONE_SEC/2;
                9:  speed_sec = ONE_SEC/3;
                10: speed_sec = ONE_SEC/4;
                11: speed_sec = ONE_SEC/5;
                12: speed_sec = ONE_SEC/6;
                13: speed_sec = ONE_SEC/7;
                14: speed_sec = ONE_SEC/8;
                default:speed_sec = ONE_SEC;
            endcase
       end
       else speed_sec = ONE_SEC;
    end
//

    always begin
        case(iST)
            S_STOP: begin
                oTx1    =   9'h153;
                oTx2    =   9'h154;
                oTx3    =   9'h14F;
                oTx4    =   9'h150;
                oTx5    =   9'h120;
                oTx6    =   9'h120;
                
                oNu3    =   9'h130;
                oNu1    =   9'h130; 
                oNu2    =   9'h130;
                
                oTx7    =   9'h120;
                oTx8    =   9'h120;
                oTx9    =   9'h120;
                oTx0    =   9'h120;
            end
            S_REC:	begin
                oTx1    =   9'h152;
                oTx2    =   9'h145;
                oTx3    =   9'h143;
                oTx4    =   9'h14F;
                oTx5    =   9'h152;
                oTx6    =   9'h144;
                
                oNu3    =   9'h130;
                CountSec_TEN(REC_SEC);
                CountSec_ONE(REC_SEC);
                oTx7    =   9'h120;
                oTx8    =   9'h120;
                oTx9    =   9'h120;
                oTx0    =   9'h120;
            end
            S_PLAY:	begin
                oTx1    =   9'h150;
                oTx2    =   9'h14C;
                oTx3    =   9'h141;
                oTx4    =   9'h159;
                oTx5    =   9'h120;
                oTx6    =   9'h120;
                
                CountMin_One(PLAY_SEC);
                CountSec_TEN(PLAY_SEC);
                CountSec_ONE(PLAY_SEC);
                SPEED_tx7;
                SPEED_tx8;
                SPEED_tx9;
                SPEED_tx0;
            end
            S_PAUSE_REC: begin
                oTx1    =   9'h150;
                oTx2    =   9'h141;
                oTx3    =   9'h155;
                oTx4    =   9'h153;
                oTx5    =   9'h145;
                oTx6    =   9'h120;
                
                oNu3    =   9'h130;
                CountSec_TEN(REC_SEC);
                CountSec_ONE(REC_SEC);
                oTx7    =   9'h120;
                oTx8    =   9'h120;
                oTx9    =   9'h120;
                oTx0    =   9'h120;
            end
            S_PAUSE_PLAY:begin
                oTx1    =   9'h150;
                oTx2    =   9'h141;
                oTx3    =   9'h155;
                oTx4    =   9'h153;
                oTx5    =   9'h145;
                oTx6    =   9'h120;
                
                CountMin_One(PLAY_SEC);
                CountSec_TEN(PLAY_SEC);
                CountSec_ONE(PLAY_SEC);
                SPEED_tx7;
                SPEED_tx8;
                SPEED_tx9;
                SPEED_tx0;
            end
            default:begin
                oTx1    =   9'h153;
                oTx2    =   9'h154;
                oTx3    =   9'h14F;
                oTx4    =   9'h150;
                oTx5    =   9'h120;
                oTx6    =   9'h120;
                
                oNu3    =   9'h130;
                oNu1    =   9'h130; 
                oNu2    =   9'h130;
                oTx7    =   9'h120;
                oTx8    =   9'h120;
                oTx9    =   9'h120;
                oTx0    =   9'h120;
            end
        endcase
    end
    
    always@(posedge iCLK or negedge iRST_N) begin
        if(!iRST_N) begin
            mDLY     <=	0;
            REC_SEC  <=  0;
            PLAY_SEC <=  0;
        end
        else begin
            case(iST)
                S_STOP:	begin
                    mDLY        <=	0;
                    REC_SEC     <=  0;
                    PLAY_SEC    <=  0;
                end
                S_REC:	begin
                    if(mDLY < speed_sec)
                        mDLY	    <=	mDLY + 1;
                    else if (REC_SEC < 33) begin
                        mDLY	    <=	0;
                        REC_SEC     <=  REC_SEC + 1;
                    end
                    else begin
                        mDLY        <=  0;
                        REC_SEC     <=  0;
                    end
                end
                S_PLAY:	begin
                    if(mDLY < speed_sec)
                        mDLY	<=	mDLY + 1;
                    else if (PLAY_SEC < 33) begin
                        mDLY        <=  0;
                        PLAY_SEC    <=  PLAY_SEC + 1;
                    end
                    else begin
                        mDLY	    <=	0;
                        PLAY_SEC    <=  0;
                    end
                end
            endcase
        end
	end
endmodule
