module score_board ( input [9:0]     dig_sum, 
							output [3:0]    thousands,
							output [3:0]    hundreads,
							output [3:0]    tens, 
							output [3:0]    ones); 
							
		assign thousands = dig_sum / 10'd1000; 
		assign hundreads = (dig_sum - (thousands * 10'd1000)) / 10'd100; 
		assign tens = (dig_sum - ( (thousands * 10'd1000) + (hundreads * 10'd100) ) ) / 10'd10; 
		assign ones = (dig_sum - ( (thousands * 10'd1000) + (hundreads * 10'd100) + (tens * 10'd10) )); 
endmodule 