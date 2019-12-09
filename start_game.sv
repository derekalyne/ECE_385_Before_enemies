module start_game(input Clk, 
						input Reset, 
						output game_state);
		enum logic {Start, 
		            Not_Start} State, Next_state; 
		
		always_ff @(posedge Clk)begin 
			if(Reset)
				State = Start; 
			else 
				State = Next_state; 
		end 
		always_comb begin 
		      Next_state = State; 
				unique case(State)
					Start : 
						Next_state <= Not_Start; 
					Not_Start:; 
				endcase 
				
				case(State)
					Start: 
						game_state = 1'b1; 
					Not_Start:
						game_state = 1'b0; 
				endcase 
		end 
endmodule 