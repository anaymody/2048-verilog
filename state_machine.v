
//module
module ee354_2048(Clk, Reset, q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose, up, down, left, right);


//inputs
input Clk, Reset;
input up, down, left, right;

//outputs
output q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose;
reg[7:0] state;
assign {q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose} = state;

localparam
I = 8'b00000001, WAIT = 8'b00000010, UP = 8'b00000100, DOWN = 8'b00001000, 
RIGHT = 8'b00010000, LEFT = 8'b00100000, WIN = 8'b01000000, LOSE = 8'b10000000;

reg[10:0] board [3:0][3:0];
reg[10:0] temp;
integer i, j;
integer placeable, found_11;

always @ (posedge Clk, posedge Reset)
begin
    if(Reset)
    begin
        state <= I;
    end

    else
        case(state)
            I:
            begin
            //state transitions
            state <= WAIT;
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
                if (left)
                    state <= LEFT;
                if (right)
                    state <= RIGHT;
                //data transitions
                placeable = 0;
                found_11 = 0;
                for (i = 0; i < 4; i = i+1) begin
                    for (j = 0; j < 4; j = j+1) begin
                        if (board[i][j] == 0) begin
                            placeable = 1;
                            board[i][j] <= 11'b00000000001;
                            break;
                        end
                        else if (board[i][j] == 11'b10000000000)
                            found_11 = 1;
                    end
                    if (placeable || found_11)
                        break;
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

            //data transitions
            //row 3
            for (j = 0; j<4; j=j+1) begin
                if(board[3][j] == 11'b00000000000) begin
                    board[3][j] = board[2][j];
                    board[2][j] = 11'b00000000000;
                end
                else if (board[0][j] == board[1][j]) begin
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
                else if (board[0][j] == board[1][j]) begin
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

                else if (board[2][j] == board[3][j]) begin
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
                else if (board[0][j] == board[1][j]) begin
                    board[3][j] = board[3][j] << 1;
                    board[2][j] = 11'b00000000000;
                end
               
            end


            end

            LEFT:
            begin
            //state transitions
            state <= WAIT;
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
            //state transitions
           
            //data transitions

            end

            LOSE:
            begin
            //state transitions
           
            //data transitions

            end
        endcase

end

endmodule

