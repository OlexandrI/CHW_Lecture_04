// tb_system.sv
// Real Nios V firmware, button, two full frames and DMA writes
// OlexandrI.B

`timescale 1ns/1ps
module tb_system;
    logic clk=0, pixel_clk=0, reset_n=0, button=0;
    logic [7:0] pixel_data=0;
    logic pixel_valid=0;
    wire pixel_ready;
    wire [31:0] debug_status;
    int checks=0, frame_id=0, dma_words=0, last_count=0, cpu_writes=0;
    logic passed=0;
    string scenario="boot";
    wire [31:0] axis_data=dut.soc.receiver.receiver.m_axis_tdata;
    wire axis_valid=dut.soc.receiver.receiver.m_axis_tvalid;
    wire axis_ready=dut.soc.receiver.receiver.m_axis_tready;
    wire axis_last=dut.soc.receiver.receiver.m_axis_tlast;
    wire [31:0] receiver_words=dut.soc.receiver.receiver.words_sent;
    wire dma_write=dut.soc.dma_mm_write_write;
    wire dma_wait=dut.soc.dma_mm_write_waitrequest;
    wire [31:0] dma_data=dut.soc.dma_mm_write_writedata;
    wire [31:0] dma_address=dut.soc.dma_mm_write_address;
    always #10 clk=~clk;
    always #20 pixel_clk=~pixel_clk;
    frame_top dut(.*);
    function automatic logic [7:0] pixel(input int i);
        return 8'(i*13+7+frame_id*31);
    endfunction
    task automatic check(input bit ok, input string message);
        if (!ok) $fatal(1,"FAIL [%s] %s @ %0t",scenario,message,$time);
        checks++; $display("PASS %02d [%s] %s @ %0t",checks,scenario,message,$time);
    endtask
    task automatic cycles(input int n);
        repeat(n) @(negedge clk);
    endtask
    // Observe the native DMA master; the CPU only initializes/checks RAM
    always @(posedge clk) if(reset_n) begin
        if(debug_status[31:16]===16'hdead) $fatal(1,"Firmware error %h",debug_status);
        if(dma_write && !dma_wait) begin
            if(dma_address != 32'h20000+4*dma_words)
                $fatal(1,"DMA address %h word %0d",dma_address,dma_words);
            if(dma_data !== {pixel(dma_words*4+3),pixel(dma_words*4+2),pixel(dma_words*4+1),pixel(dma_words*4)})
                $fatal(1,"DMA data %h word %0d",dma_data,dma_words);
            dma_words++;
            if(dma_words%4000==0) $display("DMA frame %0d: %0d / 16000 words @ %0t",frame_id,dma_words,$time);
            if(dma_words>16000) $fatal(1,"DMA writes beyond frame");
        end
        if(axis_valid && axis_ready && axis_last) last_count++;
        if(dut.soc.cpu_data_manager_write && !dut.soc.cpu_data_manager_waitrequest &&
           dut.soc.cpu_data_manager_address >= 'h20000 && dut.soc.cpu_data_manager_address < 'h30000)
            cpu_writes++;
    end
    always @(debug_status) if(reset_n) $display("Firmware status=%h @ %0t",debug_status,$time);
    task automatic send_frame;
        wait(pixel_ready);
        for(int i=0;i<64000;i++) begin
            if(i%97==0) begin
                @(negedge pixel_clk);pixel_valid=0;
                repeat(5) @(negedge pixel_clk);
            end
            @(negedge pixel_clk);pixel_data=pixel(i);pixel_valid=1;
            do @(posedge pixel_clk); while(!pixel_ready);
        end
        // Extra data at the port must not become a second frame
        @(negedge pixel_clk);pixel_data=8'haa;
        repeat(50) @(negedge pixel_clk);
        pixel_valid=0;
    endtask
    task automatic capture(input int number);
        frame_id=number;dma_words=0;last_count=0;cpu_writes=0;
        scenario=$sformatf("frame_%0d",number);
        button=1;
        send_frame();
        wait(debug_status[15:0]===16'd5);
        check(debug_status[31:16]==number,"ELF verified every RAM word and guard region");
        check(dma_words==16000 && receiver_words==16000,"DMA wrote exactly 16000 words / 64000 bytes");
        check(last_count==1,"exactly one TLAST on the frame");
        check(cpu_writes==386,"CPU only wrote guard markers before DMA; capture was not a CPU copy");
        check(!pixel_ready,"extra input ignored after the frame");
        cycles(3000);
        check(debug_status[15:0]==1 && dma_words==16000,"held button cannot start a second frame");
        button=0;
        wait(debug_status[15:0]==2);cycles(20);
    endtask
    initial begin
        $timeformat(-9,0,"",0);
        cycles(30);reset_n=1;
        wait(debug_status[15:0]===16'd2);
        check(!pixel_ready && dma_words==0,"ELF booted and waits for button");
        scenario="before_button";
        pixel_valid=1;pixel_data=8'hff;
        repeat(50) @(negedge pixel_clk);pixel_valid=0;
        check(!axis_valid && dma_words==0 && receiver_words==0,"data before button is ignored");
        scenario="short_button_pulses";
        repeat(8) begin button=1;cycles(3);button=0;cycles(20);end
        check(debug_status==2 && !pixel_ready,"short button pulses do not arm capture");
        capture(1);
        capture(2);
        passed=1;
        $display("ALL SYSTEM TESTS PASSED: %0d checks, 2 full frames, 32000 DMA words",checks);
        $finish;
    end
    initial begin #1000000000; $fatal(1,"System timeout, status=%h",debug_status); end
endmodule
