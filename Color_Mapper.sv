//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_ball,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input        [23:0]      dug_state[31:0],
							  input              is_rock,
							  input              is_rock2,
							  input              is_rock3, 
							  input              is_rock4,
							  input              Delete_rock4, 
							  input              Delete_rock3, 
							  input              Delete_rock2,   
							  input              Delete_rock1,
							  input              one, 
							  input              two, 
							  input              pump_enable, 
							  input              is_pump,  
							  input              is_L,
							  input              is_I, 
							  input              is_V, 
							  input              is_E, 
							  input              is_S,  
							  input [7:0]        Lives_data, 
							  input              is_S_Score,
							  input              is_C_Score, 
							  input              is_O_Score,
							  input              is_R_Score, 
							  input              is_E_Score,
							  input [7:0]        Score_data,
							  input              is_thousands, 
							  input              is_hundreads,
							  input              is_tens, 
							  input              is_ones, 
							  input [7:0]        Digit_data, 
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_ball == 1'b1) 
        begin
            // White ball
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  else if (is_L && Lives_data[10'd527 - DrawX] == 1'b1) begin 
				Red = 8'hff; 
				Green = 8'hff; 
				Blue = 8'hff; 
		  end 
		  else if (is_I && Lives_data[10'd535 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff; 
				Blue = 8'hff; 
		  end
		  else if (is_V && Lives_data[10'd543 - DrawX] == 1'b1) begin 
				Red = 8'hff; 
				Green = 8'hff; 
				Blue = 8'hff; 
		  end 
		  else if (is_E && Lives_data[10'd552 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff; 
				Blue = 8'hff; 
		  end 
		  else if (is_S && Lives_data[10'd561 - DrawX] == 1'b1) begin 
				Red = 8'hff; 
				Green = 8'hff; 
				Blue = 8'hff; 
		  end 
		  else if (is_S_Score && Score_data[10'd527 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff; 
		  end 
		  else if (is_C_Score && Score_data[10'd535 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff; 
				Blue = 8'hff;
		  end 
		  else if (is_O_Score && Score_data[10'd543 - DrawX] == 1'b1) begin 
				Red = 8'hff; 
				Green = 8'hff; 
				Blue = 8'hff; 
		  end 
		  else if (is_R_Score && Score_data[10'd551 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end 
		  else if (is_E_Score && Score_data[10'd559 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff; 
		  end 
		  else if (is_thousands && Digit_data[10'd535 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end 
		  else if (is_hundreads && Digit_data[10'd543 - DrawX] == 1'b1) begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end 
		  else if (is_tens && Digit_data[10'd551 - DrawX] == 1'b1) begin 
				Red = 8'hff; 
				Green = 8'hff; 
				Blue = 8'hff; 
		  end 
		  else if (is_ones && Digit_data[10'd559 - DrawX] == 1'b1) begin 
				Red = 8'hff; 
				Green = 8'hff;
				Blue = 8'hff; 
		  end 
		  else if(is_pump == 1'b1 && pump_enable == 1'b1)
		  begin 
				Red = 8'h00;
				Green = 8'hee;
				Blue = 8'hff;
		  end 
		  else if((is_rock == 1'b1) && (Delete_rock1 == 1'b0)
					 || (is_rock2 == 1'b1) && (Delete_rock2 == 1'b0)
					 || (is_rock3 == 1'b1) && (Delete_rock3 == 1'b0)
					 || (is_rock4 == 1'b1) && (Delete_rock4 == 1'b0))
		  begin 
				Red = 8'h80; 
				Green = 8'h00; 
				Blue = 8'h80; 
		  end 
        else if((DrawX < 10'd512 & DrawY < 10'd96)) 
        begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff; 
        end
		  else if((DrawX < 10'd512 & DrawY < 10'd192))
		  begin 
				if((dug_state[DrawX/16][(DrawY-10'd96)/16] == 1'b0))
					begin 
						Red = 8'hFF;
						Green = 8'hA9;
						Blue = 8'h33;
					end
				else
					begin 
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'h00; 
					end 
		  end 
		  else if(DrawX < 10'd512 & DrawY < 10'd288)
		  begin 
				if((dug_state[DrawX/16][(DrawY-10'd96)/16] == 1'b0))
					begin 
						Red = 8'hB5;
						Green = 8'h65; 
						Blue = 8'h1D; 
					end
			  	else 
					begin 
						Red = 8'h00;
						Green = 8'h00; 
						Blue = 8'h00; 
					end 
		  end 
		  else if(DrawX < 10'd512 & DrawY < 10'd384)
		  begin 
				if((dug_state[DrawX/16][(DrawY-10'd96)/16] == 1'b0))
					begin 
						Red = 8'hB2;
						Green = 8'h22;
						Blue = 8'h22;
					end 
				else 
					begin 
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'h00; 
					end 
		  end 
		  else if(DrawX < 10'd512)
		  begin
				if((dug_state[DrawX/16][(DrawY-10'd96)/16] == 1'b0))
					begin
						Red = 8'h80;
						Green = 8'h00;
						Blue = 8'h00;
					end 
				else 
					begin 
						Red = 8'h00;
						Green = 8'h00; 
						Blue = 8'h00; 
					end 
		  end 
		  else 
		  begin 
				if ((DrawX >= 10'd527) && (DrawX <= 10'd543) && 
		       (DrawY >= 10'd375) && (DrawY <= 10'd391) && one) begin 
					Red = 8'hff;
					Green = 8'hff; 
					Blue = 8'hff;
				 end
				else if ((DrawX >= 10'd551) && (DrawX <= 10'd567) && 
		       (DrawY >= 10'd375) && (DrawY <= 10'd391) && two) begin 
					Red = 8'hff;
					Green = 8'hff; 
					Blue = 8'hff;
				 end
				else begin 
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end 
		  end 
    end 
endmodule 