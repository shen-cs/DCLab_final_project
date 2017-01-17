module SoundContro(
	output [2:0] o_sound_num
	input [9:0] i_x,
	input [9:0] i_y,
	input [7:0] i_vga_r,
	input [7:0] i_vga_g,
	input [7:0] i_vga_b,
	input [2:0] i_mask, //000:don't save ,001:save p1 ,010:p2 ,011:p3 ,100:p4 
	input state //1:record 0:play
	);
	
	reg [9:0]  n_p1x,p1x;
	reg [9:0]  n_p1y,p1y;
	reg [9:0]  n_p2x,p2x;
	reg [9:0]  n_p2y,p2y;
	reg [9:0]  n_p3x,p3x;
	reg [9:0]  n_p3y,p3y;
	reg [9:0]  n_p4x,p4x;
	reg [9:0]  n_p4y,p4y;
	reg [9:0]  n_vga_r1,vga_r1;
	reg [9:0]  n_vga_g1,vga_g1;
	reg [9:0]  n_vga_b1,vga_b1;
	reg [9:0]  n_vga_r2,vga_r2;
	reg [9:0]  n_vga_g2,vga_g2;
	reg [9:0]  n_vga_b2,vga_b2;
	reg [9:0]  n_vga_r3,vga_r3;
	reg [9:0]  n_vga_g3,vga_g3;
	reg [9:0]  n_vga_b3,vga_b3;
	reg [9:0]  n_vga_r4,vga_r4;
	reg [9:0]  n_vga_g4,vga_g4;
	reg [9:0]  n_vga_b4,vga_b4;
	reg [2:0]sound_num;
	assign o_sound_num=sound_num;
	
	always@(posedge iCLK)begin
		if(state==1)begin
		case(i_mask)
			3'b000:
			 n_p1x <= p1x;
			 n_p1y <= p1y;
			 n_p2x <= p2x;
			 n_p2y <= p2y;
			 n_p3x <= p3x;
			 n_p3y <= p3y;
			 n_p4x <= p4x;
			 n_p4y <= p4y;
			 
			 n_vga_r1 <= vga_r1;
			 n_vga_g1 <= vga_g1;
			 n_vga_b1 <= vga_b1;
			 n_vga_r2 <= vga_r2;
			 n_vga_g2 <= vga_g2;
			 n_vga_b2 <= vga_b2;
			 n_vga_r3 <= vga_r3;
			 n_vga_g3 <= vga_g3;
			 n_vga_b3 <= vga_b3;
			 n_vga_r4 <= vga_r4;
			 n_vga_g4 <= vga_g4;
			 n_vga_b4 <= vga_b4;
			3'b001: 
			 n_p1x <= i_x; //
			 n_p1y <= i_y; //
			 n_p2x <= p2x;
			 n_p2y <= p2y;
			 n_p3x <= p3x;
			 n_p3y <= p3y;
			 n_p4x <= p4x;
			 n_p4y <= p4y;
			 
			 n_vga_r1 <= i_vga_r; //
			 n_vga_g1 <= i_vga_g; // 
			 n_vga_r2 <= i_vga_b; //
			 n_vga_g2 <= vga_g2;
			 n_vga_b2 <= vga_b2;
			 n_vga_r3 <= vga_r3;
			 n_vga_g3 <= vga_g3;
			 n_vga_b3 <= vga_b3;
			 n_vga_r4 <= vga_r4;
			 n_vga_g4 <= vga_g4;
			 n_vga_b4 <= vga_b4;
			3'b010:
			 n_p1x <= p1x;
			 n_p1y <= p1y;
			 n_p2x <= i_x; //
			 n_p2y <= i_y; //
			 n_p3x <= p3x;
			 n_p3y <= p3y;
			 n_p4x <= p4x;
			 n_p4y <= p4y;
			 
			 n_vga_r1 <= vga_r1;
			 n_vga_g1 <= vga_g1;
			 n_vga_b1 <= vga_b1;
			 n_vga_r2 <= i_vga_r; //
			 n_vga_g2 <= i_vga_g; //
			 n_vga_b2 <= i_vga_b; //
			 n_vga_r3 <= vga_r3;
			 n_vga_g3 <= vga_g3;
			 n_vga_b3 <= vga_b3;
			 n_vga_r4 <= vga_r4;
			 n_vga_g4 <= vga_g4;
			 n_vga_b4 <= vga_b4;
			3'b011:
			 n_p1x <= p1x;
			 n_p1y <= p1y;
			 n_p2x <= p2x;
			 n_p2y <= p2y;
			 n_p3x <= i_x; //
			 n_p3y <= i_y; //
			 n_p4x <= p4x;
			 n_p4y <= p4y;
			 
			 n_vga_r1 <= vga_r1;
			 n_vga_g1 <= vga_g1;
			 n_vga_b1 <= vga_b1;
			 n_vga_r2 <= vga_r2;
			 n_vga_g2 <= vga_g2;
			 n_vga_b2 <= vga_b2;
			 n_vga_r3 <= i_vga_r; //
			 n_vga_g3 <= i_vga_g; //
			 n_vga_b3 <= i_vga_b; //
			 n_vga_r4 <= vga_r4;
			 n_vga_g4 <= vga_g4;
			 n_vga_b4 <= vga_b4;
			3'b100:
			 n_p1x <= p1x;
			 n_p1y <= p1y;
			 n_p2x <= p2x;
			 n_p2y <= p2y;
			 n_p3x <= p3x;
			 n_p3y <= p3y;
			 n_p4x <= i_x; //
			 n_p4y <= i_y; //
			 
			 n_vga_r1 <= vga_r1;
			 n_vga_g1 <= vga_g1;
			 n_vga_b1 <= vga_b1;
			 n_vga_r2 <= vga_r2;
			 n_vga_g2 <= vga_g2;
			 n_vga_b2 <= vga_b2;
			 n_vga_r3 <= vga_r3;
			 n_vga_g3 <= vga_g3;
			 n_vga_b3 <= vga_b3;
			 n_vga_r4 <= i_vga_r; //
			 n_vga_g4 <= i_vga_g; //
			 n_vga_b4 <= i_vga_b; //
		endcase
		end
		else if(state==0)begin
			 n_p1x <= p1x;
			 n_p1y <= p1y;
			 n_p2x <= p2x;
			 n_p2y <= p2y;
			 n_p3x <= p3x;
			 n_p3y <= p3y;
			 n_p4x <= p4x;
			 n_p4y <= p4y;
			 
			 n_vga_r1 <= vga_r1;
			 n_vga_g1 <= vga_g1;
			 n_vga_b1 <= vga_b1;
			 n_vga_r2 <= vga_r2;
			 n_vga_g2 <= vga_g2;
			 n_vga_b2 <= vga_b2;
			 n_vga_r3 <= vga_r3;
			 n_vga_g3 <= vga_g3;
			 n_vga_b3 <= vga_b3;
			 n_vga_r4 <= vga_r4;
			 n_vga_g4 <= vga_g4;
			 n_vga_b4 <= vga_b4;
			 if(i_x==p1x&&i_y==p1y)begin
				sound_num <=((i_vga_r+i_vga_g+i_vga_b)==(vga_r1+vga_g1+vga_b1))?3'b001:3'b000;
			 end
			 else if(i_x==p2x&&i_y==p2y)begin
				sound_num <=((i_vga_r+i_vga_g+i_vga_b)==(vga_r2+vga_g2+vga_b2))?3'b010:3'b000;
			 end
			 else if(i_x==p3x&&i_y==p3y)begin
				sound_num <=((i_vga_r+i_vga_g+i_vga_b)==(vga_r3+vga_g3+vga_b3))?3'b011:3'b000;
			 end
			 else if(i_x==p4x&&i_y==p4y)begin
				sound_num <=((i_vga_r+i_vga_g+i_vga_b)==(vga_r4+vga_g4+vga_b4))?3'b100:3'b000;
			 end
			 else begin
				sound_num <=3'b000;
			 end
		end
		
		
		p1x<=n_p1x;
		p2x<=n_p2x;
		p3x<=n_p3x;
		p4x<=n_p4x;
		p1y<=n_p1y;
		p2y<=n_p2y;
		p3y<=n_p3y;
		p4y<=n_p4y;
		vga_r1<=n_vga_r1;
	    vga_g1<=n_vga_g1;
		vga_b1<=n_vga_b1;
		vga_r2<=n_vga_r2;
	    vga_g2<=n_vga_g2;
		vga_b2<=n_vga_b2;
		vga_r3<=n_vga_r3;
	    vga_g3<=n_vga_g3;
		vga_b3<=n_vga_b3;
		vga_r4<=n_vga_r4;
	    vga_g4<=n_vga_g4;
		vga_b4<=n_vga_b4;
	end
	
	