// tb_array.v
// Array function with synchronous RAM
// OlexandrI.B

`timescale 1ns/1ps
module tb_array;
    reg clock=0, reset=1, start_port=0;
    wire done_port;
    reg [31:0] in_q0=0, in_q1=0;
    wire [5:0] in_address0, in_address1, out_address0, out_address1;
    wire in_ce0, in_ce1, out_ce0, out_ce1, out_we0, out_we1;
    wire [31:0] out_d0, out_d1;
    reg [31:0] vectors[0:511], expected[0:511];
    reg [63:0] written;
    integer n, frame=0, reads=0, writes=0, checks=0, cycles=0, frame_start;
    integer read_count[0:63];
    reg passed=0;
    always #5 clock=~clock;
    _Z10moving_maxPiS_ dut(
        .clock(clock), .reset(reset), .start_port(start_port), .done_port(done_port),
        .in_q0(in_q0), .in_q1(in_q1), .in_address0(in_address0), .in_address1(in_address1),
        .in_ce0(in_ce0), .in_ce1(in_ce1),
        .out_address0(out_address0), .out_address1(out_address1),
        .out_ce0(out_ce0), .out_ce1(out_ce1), .out_we0(out_we0), .out_we1(out_we1),
        .out_d0(out_d0), .out_d1(out_d1)
    );
    always @(posedge clock) begin
        cycles=cycles+1;
        if (!reset) begin
            if (in_ce0) begin
                in_q0<=vectors[frame*64+in_address0];
                reads=reads+1; read_count[in_address0]=read_count[in_address0]+1;
            end
            if (in_ce1) begin
                in_q1<=vectors[frame*64+in_address1];
                reads=reads+1; read_count[in_address1]=read_count[in_address1]+1;
            end
            if (out_ce0 && out_we0) begin
                if (out_d0!==expected[frame*64+out_address0])
                    $fatal(1,"Array output mismatch: frame %0d address %0d",frame,out_address0);
                written[out_address0]=1; writes=writes+1; checks=checks+1;
            end
            if (out_ce1 && out_we1) begin
                if (out_d1!==expected[frame*64+out_address1])
                    $fatal(1,"Array output mismatch: frame %0d address %0d",frame,out_address1);
                written[out_address1]=1; writes=writes+1; checks=checks+1;
            end
        end
    end
    initial begin
        $readmemh("../vectors.hex",vectors);
        $readmemh("../expected.hex",expected);
        repeat(4) @(negedge clock); reset=0;
        // ~ Eight vectors, one read per address
        for (frame=0; frame<8; frame=frame+1) begin
            reads=0; writes=0; written=0;
            for (n=0; n<64; n=n+1) read_count[n]=0;
            @(negedge clock); start_port=1; frame_start=cycles;
            @(negedge clock); start_port=0;
            wait(done_port); @(negedge clock);
            if (reads!=64 || writes!=64 || written!==64'hffffffffffffffff)
                $fatal(1,"Array access count: reads=%0d writes=%0d",reads,writes);
            for (n=0; n<64; n=n+1)
                if (read_count[n]!=1) $fatal(1,"Address %0d read %0d times",n,read_count[n]);
            $display("PASS array frame %0d: 64 reads, 64 writes, cycles=%0d",frame,cycles-frame_start);
            repeat(6) @(negedge clock);
        end
        passed=1;
        $display("ALL ARRAY TESTS PASSED: %0d samples, each input read once",checks);
        $finish;
    end
    initial begin #1000000; $fatal(1,"Array simulation timeout"); end
endmodule
