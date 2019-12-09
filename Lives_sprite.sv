module Lives_sprite(input [9:0]       DrawX, 
						  input [9:0]       DrawY, 
						  output            is_L, 
						  output            is_I, 
						  output            is_V, 
						  output            is_E, 
						  output            is_S, 
						  output [10:0]     addr_lives);
						  
	always_comb begin 
		if( (DrawX >= 10'd527) && (DrawX < 10'd535)
			&& (DrawY >= 10'd351) && (DrawY < 10'd367))begin 
			is_L = 1'b1; 
			is_I = 1'b0; 
			is_V = 1'b0; 
			is_E = 1'b0; 
			is_S = 1'b0;
			addr_lives = (DrawY - 10'd351 + 16*'h4c); // L sprite address 
		end 
		else if( (DrawX >= 10'd535) && (DrawX < 10'd543)
					&& (DrawY >= 10'd351) && (DrawY < 10'd367)) begin
			is_L = 1'b0;	
			is_I = 1'b1;
			is_V = 1'b0; 
			is_E = 1'b0; 
			is_S = 1'b0;
			addr_lives = (DrawY - 10'd351 + 16*'h49); // I sprite address 
		end 
		else if( (DrawX >= 10'd543) && (DrawX <= 10'd551)
					&& (DrawY >= 10'd351) && (DrawY < 10'd367)) begin 
			is_L = 1'b0; 
			is_I = 1'b0;
			is_V = 1'b1;
			is_E = 1'b0; 
			is_S = 1'b0; 
			addr_lives = (DrawY - 10'd351 + 16*'h56); // V sprite address 
		end 
		else if( (DrawX >= 10'd552) && (DrawX < 10'd560)
					&& (DrawY >= 10'd351) && (DrawY < 10'd367)) begin 
			is_L = 1'b0; 
			is_I = 1'b0;
			is_V = 1'b0;
			is_E = 1'b1;
			is_S = 1'b0; 
			addr_lives = (DrawY - 10'd351 + 16*'h45); // E sprtie address 
		end 
		else if( (DrawX >= 10'd561) && (DrawX < 10'd569)
					&& (DrawY >= 10'd351) && (DrawY < 10'd367)) begin 
			is_L = 1'b0;
			is_I = 1'b0;
			is_V = 1'b0; 
			is_E = 1'b0; 
			is_S = 1'b1; 
			addr_lives = (DrawY - 10'd351 + 16*'h53); // S sprite address  
		end 
		else begin 
			is_L = 1'b0; 
			is_I = 1'b0;
			is_V = 1'b0; 
			is_E = 1'b0; 
			is_S = 1'b0; 
			addr_lives = (DrawY-10'd531); // does not matter will not execute in mapper 
		end 
	end 
endmodule 