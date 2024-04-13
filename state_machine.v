
//module
module ee354_2048(Clk, Reset, q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose, up, down, left, right);


//inputs
input Clk, Reset;
input up, down, left, right

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
                        board[i][j] <= 0;
                    end
                end

                board[0][0] <= 1;
                board[1][0] <= 1;
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

            end

            UP:
            begin
            //state transitions

            //data transitions

            end

            DOWN:
            begin
            //state transitions

            //data transitions

            end

            RIGHT:
            begin
            //state transitions

            //data transitions

            end

            LEFT:
            begin
            //state transitions

            //data transitions

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

initial begin
    
end

task moveUp();
begin
    //dosmth

end