
//set up board
reg[11:0] board [3:0][3:0];
reg[11:0] temp;
integer i, j;

initial begin
    for (i = 0; i < 4; i = i+1) begin
        for (j = 0; j < 4; j = j+1) begin
            board[i][j] = 0;
        end
    end
end

task moveUp();
begin
    //dosmth

end