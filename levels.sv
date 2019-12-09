module Update_dug_state(input Clk, 
								input Reset, 
								input [9:0]     Ball_X_Loc,
								input [9:0]     Ball_Y_Loc,  
								output [23:0]   update_dug_state[31:0],
							   output           is_increase_dug_score); 
	logic [23:0] dug_state_in [31:0]; 
	always_comb begin 
			for(int y=0; y<24; y++)begin 
				for(int x=0; x<32; x++)begin 
					update_dug_state[x][y] = dug_state_in[x][y]; 
				end 
			end  
	end 
	always_ff @(posedge Clk) begin 
		if(Ball_Y_Loc > 10'd96) begin
			if(dug_state_in[Ball_X_Loc/16][(Ball_Y_Loc-10'd96)/16] == 1'b0)
				is_increase_dug_score <= 1'b1;
			else 
				is_increase_dug_score <= 1'b0; 
		end 
	end 
	always_ff @(posedge Clk) 
		begin 
			if(Reset) begin
				for(int y=0; y<24; y++)begin 
					for(int x=0; x<32; x++)begin 
						dug_state_in[x][y] <= 1'b0; 
					end 
				end 
			end 
			else begin 
				if(Ball_Y_Loc > 10'd96)
					dug_state_in[Ball_X_Loc/16][(Ball_Y_Loc-10'd96)/16] <= 1'b1;
				else 
					dug_state_in[Ball_X_Loc/16][(Ball_Y_Loc-10'd96)/16] <= update_dug_state[Ball_X_Loc/16][(Ball_Y_Loc-10'd96)/16];
			end
		end 
endmodule 