// tb_expr.sv
// Compare expression results and pipeline latency
// OlexandrI.B

`timescale 1ns / 1ps
module tb_expr;
    logic clk = 0;
    logic [15:0] a = 0, b = 0, c = 0, d = 0;
    wire [31:0] result_plain, result_pipeline;
    logic [31:0] expected1, expected2, expected3;
    int cycles = 0, checks = 0;
    bit passed = 0;

    expr_plain plain (.clk(clk), .a(a), .b(b), .c(c), .d(d), .result(result_plain));
    expr_pipelined pipeline (.clk(clk), .a(a), .b(b), .c(c), .d(d), .result(result_pipeline));
    always #4.375 clk = ~clk;

    // Reference uses wider arithmetic, result is 32 bits like the RTL
    function automatic logic [31:0] expression(input logic [15:0] x, y, z, w);
        logic [63:0] total;
        total = (64'(x) * y) + (64'(z) * w) + (64'(x) * z) + (64'(y) * w);
        return total[31:0];
    endfunction

    // Track the two different latencies
    always @(posedge clk) begin
        expected1 <= expression(a, b, c, d);
        expected2 <= expected1;
        expected3 <= expected2;
        cycles <= cycles + 1;
    end
    always @(negedge clk) begin
        if (cycles >= 3) begin
            if (result_plain !== expected2 || result_pipeline !== expected3)
                $fatal(1, "[FAIL] cycle=%0d plain=%h/%h pipeline=%h/%h", cycles,
                       result_plain, expected2, result_pipeline, expected3);
            checks++;
            $display("[PASS] cycle=%0d plain=%h pipeline=%h", cycles, result_plain, result_pipeline);
        end
    end

    task automatic values(input logic [15:0] x, y, z, w);
        @(negedge clk); #1; a = x; b = y; c = z; d = w;
    endtask

    initial begin
        // ~ Basic values and maximum-width arithmetic
        values(1, 2, 3, 4);
        values(5, 6, 7, 8);
        values(65535, 65535, 65535, 65535);
        values(0, 65535, 1, 0);
        values(256, 257, 1024, 1025);

        // ~ Different inputs every cycle, both versions keep throughput
        for (int i = 0; i < 64; i++)
            values(16'(i * 997), 16'(i * 431 + 1), 16'(i * 257 + 3), 16'(i * 59 + 7));
        repeat(5) @(negedge clk);
        #1;
        passed = 1;
        $display("ALL EXPRESSION TESTS PASSED: %0d paired checks", checks);
        $finish;
    end
    initial begin #2000; $fatal(1, "Expression test timeout"); end
endmodule
