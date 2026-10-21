// tb_metronome.v
// Exact tick positions, tempo changes and register access
// OlexandrI.B

`timescale 1ns/1ps
module tb_metronome;
    reg clk=0, reset=1, read=0, write=0;
    reg [1:0] address=0;
    reg [3:0] byteenable=4'hf;
    reg [31:0] writedata=0;
    wire [31:0] readdata;
    wire waitrequest, tick;
    integer checks=0, scenario=0, n;
    reg passed=0;
    // Clock 1 kHz
    always #500000 clk=~clk;
`ifdef BUGGY
    metronome_bug #(.CLK_HZ(1000)) dut(.clk(clk),.reset(reset),.address(address),.read(read),.write(write),
        .byteenable(byteenable),.writedata(writedata),.readdata(readdata),
        .waitrequest(waitrequest),.tick(tick));
`else
    metronome #(.CLK_HZ(1000)) dut(.clk(clk),.reset(reset),.address(address),.read(read),.write(write),
        .byteenable(byteenable),.writedata(writedata),.readdata(readdata),
        .waitrequest(waitrequest),.tick(tick));
`endif
    task check;
        input ok;
        input [511:0] message;
        begin
            if (ok!==1'b1) begin
                $display("FAIL scenario %0d: %0s",scenario,message);
                $fatal(1,"Metronome check failed");
            end
            checks=checks+1;
        end
    endtask
    task reset_dut;
        begin
            @(negedge clk); reset=1; read=0; write=0; byteenable=4'hf;
            #1; check(!tick && dut.ticks==0 && !dut.enabled,"asynchronous reset");
            repeat(3) @(negedge clk);
            reset=0;
        end
    endtask
    task wr;
        input [1:0] addr;
        input [31:0] value;
        begin
            @(negedge clk); address=addr; writedata=value; write=1;
            @(posedge clk); #1; check(!waitrequest,"write accepted");
            @(negedge clk); write=0;
        end
    endtask
    task rd_check;
        input [1:0] addr;
        input [31:0] value;
        begin
            address=addr; read=1; #1;
            check(readdata===value,"register readback");
            read=0;
        end
    endtask
    task observe;
        input integer cycles, period;
        integer k;
        reg expected;
        begin
            for (k=1; k<=cycles; k=k+1) begin
                @(posedge clk); #1;
                expected=(period!=0 && k%period==0);
                if (tick!==expected) begin
                    $display("FAIL scenario %0d: tick at cycle %0d: got %b expected %b",scenario,k,tick,expected);
                    $fatal(1,"Wrong tick position");
                end
                checks=checks+1;
                if (tick) $display("tick: scenario %0d cycle %0d",scenario,k);
            end
        end
    endtask
    initial begin
        // ~ 120 BPM: 500, 1000, 1500, 2000
        scenario=1; reset_dut();
        rd_check(0,120); rd_check(1,0); rd_check(2,0);
        wr(0,120); wr(1,1);
        observe(2000,500); rd_check(2,4);
        $display("PASS 1: BPM=120, ticks at 500/1000/1500/2000");

        // ~ BPM 60 -> 120 during operation
        scenario=2; reset_dut(); wr(0,60); wr(1,1);
        for (n=1; n<=2000; n=n+1) begin
            if (n==401) begin
                @(negedge clk); address=0; writedata=120; write=1;
            end
            if (n==402) begin @(negedge clk); write=0; end
            @(posedge clk); #1;
            check(tick===(n==1000 || n==1500 || n==2000),"tempo change tick position");
            if (tick) $display("tick: scenario 2 cycle %0d",n);
        end
        rd_check(0,120); rd_check(2,3);
        $display("PASS 2: BPM 60 -> 120 at cycle 401, ticks 1000/1500/2000");

        // ~ Disabled for 2000 clocks, then restart
        scenario=3; reset_dut(); wr(0,120);
        observe(2000,0); check(dut.counter==0,"disabled counter stays zero");
        wr(1,1); observe(1000,500); rd_check(2,2);
        wr(1,0); observe(2000,0); rd_check(2,2);
        wr(1,1); rd_check(2,0); observe(500,500); rd_check(2,1);
        $display("PASS 3: disable, retained TICKS, fresh restart");

        // ~ BPM=0 -> 30
        scenario=4; reset_dut(); wr(0,0); rd_check(0,30);
        wr(1,1); observe(4000,2000); rd_check(2,2);
        $display("PASS 4: BPM=0 -> 30, ticks 2000/4000");

        scenario=5; reset_dut(); wr(0,999); rd_check(0,240);
        wr(1,1); observe(1000,250); rd_check(2,4);
        $display("PASS 5: BPM=999 -> 240, period 250");

        scenario=6; reset_dut(); wr(0,137); wr(1,1);
        observe(1748,437); rd_check(2,4);
        $display("PASS 6: BPM=137, floor period 437");

        // ~ Byte enables, read-only and reserved registers
        scenario=7; wr(1,0);
        byteenable=0; wr(0,60); rd_check(0,137);
        byteenable=4'h1; wr(0,60); rd_check(0,60);
        byteenable=4'h2; wr(1,1); rd_check(1,0);
        byteenable=4'hf; wr(2,32'hffffffff); rd_check(2,4);
        wr(0,32'hffffffff); rd_check(0,240); rd_check(3,0);
        wr(1,32'hfffffffe); rd_check(1,0);
        $display("PASS 7: byte enables, read-only TICKS, full-width clamp");
        passed=1;
        $display("ALL UNIT TESTS PASSED: %0d checks, 7 scenarios",checks);
        $finish;
    end
    initial begin #(64'd40000000000); $fatal(1,"Unit test timeout"); end
endmodule
