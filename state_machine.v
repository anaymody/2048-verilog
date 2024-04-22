`timescale 1ns / 1ps

//module
module ee354_2048(Clk, Reset, q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose, up, down, left, right, hCount, vCount, rgb, background, bright);


//inputs
input Clk, Reset;
input up, down, left, right;
input [9:0] hCount, vCount;
input bright;
	

//outputs
output q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose;
output reg [11:0] rgb;
output reg [11:0] background;

reg[7:0] state;
assign {q_Lose, q_Win, q_Left, q_Right, q_Down, q_Up, q_Wait, q_I} = state;

localparam
I = 8'b00000001, WAIT = 8'b00000010, UP = 8'b00000100, DOWN = 8'b00001000, 
RIGHT = 8'b00010000, LEFT = 8'b00100000, WIN = 8'b01000000, LOSE = 8'b10000000;

reg[10:0] board [3:0][3:0];
integer i, j;
integer placeable, found_11;

//used to check if we should place a new '2'
reg enter_loop;

//select block color depending on value of number block
task BLOCK_COLOR;
    input[1:0] k, l;
    begin
    if (board[k][l] == 11'b00000000000) // blank
        rgb = 12'b0110_0110_0110;
    if (board[k][l] == 11'b00000000001) // 2
        rgb = 12'b1110_1101_1100;
    if (board[k][l] == 11'b00000000010) // 4
        rgb = 12'b1100_1001_1000;
    if (board[k][l] == 11'b00000000100) // 8
        rgb = 12'b1101_1001_0101;
    if (board[k][l] == 11'b00000001000) // 16
        rgb = 12'b1111_1000_0100;
    if (board[k][l] == 11'b00000010000) // 32
        rgb = 12'b1111_0110_0101;
    if (board[k][l] == 11'b00000100000) // 64
        rgb = 12'b1111_0011_0011;
    if (board[k][l] == 11'b00001000000) // 128
        rgb = 12'b1110_1011_0100;
    if (board[k][l] == 11'b00010000000) // 256
        rgb = 12'b1111_1011_0000;
    if (board[k][l] == 11'b00100000000) // 512
        rgb = 12'b1000_1011_0101;
    if (board[k][l] == 11'b01000000000) // 1024
        rgb = 12'b0100_1010_1101;
    if (board[k][l] == 11'b10000000000) // 2048
        rgb = 12'b0001_0101_1101;
    end
endtask

//sets rgb to paint screen via VGA
always @ (*) begin
    if (~bright)
        rgb = 12'b0000_0000_0000;

    // key at the top
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 130) && (hCount <= 170) )
        rgb = 12'b1110_1101_1100;   // 2
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 180) && (hCount <= 220) )
        rgb = 12'b1100_1001_1000;   // 4
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 230) && (hCount <= 270) )
        rgb = 12'b1101_1001_0101;   // 8
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 280) && (hCount <= 320) )
        rgb = 12'b1111_1000_0100;   // 16
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 330) && (hCount <= 370) )
        rgb = 12'b1111_0110_0101;   // 32
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 380) && (hCount <= 420) )
        rgb = 12'b1111_0011_0011;   // 64
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 430) && (hCount <= 470) )
        rgb = 12'b1110_1011_0100;   // 128
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 480) && (hCount <= 520) )
        rgb = 12'b1111_1011_0000;   // 256
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 530) && (hCount <= 570) )
        rgb = 12'b1000_1011_0101;   // 512
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 580) && (hCount <= 620) )
        rgb = 12'b0100_1010_1101;   // 1024
    else if ( (vCount >= 20) && (vCount <= 60) && (hCount >= 630) && (hCount <= 670) )
        rgb = 12'b0001_0101_1101;   // 2048

    //all blocks on board
    else if ( (vCount >= 180) && (vCount <= 220) && (hCount >= 380) && (hCount <= 420) )
        BLOCK_COLOR(0,0);
    else if ( (vCount >= 180) && (vCount <= 220) && (hCount >= 425) && (hCount <= 465) )
        BLOCK_COLOR(0,1);
    else if ( (vCount >= 180) && (vCount <= 220) && (hCount >= 470) && (hCount <= 510) )
        BLOCK_COLOR(0,2);
    else if ( (vCount >= 180) && (vCount <= 220) && (hCount >= 515) && (hCount <= 555) )
        BLOCK_COLOR(0,3);

    else if ( (vCount >= 225) && (vCount <= 265) && (hCount >= 380) && (hCount <= 420) )
        BLOCK_COLOR(1,0);
    else if ( (vCount >= 225) && (vCount <= 265) && (hCount >= 425) && (hCount <= 465) )
        BLOCK_COLOR(1,1);
    else if ( (vCount >= 225) && (vCount <= 265) && (hCount >= 470) && (hCount <= 510) )
        BLOCK_COLOR(1,2);
    else if ( (vCount >= 225) && (vCount <= 265) && (hCount >= 515) && (hCount <= 555) )
        BLOCK_COLOR(1,3);

    else if ( (vCount >= 270) && (vCount <= 310) && (hCount >= 380) && (hCount <= 420) )
        BLOCK_COLOR(2,0);
    else if ( (vCount >= 270) && (vCount <= 310) && (hCount >= 425) && (hCount <= 465) )
        BLOCK_COLOR(2,1);
    else if ( (vCount >= 270) && (vCount <= 310) && (hCount >= 470) && (hCount <= 510) )
        BLOCK_COLOR(2,2);
    else if ( (vCount >= 270) && (vCount <= 310) && (hCount >= 515) && (hCount <= 555) )
        BLOCK_COLOR(2,3);

    else if ( (vCount >= 315) && (vCount <= 355) && (hCount >= 380) && (hCount <= 420) )
        BLOCK_COLOR(3,0);
    else if ( (vCount >= 315) && (vCount <= 355) && (hCount >= 425) && (hCount <= 465) )
        BLOCK_COLOR(3,1);
    else if ( (vCount >= 315) && (vCount <= 355) && (hCount >= 470) && (hCount <= 510) )
        BLOCK_COLOR(3,2);
    else if ( (vCount >= 315) && (vCount <= 355) && (hCount >= 515) && (hCount <= 555) )
        BLOCK_COLOR(3,3);

    else
        rgb=background;
end

always @ (posedge Clk, posedge Reset)
begin
    if(Reset)
    begin
        state <= I;
        background <= 12'b1111_1111_1111;

    end

    else
        case(state)
            I:
            begin
            //state transitions
            state <= WAIT;
            enter_loop <= 1;
            //data transitions



                for (i = 0; i < 4; i = i+1) begin
                    for (j = 0; j < 4; j = j+1) begin
                        board[i][j] <= 11'b00000000000;
                    end
                end

                board[0][0] <= 11'b00000000001;
            end

            WAIT:
            begin
                //state transitions
                if (up)
                    state <= UP;
                else if (down)
                    state <= DOWN;
                else if (left)
                    state <= LEFT;
                else if (right)
                    state <= RIGHT;
                //data transitions
                placeable = 0;
                found_11 = 0;
                
    
                for (i = 0; i < 4; i = i+1) begin
                    for (j = 0; j < 4; j = j+1) begin
                        if (board[i][j] == 0) begin
                            placeable = 1;
                            //only place 1 if we have enter_loop from another state
                            if (enter_loop == 1) begin
                                board[i][j] <= 11'b00000000001;
                                enter_loop = 0;
                            end
                        end
                        else if (board[i][j] == 11'b10000000000) begin
                            found_11 = 1;
                            enter_loop = 0;
                        end
                            
                    end
                end
                    
                
                
                if (found_11)
                    state <= WIN;
                else if (!placeable)
                    state <= LOSE;

            end

            UP:
            begin
            //state transitions
                state <= WAIT;
                enter_loop <= 1;

            //data transitions

            //row 2
            for (j = 0; j<4; j=j+1) begin
                if(board[0][j] == 11'b00000000000) begin
                    board[0][j] = board[1][j];
                    board[1][j] = 11'b00000000000;
                end
                else if (board[0][j] == board[1][j]) begin
                    board[0][j] = board[0][j] << 1;
                    board[1][j] = 11'b00000000000;
                end
            end

           //row 3
            for (j = 0; j<4; j=j+1) begin
                if(board[1][j] == 11'b00000000000) begin
                    board[1][j] = board[2][j];
                    board[2][j] = 11'b00000000000;
                end

                else if (board[1][j] == board[2][j]) begin
                    board[1][j] = board[1][j] << 1;
                    board[2][j] = 11'b00000000000;
                end

                if(board[0][j] == 11'b00000000000) begin
                    board[0][j] = board[1][j];
                    board[1][j] = 11'b00000000000;
                end

                else if (board[0][j] == board[1][j]) begin
                    board[0][j] = board[0][j] << 1;
                    board[1][j] = 11'b00000000000;
                end

            end

           //row 4
            for (j = 0; j<4; j=j+1) begin
                if(board[2][j] == 11'b00000000000) begin
                    board[2][j] = board[3][j];
                    board[3][j] = 11'b00000000000;
                end

                else if (board[2][j] == board[3][j]) begin
                    board[2][j] = board[2][j] << 1;
                    board[3][j] = 11'b00000000000;
                end

                if(board[1][j] == 11'b00000000000) begin
                    board[1][j] = board[2][j];
                    board[2][j] = 11'b00000000000;
                end

                else if (board[1][j] == board[2][j]) begin
                    board[1][j] = board[1][j] << 1;
                    board[2][j] = 11'b00000000000;
                end

                if(board[0][j] == 11'b00000000000) begin
                    board[0][j] = board[1][j];
                    board[1][j] = 11'b00000000000;
                end

                else if (board[0][j] == board[1][j]) begin
                    board[0][j] = board[0][j] << 1;
                    board[1][j] = 11'b00000000000;
                end
            end

            

            end

            DOWN:
            begin
            //state transitions
            state <= WAIT;
            enter_loop <= 1;

            //data transitions
            //row 3
            for (j = 0; j<4; j=j+1) begin
                if(board[3][j] == 11'b00000000000) begin
                    board[3][j] = board[2][j];
                    board[2][j] = 11'b00000000000;
                end
                else if (board[3][j] == board[2][j]) begin
                    board[3][j] = board[3][j] << 1;
                    board[2][j] = 11'b00000000000;
                end
            end

           //row 2
            for (j = 0; j<4; j=j+1) begin
                if(board[2][j] == 11'b00000000000) begin
                    board[2][j] = board[1][j];
                    board[1][j] = 11'b00000000000;
                end

                else if (board[2][j] == board[1][j]) begin
                    board[2][j] = board[2][j] << 1;
                    board[1][j] = 11'b00000000000;
                end

                if(board[3][j] == 11'b00000000000) begin
                    board[3][j] = board[2][j];
                    board[2][j] = 11'b00000000000;
                end
                else if (board[3][j] == board[2][j]) begin
                    board[3][j] = board[3][j] << 1;
                    board[2][j] = 11'b00000000000;
                end

            end

           //row 1
            for (j = 0; j<4; j=j+1) begin
                if(board[1][j] == 11'b00000000000) begin
                    board[1][j] = board[0][j];
                    board[0][j] = 11'b00000000000;
                end

                else if (board[1][j] == board[0][j]) begin
                    board[1][j] = board[1][j] << 1;
                    board[0][j] = 11'b00000000000;
                end

                if(board[2][j] == 11'b00000000000) begin
                    board[2][j] = board[1][j];
                    board[1][j] = 11'b00000000000;
                end

                else if (board[2][j] == board[1][j]) begin
                    board[2][j] = board[2][j] << 1;
                    board[1][j] = 11'b00000000000;
                end

                if(board[3][j] == 11'b00000000000) begin
                    board[3][j] = board[2][j];
                    board[2][j] = 11'b00000000000;
                end
                else if (board[3][j] == board[2][j]) begin
                    board[3][j] = board[3][j] << 1;
                    board[2][j] = 11'b00000000000;
                end
               
            end


            end

            LEFT:
            begin
            //state transitions
            state <= WAIT;
            enter_loop <= 1;
            //data transitions
            //col 2
            for (i = 0; i<4; i=i+1) begin
                if(board[i][0] == 11'b00000000000) begin
                    board[i][0] = board[i][1];
                    board[i][1] = 11'b00000000000;
                end
                else if (board[i][0] == board[i][1]) begin
                    board[i][0] = board[i][0] << 1;
                    board[i][1] = 11'b00000000000;
                end
            end

           //col 3
            for (i = 0; i<4; i=i+1) begin
                if(board[i][1] == 11'b00000000000) begin
                    board[i][1] = board[i][2];
                    board[i][2] = 11'b00000000000;
                end

                else if (board[i][1] == board[i][2]) begin
                    board[i][1] = board[i][1] << 1;
                    board[i][2] = 11'b00000000000;
                end

                if(board[i][0] == 11'b00000000000) begin
                    board[i][0] = board[i][1];
                    board[i][1] = 11'b00000000000;
                end

                else if (board[i][0] == board[i][1]) begin
                    board[i][0] = board[i][0] << 1;
                    board[i][1] = 11'b00000000000;
                end

            end

           //col 4
            for (i = 0; i<4; i=i+1) begin
                if(board[i][2] == 11'b00000000000) begin
                    board[i][2] = board[i][3];
                    board[i][3] = 11'b00000000000;
                end

                else if (board[i][2] == board[i][3]) begin
                    board[i][2] = board[i][2] << 1;
                    board[i][3] = 11'b00000000000;
                end

                if(board[i][1] == 11'b00000000000) begin
                    board[i][1] = board[i][2];
                    board[i][2] = 11'b00000000000;
                end

                else if (board[i][1] == board[i][2]) begin
                    board[i][1] = board[i][1] << 1;
                    board[i][2] = 11'b00000000000;
                end

                if(board[i][0] == 11'b00000000000) begin
                    board[i][0] = board[i][1];
                    board[i][1] = 11'b00000000000;
                end

                else if (board[i][0] == board[i][1]) begin
                    board[i][0] = board[i][0] << 1;
                    board[i][1] = 11'b00000000000;
                end
            end

            end

            RIGHT:
            begin
            //state transitions
            state <= WAIT;
            enter_loop <= 1;
            //data transitions
            //col 3
            for (i = 0; i<4; i=i+1) begin
                if(board[i][3] == 11'b00000000000) begin
                    board[i][3] = board[i][2];
                    board[i][2] = 11'b00000000000;
                end
                else if (board[i][3] == board[i][2]) begin
                    board[i][3] = board[i][3] << 1;
                    board[i][2] = 11'b00000000000;
                end
            end

           //col 2
            for (i = 0; i<4; i=i+1) begin
                if(board[i][2] == 11'b00000000000) begin
                    board[i][2] = board[i][1];
                    board[i][1] = 11'b00000000000;
                end

                else if (board[i][2] == board[i][1]) begin
                    board[i][2] = board[i][2] << 1;
                    board[i][1] = 11'b00000000000;
                end

                if(board[i][3] == 11'b00000000000) begin
                    board[i][3] = board[i][2];
                    board[i][2] = 11'b00000000000;
                end
                else if (board[i][3] == board[i][2]) begin
                    board[i][3] = board[i][3] << 1;
                    board[i][2] = 11'b00000000000;
                end

            end

           //col 1
            for (i = 0; i<4; i=i+1) begin
                if(board[i][1] == 11'b00000000000) begin
                    board[i][1] = board[i][0];
                    board[i][0] = 11'b00000000000;
                end

                else if (board[i][1] == board[i][0]) begin
                    board[i][1] = board[i][1] << 1;
                    board[i][0] = 11'b00000000000;
                end

                if(board[i][2] == 11'b00000000000) begin
                    board[i][2] = board[i][1];
                    board[i][1] = 11'b00000000000;
                end

                else if (board[i][2] == board[i][1]) begin
                    board[i][2] = board[i][2] << 1;
                    board[i][1] = 11'b00000000000;
                end

                if(board[i][3] == 11'b00000000000) begin
                    board[i][3] = board[i][2];
                    board[i][2] = 11'b00000000000;
                end
                else if (board[i][3] == board[i][2]) begin
                    board[i][3] = board[i][3] << 1;
                    board[i][2] = 11'b00000000000;
                end
            end

            end

            WIN:
            begin
                background <= 12'b0000_1000_0000;
           
            

            end

            LOSE:
            begin
                background <= 12'b1000_0000_0000;

            end
        endcase

end

endmodule

