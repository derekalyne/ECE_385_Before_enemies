module pump(input [7:0]      keycode, 
				input [7:0]      last_key_press,
				input [9:0]      DrawX, 
				input [9:0]      DrawY, 
				input [9:0]      Ball_X_Loc, 
				input [9:0]      Ball_Y_Loc, 
				output           pump_enable,
				output           is_pump);
	always_comb 
	begin
		if(keycode == 8'd44)
			pump_enable = 1'b1;
		else 
			pump_enable = 1'b0; 
	end 
	always_comb
	begin 
		if (last_key_press == 8'd26)begin // W was pressed 
			if( DrawY >= (Ball_Y_Loc-10'd24) && DrawY <= (Ball_Y_Loc-10'd8)
				 && DrawX <= (Ball_X_Loc+10'd4) && DrawX >=(Ball_X_Loc-10'd4))
				 is_pump = 1'b1; 
			else 
				 is_pump = 1'b0; 
		end 
		else if (last_key_press == 8'd22 && (Ball_Y_Loc+10'd24) < 10'd480)begin // s was pressed 
			if ( DrawY >=(Ball_Y_Loc+10'd8) && DrawY <= (Ball_Y_Loc+10'd24) 
			     && DrawX >= (Ball_X_Loc-10'd4) && DrawX <= (Ball_X_Loc+10'd4))
				 is_pump = 1'b1; 
			else 
				 is_pump = 1'b0; 
		end
		else if (last_key_press == 8'd7 && (Ball_X_Loc+10'd24) < 10'd512)begin // d was pressed 
			if( DrawY <= (Ball_Y_Loc+10'd4) && DrawY >= (Ball_Y_Loc-10'd4) 
				 && DrawX <=(Ball_X_Loc+10'd24) && DrawX >= (Ball_X_Loc+10'd8))
				 is_pump = 1'b1;
			else 
				 is_pump = 1'b0; 
		end
		else if(last_key_press == 8'd4 && (Ball_X_Loc) > 10'd23)begin  // A was pressed 
			if( DrawY >= (Ball_Y_Loc-10'd4) && DrawY <= (Ball_Y_Loc+10'd4)
				 && DrawX >= (Ball_X_Loc-10'd24) && DrawX <= (Ball_X_Loc-10'd8))
				 is_pump = 1'b1;
			else 
				 is_pump = 1'b0; 
		end  
		else begin 
				 is_pump = 1'b0; 
		end 
	end 
endmodule 