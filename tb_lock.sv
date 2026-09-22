`timescale 1ns / 1ps

module tb_lock();

    logic       clk;
    logic       rst;
    logic [3:0] digit_in;
    logic       unlocked_led;

    lock_controller dut (.*);

    // clock generator
    always #5 clk = ~clk;

    task send_digit(input [3:0] d);
        digit_in = d;
        repeat(4) @(posedge clk);
        digit_in = 4'd0;
        repeat(4) @(posedge clk);
    endtask

    initial begin
        clk = 0; rst = 0; digit_in = 0;
        
        // reset
        rst = 1; repeat(2) @(posedge clk); rst = 0;
        
        $display("=== Test1 1: Incorect combination (5 -> 4) ===");
        send_digit(4'd5); // go to WAIT_D2
        send_digit(4'd4); // error, back to LOCKED
        
        if (unlocked_led == 0) $display("[PASS] Still locked.");
        else $display("[FAIL] Now inlocked, incorect!");

        repeat(5) @(posedge clk);

        $display("=== Test2 2: Correct combination (5 -> 3 -> 7) ===");
        send_digit(4'd5);
        send_digit(4'd3);
        send_digit(4'd7);

        repeat(2) @(posedge clk);
        if (unlocked_led == 1) $display("[PASS] Unlocked!");
        else $display("[FAIL] Still locked, sad :(");

        $finish;
    end
endmodule
