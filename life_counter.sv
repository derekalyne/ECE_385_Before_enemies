module life_counter(input Clk, 
						  input is_killed,
						  input Reset, 
                    output [1:0] life_state); 			  
		always_ff @(posedge Clk)
			begin 
				if(Reset)
					life_state <= 2'b00;
				else if(is_killed) 
					life_state <= life_state + 1; 
			end 
endmodule 

