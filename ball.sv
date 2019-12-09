//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [7:0]   keycode,            // Keycode input from keyboard
					input [9:0]   Rock_X_Loc,
				   input [9:0]   Rock2_X_Loc, 
				   input [9:0]   Rock3_X_Loc,
					input [9:0]   Rock4_X_Loc,
					input [9:0]   Rock_Y_Loc,
				   input [9:0]   Rock2_Y_Loc,
			      input [9:0]   Rock3_Y_Loc,
		         input [9:0]   Rock4_Y_Loc,			
					input         delete_rock,
					input         delete_rock2,
					input         delete_rock3,
				   input         delete_rock4, 	
					input         is_killed, 
               output logic  is_ball,             // Whether current pixel belongs to ball or background
					output logic [9:0]  Ball_X_Loc,
					output logic [9:0]  Ball_Y_Loc,
					output logic  kill_dug,
					output logic [7:0] last_key_press
              );
    
    parameter [9:0] Ball_X_Center = 10'd0;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd83;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd511;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd78;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd8;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in; 
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset | is_killed)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0; 
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
				
				Ball_X_Loc <= Ball_X_Pos; 
				Ball_Y_Loc <= Ball_Y_Pos;
				
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in; 
        end
    end
	 
	 always_ff @(posedge Clk)
	 begin 
			if(frame_clk_rising_edge)begin 
				case(keycode)
					8'd26:
						last_key_press <= 8'd26; 
					8'd4:
						last_key_press <= 8'd4;
					8'd22:
						last_key_press <= 8'd22;
					8'd7:
						last_key_press <= 8'd7; 
				endcase 
			end 
	 end 
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				// Update motion in response to keypress
				case(keycode)
					8'd26:  // W has been pressed
						begin
							/* Set motion to vertical negative */
							Ball_X_Motion_in = 10'b0;
							Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
						end
					8'd4:  // A has been pressed
						begin
							/* Set motion to horizontal negative */
							Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
							Ball_Y_Motion_in = 10'b0;
						end
					8'd22:  // S has been pressed
						begin
							/* Set motion to vertical positive */
							Ball_X_Motion_in = 10'b0;
							Ball_Y_Motion_in = Ball_Y_Step;
						end
					8'd7:  // D has been pressed
						begin
							/* Set motion to horizontal positive */
							Ball_X_Motion_in = Ball_X_Step;
							Ball_Y_Motion_in = 10'b0;
						end
					default:
						begin
							Ball_X_Motion_in = 10'b0;
							Ball_Y_Motion_in = 10'b0;
						end
				endcase
				
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
            if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
            else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
                Ball_Y_Motion_in = Ball_Y_Step;
            // TODO: Add other boundary detections and handle keypress here.
				else if ( Ball_X_Pos + Ball_Size >= Ball_X_Max )  // Ball is at right edge, BOUNCE! :D
					 Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); // 2's complement.
				else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at left edge, BOUNCE! :D
					 Ball_X_Motion_in = Ball_X_Step;
					 
				if (delete_rock == 1'b0) begin 
					if ((Ball_X_Pos + 10'd8 >= Rock_X_Loc-10'd8) && (Ball_X_Pos <= (Rock_X_Loc + 10'd8))
								&& (Ball_Y_Pos  >= (Rock_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock_Y_Loc+10'd8)))
							Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); 
					else if ( (Ball_X_Pos-10'd8 <= Rock_X_Loc+10'd8) && (Ball_X_Pos >= (Rock_X_Loc - 10'd8))
								&& (Ball_Y_Pos >= (Rock_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock_Y_Loc+10'd8)))
							Ball_X_Motion_in = Ball_X_Step;
					else if ( (Ball_X_Pos+10'd8 >= Rock_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock_X_Loc +10'd8)
								&& (Ball_Y_Pos+10'd8 >= Rock_Y_Loc-10'd8) && (Ball_Y_Pos <= Rock_Y_Loc+10'd8))
							Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1); 
				end 
				if (delete_rock2 == 1'b0) begin 
					if ((Ball_X_Pos + 10'd8 >= Rock2_X_Loc-10'd8) && (Ball_X_Pos <= (Rock2_X_Loc + 10'd8))
								&& (Ball_Y_Pos  >= (Rock2_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock2_Y_Loc+10'd8)))
							Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); 
					else if ( (Ball_X_Pos-10'd8 <= Rock2_X_Loc+10'd8) && (Ball_X_Pos >= (Rock2_X_Loc - 10'd8))
								&& (Ball_Y_Pos >= (Rock2_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock2_Y_Loc+10'd8)))
							Ball_X_Motion_in = Ball_X_Step;
					else if ( (Ball_X_Pos+10'd8 >= Rock2_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock2_X_Loc +10'd8)
								&& (Ball_Y_Pos+10'd8 >= Rock2_Y_Loc-10'd8) && (Ball_Y_Pos <= Rock2_Y_Loc+10'd8))
							Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
				end 
				if(delete_rock3 == 1'b0) begin 
					if ((Ball_X_Pos + 10'd8 >= Rock3_X_Loc-10'd8) && (Ball_X_Pos <= (Rock3_X_Loc + 10'd8))
								&& (Ball_Y_Pos  >= (Rock3_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock3_Y_Loc+10'd8)))
							Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); 
					else if ( (Ball_X_Pos-10'd8 <= Rock3_X_Loc+10'd8) && (Ball_X_Pos >= (Rock3_X_Loc - 10'd8))
								&& (Ball_Y_Pos >= (Rock3_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock3_Y_Loc+10'd8)))
							Ball_X_Motion_in = Ball_X_Step;
					else if ( (Ball_X_Pos+10'd8 >= Rock3_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock3_X_Loc +10'd8)
								&& (Ball_Y_Pos+10'd8 >= Rock3_Y_Loc-10'd8) && (Ball_Y_Pos <= Rock3_Y_Loc+10'd8))
							Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
				end 
				if(delete_rock4 == 1'b0) begin 
					if ((Ball_X_Pos + 10'd8 >= Rock4_X_Loc-10'd8) && (Ball_X_Pos <= (Rock4_X_Loc + 10'd8))
								&& (Ball_Y_Pos  >= (Rock4_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock4_Y_Loc+10'd8)))
							Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); 
					else if ( (Ball_X_Pos-10'd8 <= Rock4_X_Loc+10'd8) && (Ball_X_Pos >= (Rock4_X_Loc - 10'd8))
								&& (Ball_Y_Pos >= (Rock4_Y_Loc-10'd8)) && (Ball_Y_Pos <=(Rock4_Y_Loc+10'd8)))
							Ball_X_Motion_in = Ball_X_Step;
					else if ( (Ball_X_Pos+10'd8 >= Rock4_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock4_X_Loc +10'd8)
								&& (Ball_Y_Pos+10'd8 >= Rock4_Y_Loc-10'd8) && (Ball_Y_Pos <= Rock4_Y_Loc+10'd8))
							Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
				end 
				// Update the ball's position with its motion
				Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
				Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;	
        end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    always_comb 
		begin 
			if ( (Ball_X_Pos+10'd8 >= Rock_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock_X_Loc +10'd8)
								&& (Ball_Y_Pos-10'd8 <= Rock_Y_Loc+10'd8) && (Ball_Y_Pos+10'd8 >= Rock_Y_Loc-10'd8)) 
					kill_dug = 1'b1;  
			else if ((Ball_X_Pos+10'd8 >= Rock2_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock2_X_Loc +10'd8)
								&& (Ball_Y_Pos-10'd8 <= Rock2_Y_Loc+10'd8) && (Ball_Y_Pos+10'd8 >= Rock2_Y_Loc-10'd8))
					kill_dug = 1'b1; 
			else if ((Ball_X_Pos+10'd8 >= Rock3_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock3_X_Loc +10'd8)
								&& (Ball_Y_Pos-10'd8 <= Rock3_Y_Loc+10'd8) && (Ball_Y_Pos+10'd8 >= Rock3_Y_Loc-10'd8))
					kill_dug = 1'b1; 
			else if ((Ball_X_Pos+10'd8 >= Rock4_X_Loc-10'd8) && (Ball_X_Pos-10'd8 <= Rock4_X_Loc +10'd8)
								&& (Ball_Y_Pos-10'd8 <= Rock4_Y_Loc+10'd8) && (Ball_Y_Pos+10'd8 >= Rock4_Y_Loc-10'd8))
					kill_dug = 1'b1;
			else 
					kill_dug = 1'b0; 
		end 
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    //assign DistX = DrawX - Ball_X_Pos;
    //assign DistY = DrawY - Ball_Y_Pos;
    always_comb begin
        if ((DrawX >= (Ball_X_Pos-10'd8)) && (DrawX <= (Ball_X_Pos+10'd8)) && 
		       (DrawY >= (Ball_Y_Pos-10'd8)) && (DrawY <= (Ball_Y_Pos+10'd8)) ) 
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
endmodule
