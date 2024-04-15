`timescale 1ns / 1ps

module tb_ee354_2048;

    // Inputs
    reg Clk;
    reg Reset;
    reg up;
    reg down;
    reg left;
    reg right;

    // Outputs
    wire q_I, q_Wait, q_Up, q_Down, q_Right, q_Left, q_Win, q_Lose;

    // Instantiate the Unit Under Test (UUT)
    ee354_2048 uut (
        .Clk(Clk),
        .Reset(Reset),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .q_I(q_I),
        .q_Wait(q_Wait),
        .q_Up(q_Up),
        .q_Down(q_Down),
        .q_Right(q_Right),
        .q_Left(q_Left),
        .q_Win(q_Win),
        .q_Lose(q_Lose)
    );

    // Clock generation
    always #100 Clk = ~Clk;

    // Task to display board
    task display_board;
        integer i, j;
        begin
            $display("Board State:");
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    $write("%d\t", uut.board[i][j]);
                end
                $display("");  // Move to the next line after each row
            end
            $display("");  // Extra line for better readability
        end
    endtask

    // Initial setup and test sequence
    initial begin
        // Initialize Inputs
        Clk = 0;
        Reset = 1;
        up = 0;
        down = 0;
        left = 0;
        right = 0;

        // Reset the system
        #1000;
        Reset = 0;

        // Wait for initial setup
        #1000;
        display_board();  // Display initial board
        
        // Simulate UP movement
        up = 1;
        #200;
        up = 0;
        #1000;
        display_board();  // Display board after UP
        
        // Simulate DOWN movement
        down = 1;
        #200;
        down = 0;
        #1000;
        display_board();  // Display board after DOWN
        
        // Simulate LEFT movement
        left = 1;
        #200;
        left = 0;
        #1000;
        display_board();  // Display board after LEFT
        
        // Simulate RIGHT movement
        right = 1;
        #200;
        right = 0;
        #1000;
        display_board();  // Display board after RIGHT
    end
      
endmodule
