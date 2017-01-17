module	Reset_Delay(
    input iCLK,
    output oRESET
);
    logic [19:0] Cont;
    always_ff @(posedge iCLK)
    begin
        if(Cont!=20'hFFFFF)
        begin
            Cont	<=	Cont+1;
            oRESET	<=	1'b0;
        end
        else oRESET	<=	1'b1;
    end
endmodule
