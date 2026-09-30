`timescale 1ns / 1ps

module tb_counter();

    // all that we need
    reg        clk;
    reg        rst;
    reg        load;
    reg  [3:0] data_in;
    reg        en;
    reg        up_down;
    wire [3:0] count;

    //  Init Device Under Test
    counter dut (
        .clk    (clk),
        .rst    (rst),
        .load   (load),
        .data_in(data_in),
        .en     (en),
        .up_down(up_down),
        .count  (count)
    );

    // Generate clk (10ns)
    always #5 clk = ~clk;

    // Task for output check result
    task automatic check_count(input [3:0] expected, input string name);
        if (count === expected) begin
            $display("[PASS] %s | Should: %0d, Has: %0d", name, expected, count);
        end else begin
            $display("[FAIL] %s | Should: %0d, Has: %0d", name, expected, count);
        end
    endtask

    // maint test block
    initial begin
        // set starting values for all
        clk     = 0;
        rst     = 0;
        load    = 0;
        data_in = 0;
        en      = 0;
        up_down = 0;

        // wait a little
        #15;

        // ~ Do reset
        rst = 1;
        @(posedge clk); #1;
        rst = 0;

        // ~ Check LOAD
        load = 1;
        data_in = 4'd10;
        @(posedge clk); #1;
        load = 0;
        check_count(4'd10, "LOAD value 10");

        // ~ Check count UP
        en = 1;
        up_down = 1;
        
        repeat(3) @(posedge clk); #1;
        check_count(4'd13, "Count up (10 -> 13)");
        // (13 -> 14 -> 15 -> 0)
        repeat(3) @(posedge clk); #1;
        check_count(4'd0, "Count up with edge-crossing (13 -> 0)");

        // ~ Check enable/disable
        en = 0;
        repeat(2) @(posedge clk); #1;
        check_count(4'd0, "Hold value (EN=0 during 2 taps)");

        // ~ Check count down
        en = 1;
        up_down = 0;
        @(posedge clk); #1;
        check_count(4'd15, "Count down with edge-crossing (0 -> 15)");

        // ~ Check LOAD priority
        load = 1;
        data_in = 4'd5;
        en = 1;
        up_down = 1;
        @(posedge clk); #1;
        load = 0;
        en = 0;
        check_count(4'd5, "Priority LOAD vs EN (should be 5, not 16 or 0)");

        // ~ Additional check count down
        load = 1; 
        data_in = 4'd8;
        @(posedge clk); #1;
        load = 0;
        en = 1; 
        up_down = 0;
        @(posedge clk); #1;
        en = 0;
        check_count(4'd7, "Additional: Count down (8 -> 7)");

        // ~ FIN ~
        $display("Simulation ended.");
        $finish;
    end

endmodule
