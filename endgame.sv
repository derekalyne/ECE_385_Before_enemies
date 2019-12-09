module game_over(input [1:0] life_state,
					  output endgame);
	always_comb begin 
		if(life_state == 2'b11)
			endgame = 1'b1; 
		else 
			endgame = 1'b0; 
	end 
endmodule 