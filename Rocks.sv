module Rocks(input         Clk,
				 input         Reset, 
				 input [9:0]   DrawX, 
				 input [9:0]   DrawY, 
				 input         frame_clk, 
				 input [9:0]   Rock_X_Start, 
				 input [9:0]   Rock_Y_Start,
				 input [23:0]  dug_state[31:0],
				 output        is_rock, 
				 output [9:0]  Rock_X_Loc, 
				 output [9:0]  Rock_Y_Loc,
				 output        Delete_rock,
				 output        falling);
				 
	logic [9:0]  Rock_Y_Pos, Rock_Y_Pos_in; 
	logic [9:0]  Rock_Y_Motion, Rock_Y_Motion_in; 
	logic [9:0]  Rock_X_Pos; 
	
	logic        falling_state; 
	logic        falling_state_in; 
	logic        Delete_rock_in; 
	logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 always_ff @ (posedge Clk)
    begin
        if (Reset)
				begin
					Rock_Y_Pos <= Rock_Y_Start; 
					Rock_Y_Motion <= 10'd0;
					falling_state <= 1'b0;
					Delete_rock <= 1'b0; 
				end
        else
				begin
					Rock_Y_Pos <= Rock_Y_Pos_in; 
					Rock_Y_Motion <= Rock_Y_Motion_in; 
					
					Rock_X_Pos <= Rock_X_Start; 
					
					Rock_Y_Loc <= Rock_Y_Pos; 
					Rock_X_Loc <= Rock_X_Start;
				
					falling_state <= falling_state_in; 
					Delete_rock <= Delete_rock_in; 
				end
    end
	 always_comb 
	 begin 
			Rock_Y_Pos_in = Rock_Y_Pos; 
			Rock_Y_Motion_in = Rock_Y_Motion; 
			
			if(frame_clk_rising_edge)
				begin 
					if(Rock_Y_Pos >= 10'd471)begin 
						Rock_Y_Motion_in = 10'd0; 
					end 
					else if((dug_state[Rock_X_Pos/16][((Rock_Y_Pos-10'd96)/16)+1] == 1'b1) && 
								(Delete_rock == 1'b0)) begin 
						Rock_Y_Motion_in = 10'd1;  
					end 
					else begin 
						Rock_Y_Motion_in = 10'd0; 
					end 
					
					Rock_Y_Pos_in = Rock_Y_Pos + Rock_Y_Motion;
				end 
			if(Rock_Y_Motion_in == 1'b1)begin 
				falling_state_in = 1'b1; 
			end 
			else begin 
				falling_state_in = falling_state; 
			end 
			
	 end 
	 always_comb begin 
			if((falling_state == 1'b1) && (Rock_Y_Motion_in == 1'b0) )
				begin 
					Delete_rock_in = 1'b1; 
					falling = 1'b0; 
				end 
			else if (Rock_Y_Motion_in == 1'b1)
				begin 
					Delete_rock_in = Delete_rock; 
					falling = 1'b1; 
				end 
			else 
				begin 
					Delete_rock_in = Delete_rock; 
					falling = 1'b0; 
				end 
	 end 
	 always_comb begin 
			if ((DrawX >= (Rock_X_Pos-10'd8)) && (DrawX <= (Rock_X_Pos+10'd8)) && 
		       (DrawY >= (Rock_Y_Pos-10'd8)) && (DrawY <= (Rock_Y_Pos+10'd8))) 
				 is_rock = 1'b1; 
			else 
				 is_rock = 1'b0; 
		end 
endmodule 