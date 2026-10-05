// tb_alu.sv
// Check all ALU operations and registered inputs
// OlexandrI.B

`timescale 1ns / 1ps
module tb_alu;
    logic clk = 0, rst = 0, oe = 0;
    logic [3:0] a = 0, b = 0;
    logic [1:0] op = 0;
    wire [3:0] result;
    int checks = 0;
    bit passed = 0;
    alu dut (.*);
    always #5 clk = ~clk;

    task automatic check(input logic [3:0] expected, input string name);
        #1;
        if (result !== expected)
            $fatal(1, "[FAIL] %s expected=%0d result=%0d", name, expected, result);
        checks++;
        $display("[PASS] %s result=%0d", name, result);
    endtask

    task automatic calculate(input logic [3:0] x, y, input logic [1:0] operation,
                             input logic enable_out, input logic [3:0] expected,
                             input string name);
        @(negedge clk); a = x; b = y; op = operation; oe = enable_out;
        repeat(2) @(posedge clk);
        check(expected, name);
    endtask

    initial begin
        // ~ Reset and operations
        #2; rst = 1; check(0, "async reset");
        @(negedge clk); rst = 0;
        calculate(3, 5, 0, 1, 8, "ADD");
        calculate(15, 1, 0, 1, 0, "ADD overflow, 4-bit result");
        calculate(9, 4, 1, 1, 5, "SUB");
        calculate(0, 1, 1, 1, 15, "SUB underflow, 4-bit result");
        calculate(10, 12, 2, 1, 8, "AND");
        calculate(10, 12, 3, 1, 14, "OR");
        calculate(15, 15, 3, 0, 0, "OE=0");

        // ~ Inputs are captured first, output follows on the next clock
        @(negedge clk); a = 2; b = 3; op = 0; oe = 1;
        @(posedge clk); check(0, "first edge still uses previous inputs");
        @(negedge clk); a = 15; b = 15;
        @(posedge clk); check(5, "second edge uses captured 2+3");
        #2; rst = 1; check(0, "reset during operation");
        passed = 1;
        $display("ALL ALU TESTS PASSED: %0d checks", checks);
        $finish;
    end
    initial begin #2000; $fatal(1, "ALU test timeout"); end
endmodule
