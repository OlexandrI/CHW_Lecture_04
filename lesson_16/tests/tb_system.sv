// tb_system.sv
// Nios V register access and tick timing
// OlexandrI.B

`timescale 1ns/1ps
module tb_system;
    logic clk=0, reset_n=0;
    wire tick;
    wire [31:0] firmware_status=dut.firmware_status;
    wire [1:0] address=dut.soc.metro.address;
    wire read=dut.soc.metro.read;
    wire write=dut.soc.metro.write;
    wire [31:0] writedata=dut.soc.metro.writedata;
    wire [3:0] byte_offset={address,2'b00};
    wire write_bpm=write && address==0;
    wire write_enable=write && address==1;
    wire read_ticks=read && address==2;
    wire [31:0] readdata=dut.soc.metro.readdata;
    wire [7:0] bpm=dut.soc.metro.bpm;
    wire enabled=dut.soc.metro.enabled;
    wire [31:0] ticks=dut.soc.metro.ticks;
    int checks=0, writes=0, reads=0, events=0, starts=0;
    int expected_bpm=120, active_period=500, pending_period=500;
    int phase=0, expected_ticks=0, cycle=0;
    logic running=0, passed=0;
    bit should_tick;
    always #10 clk=~clk;
    metronome_top dut(.*);
    // Shorter periods for simulation, CPU clock stays 50 MHz
    defparam dut.soc.metro.CLK_HZ=1000;

    task automatic check(input bit ok, input string message);
        if (!ok) $fatal(1,"FAIL %s: cycle=%0d BPM=%0d",message,cycle,bpm);
        checks++;
    endtask
    // Register access from the C program
    always @(posedge clk) begin
        cycle++;
        if (!reset_n || dut.soc.metro.reset) begin
            expected_bpm=120; active_period=500; pending_period=500;
            phase=0; expected_ticks=0; running=0;
        end else begin
            should_tick=0;
            if (write) begin
                writes++;
                $display("CPU WRITE offset=%h data=%0d @ %0t",{address,2'b00},writedata,$time);
                if (address==0) begin
                    expected_bpm=(writedata<30)?30:((writedata>240)?240:writedata);
                    pending_period=60000/expected_bpm;
                end
            end
            if (read) begin
                reads++;
                if (reads<=8) $display("CPU READ offset=%h data=%0d @ %0t",byte_offset,readdata,$time);
            end
            if (write && address==1 && !writedata[0]) begin
                running=0; phase=0;
            end else if (write && address==1 && !running) begin
                running=1; phase=0; expected_ticks=0;
                active_period=pending_period; starts++;
            end else if (running) begin
                phase++;
                if (phase==active_period) begin
                    phase=0; expected_ticks++; should_tick=1;
                    active_period=pending_period;
                end
            end else phase=0;
            #1;
            check(tick===should_tick,"exact tick timing and width");
            check(ticks==expected_ticks && bpm==expected_bpm,"register state");
            if (tick) begin
                events++;
                $display("tick %0d: BPM=%0d TICKS=%0d @ %0t",events,bpm,ticks,$time);
            end
        end
    end
    always @(firmware_status) if (reset_n) begin
        $display("Firmware status=%h @ %0t",firmware_status,$time);
        if (firmware_status[31:16]===16'hdead) $fatal(1,"ELF failure %h",firmware_status);
    end
    initial begin
        $timeformat(-9,0," ns",0);
        repeat(30) @(negedge clk); reset_n=1;
        wait(firmware_status[31:16]===16'h600d);
        repeat(10) @(negedge clk);
        check(firmware_status[15:0]==16,"16 firmware checks");
        check(starts==5,"five independent metronome runs");
        check(writes==17 && reads>20,"17 ELF writes and register reads");
        check(!enabled && !tick,"program stopped the metronome");
        passed=1;
        $display("ALL SYSTEM TESTS PASSED: %0d checks, %0d writes, %0d reads, %0d ticks",checks,writes,reads,events);
        $finish;
    end
    initial begin #100000000; $fatal(1,"System timeout, firmware=%h",firmware_status); end
endmodule
