module ee354_GCD_top
		(
        input ClkPort,                           // the 100 MHz incoming clock signal
		
		input BtnL, 
        input BtnU, 
        input BtnD, 
        input BtnR,            // the Left, Up, Down, and the Right buttons BtnL, BtnR,
		input BtnC,                              // the center button (this is our reset in most of our designs)
		output hSync, vSync
        output [3:0] vgaR, vgaG, vgaB,
        output QuadSpiFlashCS // Disable the three memory chips
	  );

    wire Reset;
    assign Reset=BtnC;
    wire bright;
	wire[9:0] hc, vc;
	wire up,down,left,right;
	wire [11:0] rgb;
    wire q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose;
	

	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen
	wire [11:0] background;
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	ee354_2048 sc(.Clk(move_clk), .Reset(BtnC), .q_I(q_I), .q_Wait(q_Wait), .q_Up(q_Up), .q_Down(q_Down), .q_Right(q_Right), .q_Left(q_Left), .q_Win(q_Win), .q_Lose(q_Lose), .up(BtnU), .down(BtnD), .left(BtnL), .right(BtnR),
                  .hCount(hc), .vCount(vc), .rgb(rgb), .background(background));
	
	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	
	assign QuadSpiFlashCS = 1'b1;
	


endmodule