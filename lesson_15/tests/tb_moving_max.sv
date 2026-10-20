// tb_moving_max.sv
// Compare with C++, check gaps and reset
// OlexandrI.B

`timescale 1ns/1ps
module tb_moving_max;
`ifdef PIPELINED
    localparam bit PIPE=1;
`else
    localparam bit PIPE=0;
`endif
    logic clk=0, rst=1, start=0, in_valid=0;
    logic signed [31:0] in_data=0;
    wire in_ready, out_valid, busy, done;
    wire signed [31:0] out_data;
    logic [31:0] vectors[0:511], expected[0:511];
    int cycle=0, sent=0, received=0, frame=0, checks=0;
    int first_cycle, last_cycle, previous_input, min_ii, max_ii, log_file;
    logic passed=0, abort_test=0;
    string scenario="reset";
    always #5 clk=~clk;
    moving_max_ip #(.PIPELINED(PIPE)) dut(.*);

    always @(posedge clk) begin
        cycle++;
        if (!rst && in_valid && in_ready) begin
            if (sent==0) begin first_cycle=cycle; previous_input=cycle; end
            else begin
                if (cycle-previous_input<min_ii) min_ii=cycle-previous_input;
                if (cycle-previous_input>max_ii) max_ii=cycle-previous_input;
                previous_input=cycle;
            end
            sent++;
        end
        #1;
        if (!rst && out_valid && !abort_test) begin
            if (received>=64) $fatal(1,"Too many outputs");
            if (out_data!==expected[frame*64+received])
                $fatal(1,"frame %0d sample %0d: got %0d expected %0d",frame,received,out_data,$signed(expected[frame*64+received]));
            checks++; received++; last_cycle=cycle;
        end
    end
    task automatic reset_ip;
        @(negedge clk); rst=1; start=0; in_valid=0;
        repeat(3) @(negedge clk);
        rst=0;
        repeat(8) @(negedge clk);
        if (busy || out_valid || done) $fatal(1,"Reset did not clear the interface");
    endtask
    task automatic run_frame(input int number, input bit gaps);
        frame=number; sent=0; received=0; min_ii=100000; max_ii=0;
        scenario=gaps?"input_gaps":"continuous";
        @(negedge clk); start=1;
        @(negedge clk); start=0;
        for (int n=0; n<64; n++) begin
            if (gaps && n%5==0) begin
                in_valid=0; repeat(3) @(negedge clk);
            end
            in_valid=1; in_data=vectors[number*64+n];
            @(negedge clk);
            while (sent<=n) @(negedge clk);
        end
        in_valid=0;
        wait(done); @(negedge clk);
        if (received!=64 || busy) $fatal(1,"Incomplete frame");
        if (!gaps && PIPE && (min_ii!=1 || max_ii!=1)) $fatal(1,"Pipeline II is not 1");
        $display("PASS frame %0d: 64 samples, cycles=%0d, input II=%0d..%0d",number,last_cycle-first_cycle+1,min_ii,max_ii);
        $fdisplay(log_file,"%0d,%0d,%0d,%0d,%0d",number,gaps,last_cycle-first_cycle+1,min_ii,max_ii);
        repeat(10) @(negedge clk);
        if (out_valid || done) $fatal(1,"Extra result after done");
    endtask
    initial begin
        $readmemh("../vectors.hex",vectors);
        $readmemh("../expected.hex",expected);
        log_file=$fopen(PIPE?"../evidence/pipeline_cycles.csv":"../evidence/plain_cycles.csv","w");
        if (!log_file) $fatal(1,"Cannot open cycle log");
        $fdisplay(log_file,"frame,gaps,cycles,min_ii,max_ii");
        reset_ip();
        // ~ Eight vectors without reset between blocks
        for (int n=0; n<8; n++) run_frame(n,0);
        // ~ Input gaps
        run_frame(7,1);
        // ~ Reset during a block
        scenario="reset_mid_frame"; abort_test=1;
        @(negedge clk); start=1;
        @(negedge clk); start=0; in_valid=1; in_data=12345;
        repeat(20) @(negedge clk);
        reset_ip(); abort_test=0;
        run_frame(2,0);
        passed=1;
        $display("ALL RTL TESTS PASSED: pipeline=%0d, %0d samples, 10 frames",PIPE,checks);
        $fclose(log_file); $finish;
    end
    initial begin #1000000; $fatal(1,"Simulation timeout"); end
endmodule
