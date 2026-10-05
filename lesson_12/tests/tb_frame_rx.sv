// tb_frame_rx.sv
// Check packing, asynchronous clocks, stalls and reset
// OlexandrI.B

`timescale 1ns/1ps
module tb_frame_rx;
    logic clk=0, pixel_clk=0, reset_n=0, pixel_reset_n=0, start=0;
    logic [7:0] pixel_data=0;
    logic pixel_valid=0, m_axis_tready=0;
    wire pixel_ready, busy, m_axis_tvalid, m_axis_tlast, m_axis_sop;
    wire [31:0] m_axis_tdata, words_sent;
    wire [3:0] m_axis_tkeep;
    int received=0, stalls=0, checks=0, seed=0;
    logic passed=0;
    string scenario="reset";
    logic held=0;
    logic [37:0] held_word;
    always #10 clk=~clk;
    always #17 pixel_clk=~pixel_clk; // deliberately unrelated clocks
    frame_rx #(.FRAME_BYTES(512), .FIFO_WORDS(8)) dut(.*);
    function automatic logic [7:0] value(input int i);
        return 8'(i*13+7+seed*31);
    endfunction
    always @(posedge clk) begin
        if (!reset_n) held=0;
        else begin
            if (held && {m_axis_sop,m_axis_tlast,m_axis_tkeep,m_axis_tdata} !== held_word)
                $fatal(1,"AXIS changed under backpressure");
            held=m_axis_tvalid && !m_axis_tready;
            held_word={m_axis_sop,m_axis_tlast,m_axis_tkeep,m_axis_tdata};
            if (m_axis_tvalid && m_axis_tready) begin
                if (m_axis_tdata !== {value(received*4+3),value(received*4+2),value(received*4+1),value(received*4)})
                    $fatal(1,"wrong word %0d: %h",received,m_axis_tdata);
                if (m_axis_tkeep != 15 || m_axis_tlast != (received==127) || m_axis_sop != (received==0))
                    $fatal(1,"wrong frame metadata %0d",received);
                received++;
            end
        end
    end
    task automatic check(input bit ok, input string message);
        if (!ok) $fatal(1,"FAIL [%s] %s",scenario,message);
        checks++; $display("PASS [%s] %s",scenario,message);
    endtask
    task automatic byte_in(input logic [7:0] data);
        @(negedge pixel_clk); pixel_valid=1; pixel_data=data;
        do begin @(posedge pixel_clk); if (!pixel_ready) stalls++; end while (!pixel_ready);
        @(negedge pixel_clk); pixel_valid=0;
    endtask
    task automatic reset_all;
        reset_n=0; pixel_reset_n=0; start=0; pixel_valid=0; m_axis_tready=0;
        repeat(10) @(negedge clk); reset_n=1;
        @(negedge pixel_clk); pixel_reset_n=1;
        repeat(10) @(negedge clk);
    endtask
    task automatic arm;
        @(negedge clk); start=1;
        @(negedge clk); start=0;
        wait(pixel_ready);
    endtask
    task automatic frame(input int number);
        seed=number; received=0; stalls=0; arm();
        fork
            begin
                // FIFO must fill before DMA-side reads are allowed
                repeat(120) @(negedge clk);
                for (int j=0; j<1500; j++) begin
                    @(negedge clk); m_axis_tready=(j%17 >= 6);
                end
                m_axis_tready=1;
            end
            begin
                for (int i=0; i<512; i++) begin
                    if (i%29==0) repeat(3) @(negedge pixel_clk);
                    byte_in(value(i));
                    if (i==60) begin
                        @(negedge clk); start=1;
                        @(negedge clk); start=0;
                    end
                end
            end
        join
        wait(!busy); repeat(10) @(negedge clk);
        check(received==128 && words_sent==128,"all 128 words and exact SOP/TLAST checked");
        check(stalls>0,"FIFO full applies input backpressure without losing bytes");
        check(!pixel_ready && !m_axis_tvalid,"one frame stops reception, busy start was ignored");
    endtask
    initial begin
        reset_all();
        scenario="before_start";
        pixel_valid=1; pixel_data=8'hee;
        repeat(20) @(negedge pixel_clk); pixel_valid=0;
        check(!m_axis_tvalid && !busy && words_sent==0,"input is ignored before start");
        scenario="frame_with_stalls"; frame(1);
        scenario="reset_partial_word"; arm(); byte_in(8'hff); byte_in(8'hee);
        reset_all();
        check(words_sent==0 && !busy && !m_axis_tvalid,"reset discards a partial word");
        scenario="fresh_frame_after_reset"; frame(2);
        passed=1; $display("ALL RECEIVER TESTS PASSED: %0d checks, 256 words",checks);
        $finish;
    end
    initial begin #200000; $fatal(1,"Receiver timeout"); end
endmodule
