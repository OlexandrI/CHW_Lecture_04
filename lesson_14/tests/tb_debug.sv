// tb_debug.sv
// Lock, VIO control and capture tests
// OlexandrI.B

`timescale 1ns/1ps
module tb_debug;
    logic clk=0, rst=1;
    logic [3:0] digit_in=0;
    wire unlocked_led;
    logic [6:0] sim_source=7'h40;
    wire [3:0] probe0=dut.selected_digit;
    wire [3:0] probe1=dut.digit_clean;
    wire [1:0] probe2=dut.state;
    wire [1:0] probe3=dut.next_state;
    wire probe4=unlocked_led;
    wire capture_enable=dut.capture_enable;
    wire [12:0] probe_bus=dut.probes;
    int checks=0, unlock_events=0, qualified_samples=0, csv_file;
    logic old_led=0, passed=0;
    string scenario="reset";
    always #10 clk=~clk;
    debug_top #(.DEBOUNCE_CYCLES(4)) dut(.*);

    // VIO input for simulation; JTAG commands are not simulated
    // Force the source vector to test control routing
    initial force dut.vio_source = sim_source;
    always @(posedge clk) begin
        if (unlocked_led && !old_led) unlock_events++;
        old_led=unlocked_led;
        if (capture_enable) begin
            qualified_samples++;
            $fdisplay(csv_file,"%0t,%h,%h,%h,%h,%b",$time,probe0,probe1,probe2,probe3,probe4);
        end
        if (!rst && !$isunknown(probe_bus)) begin
            if (dut.ila_inst.probes !== probe_bus ||
                dut.ila_inst.debug_cores.tap_acq_data_in !== probe_bus ||
                dut.ila_inst.debug_cores.tap_acq_trigger_in !== probe_bus)
                $fatal(1,"Five probe groups do not match the native IP ports");
        end
    end
    task automatic cycles(input int n);
        repeat(n) @(negedge clk);
    endtask
    task automatic check(input bit ok, input string message);
        if (!ok) $fatal(1,"FAIL [%s] %s",scenario,message);
        checks++; $display("PASS %02d [%s] %s",checks,scenario,message);
    endtask
    task automatic digit(input logic [3:0] value);
        @(negedge clk);
        if(sim_source[5]) sim_source[3:0]=value;
        else digit_in=value;
        cycles(16);
    endtask
    task automatic reset_lock;
        @(negedge clk);rst=1;cycles(3);rst=0;digit_in=0;cycles(16);
    endtask
    initial begin
        $timeformat(-9,0,"",0);
        csv_file=$fopen("../evidence/qualified_samples.csv","w");
        if(!csv_file) $fatal(1,"Cannot open sample log");
        $fdisplay(csv_file,"time_ns,probe0_digit,probe1_clean,probe2_state,probe3_next,probe4_led");
        cycles(5);rst=0;cycles(20);
        check(probe2==0 && !unlocked_led,"reset leaves the lock closed");
        check($bits(dut.ila_inst.probes)==13,"five groups: 4+4+2+2+1 = 13 bits");

        // ~ Wrong digit
        scenario="wrong_attempt";
        digit(5);check(probe2==1,"first digit -> WAIT_D2");
        digit(4);check(probe2==0 && unlock_events==0,"wrong digit -> LOCKED, no unlock event");
        digit(0);cycles(450);
        check(!capture_enable,"stable idle stops capture after the context window");

        // ~ Correct code from digit_in
        scenario="physical_code";
        digit(5);check(probe2==1 && probe1==5,"physical digit is filtered and probed");
        digit(3);check(probe2==2,"second digit -> WAIT_D3");
        digit(7);check(probe2==3 && unlocked_led && unlock_events==1,"third digit -> UNLOCKED, one rare event");
        check(capture_enable,"post-trigger context remains enabled");
        cycles(280);check(capture_enable,"context covers the 512-sample centered buffer tail");
        cycles(220);check(!capture_enable && unlocked_led,"capture stops, unlocked state is retained");
        digit(0);cycles(450);check(unlock_events==1,"holding UNLOCKED does not create new events");

        // ~ VIO input and reset
        scenario="vio_control";
        reset_lock();sim_source=7'h60;digit_in=9;
        digit(5);check(probe0==5 && probe1==5 && probe2==1,"VIO source overrides physical digit 9");
        digit(3);check(probe2==2,"VIO second digit -> WAIT_D3");
        digit(7);check(unlocked_led && unlock_events==2,"VIO sequence opens the same FSM");
        @(negedge clk);sim_source[4]=1;#1;
        check(!unlocked_led && probe2==0,"VIO reset is active high and asynchronous");
        cycles(3);sim_source=7'h60;cycles(20);

        // ~ Disable and resume capture
        scenario="capture_gate";
        sim_source[6]=0;digit(5);
        check(!capture_enable && probe2==1,"disabled capture does not stop the design");
        digit(3);check(!capture_enable && probe2==2,"data still moves with capture disabled");
        sim_source[6]=1;digit(7);
        check(capture_enable && unlocked_led && unlock_events==3,"capture resumes for the next unlock");
        cycles(450);
        check(!capture_enable && qualified_samples>0,"qualifier records events and suppresses long idle");
        passed=1;
        $display("ALL DEBUG TESTS PASSED: %0d checks, %0d unlock events, %0d qualified samples",checks,unlock_events,qualified_samples);
        $fclose(csv_file);$finish;
    end
    initial begin #200000; $fatal(1,"Debug test timeout"); end
endmodule
