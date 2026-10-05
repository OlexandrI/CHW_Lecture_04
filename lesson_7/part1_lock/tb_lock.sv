// tb_lock.sv
// Check each lock state, wrong digits and debounce
// OlexandrI.B

`timescale 1ns / 1ps
module tb_lock;
    logic clk = 0, rst = 0;
    logic [3:0] digit_in = 0;
    wire unlocked_led;
    int checks = 0;
    bit passed = 0;
    string scenario = "reset";

    lock_controller #(.DEBOUNCE_CYCLES(4)) dut (.*);
    always #10 clk = ~clk;

    task automatic check_state(input logic [1:0] expected, input string name);
        #1;
        if (dut.state !== expected || unlocked_led !== (expected == 3))
            $fatal(1, "[FAIL] %s state=%0d LED=%b", name, dut.state, unlocked_led);
        checks++;
        $display("[PASS] [%s] %s state=%0d LED=%b", scenario, name, dut.state, unlocked_led);
    endtask

    task automatic send_digit(input logic [3:0] value);
        @(negedge clk); digit_in = value;
        repeat(12) @(negedge clk);
        digit_in = 0;
        repeat(12) @(negedge clk);
    endtask

    task automatic reset_lock;
        @(negedge clk); #3; rst = 1;
        check_state(0, "async reset between clock edges");
        @(negedge clk); rst = 0;
        digit_in = 0;
        repeat(12) @(negedge clk);
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        reset_lock();

        // ~ Short input bounces
        scenario = "bounce";
        repeat(5) begin
            digit_in = 5; @(negedge clk);
            digit_in = 0; @(negedge clk);
        end
        repeat(12) @(negedge clk);
        check_state(0, "short bounces do not enter the code");

        // ~ Wrong digit at each step
        scenario = "wrong_first";
        send_digit(4); check_state(0, "wrong first digit -> LOCKED");
        scenario = "wrong_second";
        send_digit(5); check_state(1, "LOCKED -> WAIT_D2");
        send_digit(4); check_state(0, "wrong second digit -> LOCKED");
        scenario = "wrong_third";
        send_digit(5); check_state(1, "first digit again");
        send_digit(3); check_state(2, "WAIT_D2 -> WAIT_D3");
        send_digit(4); check_state(0, "wrong third digit -> LOCKED");

        // ~ Correct code and held digit
        scenario = "correct_code";
        @(negedge clk); digit_in = 5;
        repeat(30) @(negedge clk);
        check_state(1, "held first digit stays in WAIT_D2");
        digit_in = 0; repeat(12) @(negedge clk);
        send_digit(3); check_state(2, "second digit -> WAIT_D3");
        send_digit(7); check_state(3, "third digit -> UNLOCKED");
        send_digit(4); check_state(3, "UNLOCKED remains until reset");

        // ~ Reset after unlock
        scenario = "reset_after_unlock";
        reset_lock();
        passed = 1;
        $display("ALL LOCK TESTS PASSED: %0d checks", checks);
        $finish;
    end
    initial begin #20000; $fatal(1, "Lock test timeout"); end
endmodule
