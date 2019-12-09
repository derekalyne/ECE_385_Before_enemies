module dig_score( input              Clk, 
						input              Reset, 
						input              is_increase_dug_score,
						output [9:0]       dig_sum);  
		
		always_ff @(posedge Clk) begin 
			if (Reset)
				dig_sum <= 10'd0; 
			else if(is_increase_dug_score == 1'b1)
				dig_sum <= dig_sum + 1'b1;
		end 
endmodule 
						
