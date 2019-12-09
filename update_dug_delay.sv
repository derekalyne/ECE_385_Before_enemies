module update_dug_delay(input Clk, 
								input Reset,
								output endgame_delay);
	
	enum logic [1:0] {Before_Delay, 
							Delay,
							After_Delay} State, Next_State; 
	
	always_ff@(posedge Clk) 
	begin 
			if(Reset)
				State = Before_Delay; 
			else 
				State = Next_State;	
	end 
		
	always_comb 
	begin 
		Next_State = State; 
		unique case(State)
			Before_Delay:
				Next_State <= Delay; 
			Delay:
				Next_State <= After_Delay; 
			After_Delay:;
		endcase
		
		case(State)
			Before_Delay: 
				endgame_delay = 1'b0; 
			Delay:
				endgame_delay = 1'b1;
			After_Delay:
				endgame_delay = 1'b0; 
		endcase
				
	end 
endmodule 