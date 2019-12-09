module Score_sprite(input [9:0]   DrawX, 
						  input [9:0]   DrawY, 
						  output        is_S_Score, 
						  output        is_C_Score, 
						  output        is_O_Score, 
						  output        is_R_Score, 
						  output        is_E_Score, 
						  output [10:0] addr_score);
		
		always_comb begin 
			if ( (DrawX >= 10'd527) && (DrawX < 10'd535) 
				&& (DrawY >= 10'd272) && (DrawY < 10'd288)) begin  // S sprite 
					is_S_Score = 1'b1;
					is_C_Score = 1'b0; 
					is_O_Score = 1'b0; 
					is_R_Score = 1'b0; 
					is_E_Score =1'b0; 
					addr_score = (DrawY - 10'd272 + 16*'h53); 
			end 
			else if ( (DrawX >= 10'd535) && (DrawX < 10'd543)
				&& (DrawY >= 10'd272) && (DrawY < 10'd288)) begin // C sprite 
					is_S_Score = 1'b0; 
					is_C_Score = 1'b1; 
					is_O_Score = 1'b0; 
					is_R_Score = 1'b0;
					is_E_Score = 1'b0; 
					addr_score = (DrawY - 10'd272 + 16*'h43);
			end 
			else if ( (DrawX >= 10'd543) && (DrawX < 10'd551)
				&& (DrawY >= 10'd272) && (DrawY < 10'd288)) begin // O sprite 
					is_S_Score = 1'b0; 
					is_C_Score = 1'b0;
					is_O_Score = 1'b1; 
					is_R_Score = 1'b0;
					is_E_Score = 1'b0; 
					addr_score = (DrawY - 10'd272 + 16*'h4f);
			end 
			else if ( (DrawX >= 10'd551) && (DrawX < 10'd559)
				&& (DrawY >= 10'd272) && (DrawY < 10'd288)) begin // R sprite 
					is_S_Score = 1'b0;
					is_C_Score = 1'b0; 
					is_O_Score = 1'b0; 
					is_R_Score = 1'b1;
					is_E_Score = 1'b0;
					addr_score = (DrawY - 10'd272 + 16*'h52);
			end 
			else if ( (DrawX >= 10'd559) && (DrawX < 10'd567)
				&& (DrawY >= 10'd272) && (DrawY < 10'd288)) begin  // E sprite 
					is_S_Score = 1'b0; 
					is_C_Score = 1'b0; 
					is_O_Score = 1'b0;
					is_R_Score = 1'b0; 
					is_E_Score = 1'b1; 
					addr_score = (DrawY - 10'd272 + 16*'h45); 
			end 
			else begin 
					is_S_Score = 1'b0;
					is_C_Score = 1'b0;
					is_O_Score = 1'b0; 
					is_R_Score = 1'b0;
					is_E_Score = 1'b0; 
					addr_score = (DrawY - 10'd272);
			end 
		end 
endmodule 
						  