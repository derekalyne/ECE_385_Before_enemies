module Digit_sprites(input [9:0]      DrawX, 
							input [9:0]      DrawY,
							input [3:0]      thousands, 
							input [3:0]      hundreads, 
							input [3:0]      tens, 
							input [3:0]      ones, 
							output           is_thousands,
							output           is_hundreads, 
							output           is_tens, 
							output           is_ones, 
							output [10:0]    addr_digit);
							
		always_comb begin 
			if( (DrawX >= 10'd535) && (DrawX < 10'd543)
				&& (DrawY >= 10'd289) && (DrawY < 10'd305)) begin 
					is_thousands = 1'b1; 
					is_hundreads = 1'b0;
					is_tens = 1'b0;
					is_ones = 1'b0; 
					addr_digit = (DrawY - 10'd289 + 16*(16'h30+thousands));
			end 
			else if( (DrawX >= 10'd543) && (DrawX < 10'd551)
				&& (DrawY >= 10'd289) && (DrawY < 10'd305)) begin 
					is_thousands = 1'b0;
					is_hundreads = 1'b1;
					is_tens = 1'b0; 
					is_ones = 1'b0; 
					addr_digit = (DrawY - 10'd289 + 16*(16'h30+hundreads));
			end 
			else if( (DrawX >= 10'd551) && (DrawX < 10'd559)
				&& (DrawY >= 10'd289) && (DrawY < 10'd305)) begin 
					is_thousands = 1'b0; 
					is_hundreads = 1'b0; 
					is_tens = 1'b1;
					is_ones = 1'b0; 
					addr_digit = (DrawY - 10'd289 + 16*(16'h30+tens));
			end 
			else if( (DrawX >= 10'd559) && (DrawX < 10'd567)
				&& (DrawY >= 10'd289) && (DrawY < 10'd305)) begin 
					is_thousands = 1'b0; 
					is_hundreads = 1'b0; 
					is_tens = 1'b0;
					is_ones = 1'b1;
					addr_digit = (DrawY - 10'd289 + 16*(16'h30+ones));
			end 
			else begin 
					is_thousands = 1'b0;
					is_hundreads = 1'b0;
					is_tens = 1'b0;
					is_ones = 1'b0;
					addr_digit = (DrawY - 10'd289); 
			end 
		end 
					
endmodule 		