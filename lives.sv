module lives(input [1:0] life_state, 
             output one, 
				 output two); 
		always_comb 
			begin 
				if(life_state == 2'b00)begin 
					one = 1'b1; 
					two = 1'b1;
				end 
				else if (life_state == 2'b01) begin 
					one = 1'b1; 
					two = 1'b0;
				end 
				else if (life_state == 2'b10) begin 
					one = 1'b0;
					two = 1'b0; 
				end 
				else begin 
					one = 1'b1; 
					two = 1'b1; 
				end 
			end 
endmodule 