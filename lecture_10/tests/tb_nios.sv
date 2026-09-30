// tb_nios.sv
// Nios V simulation with ELF program
// OlexandrI.B

`timescale 1ns/1ps
module tb_nios;
    logic clk=0, reset_n=0;
    logic [3:0] buttons=0;
    logic direction=0;
    wire [3:0] leds;
    wire [31:0] debug_status;
    wire running=debug_status[0];
    wire [1:0] speed=debug_status[2:1];
    wire [1:0] position=debug_status[4:3];
    wire [3:0] debounced_buttons=debug_status[11:8];
    wire [31:0] timer_period=dut.soc.move_timer.counter_load_value+1;
    wire timer_running=dut.soc.move_timer.counter_is_running;
    wire timer_timeout=dut.soc.move_timer.timeout_occurred;
    logic passed=0;
    int checks=0, led_transitions=0;
    string scenario="reset";

    // clock generator, 50 MHz
    always #10 clk=~clk;
    nios_top dut(.*);
    task automatic cycles(input int count);
        repeat(count) @(negedge clk);
    endtask
    task automatic check(input bit condition, input string message);
        if (!condition) $fatal(1,"FAIL [%s] %s at %0t",scenario,message,$time);
        checks++;
        $display("PASS %02d [%s] %s @ %0t", checks,scenario,message,$time);
    endtask

    // Hold long enough for debounce, then release
    task automatic press(input logic [3:0] mask);
        buttons=mask; cycles(16000);
        buttons=0; cycles(16000);
    endtask
    task automatic next_led(input logic [3:0] expected);
        @(leds); #1;
        check(leds===expected,$sformatf("LED = %04b",expected));
    endtask

    // Compare LED interval with hardware timer period
    task automatic interval_check(input int expected);
        time first_edge, duration;
        @(leds); first_edge=$time;
        @(leds); duration=$time-first_edge;
        check(duration >= (expected-1500)*20 && duration <= (expected+1500)*20,
              $sformatf("LED interval %0t ns follows timer %0d clocks",duration,expected));
        check(timer_period==expected,"CPU programmed hardware period register");
    endtask

    // Only one LED should be active
    always @(leds) begin
        if(reset_n && debug_status[31] && debug_status[31:16]!=16'hdead) begin
            if (!$onehot(leds)) $fatal(1,"LED output is not one-hot: %b",leds);
            led_transitions++;
        end
    end
    always @(debug_status) if(debug_status[31:16]===16'hdead)
        $fatal(1,"CPU entered trap handler");
    initial begin
        // Print time in ns
        $timeformat(-9, 0, "", 0);
        cycles(20); reset_n=1;
        wait(debug_status[31]===1); cycles(20);
        check(leds===4'b0001 && speed==2 && running,"ELF booted: LED0, speed 2, running");

        // ~ Check forward wrap
        scenario="forward_wrap";
        next_led(4'b0010); next_led(4'b0100); next_led(4'b1000); next_led(4'b0001);
        interval_check(100000);

        // ~ Check reverse wrap
        scenario="reverse_wrap";
        direction=1; cycles(500);
        begin
            logic [3:0] expected;
            expected=leds;
            repeat(4) begin
                expected={expected[0],expected[3:1]};
                next_led(expected);
            end
        end

        // ~ Check short button bounces
        scenario="bounce_rejection";
        repeat(5) begin buttons=1; cycles(200); buttons=0; cycles(2500); end
        cycles(6000); check(speed==2,"short button bounces do not change speed");

        // ~ Check faster and held button
        scenario="faster_and_hold";
        buttons=1; cycles(16000); check(speed==1,"FASTER changes speed once");
        cycles(80000); check(speed==1,"held button does not auto-repeat");
        buttons=0; cycles(16000); interval_check(50000);

        // ~ Check STOP
        scenario="stop";
        press(4); check(!running && !timer_running,"STOP stops the hardware movement timer");
        begin
            logic [3:0] saved;
            saved=leds; cycles(250000); check(leds===saved,"LED remains unchanged while paused");
        end

        // ~ Change speed while paused
        scenario="speed_while_paused";
        press(1); check(speed==0 && !running && !timer_running,"speed can change while paused");
        press(1); check(speed==0,"minimum speed index saturates at zero");

        // ~ Check RESUME
        scenario="resume";
        press(8); check(running && timer_running,"RESUME restarts hardware timer");
        interval_check(25000);

        // ~ Check slower and speed limit
        scenario="slower_and_maximum";
        press(2); check(speed==1,"SLOWER selects 1");
        press(2); check(speed==2,"SLOWER selects 2");
        press(2); check(speed==3,"SLOWER selects 3");
        press(2); check(speed==3,"maximum speed index saturates at three");
        interval_check(200000);

        // ~ Check button combinations
        scenario="simultaneous_buttons";
        press(3); check(speed==3,"FASTER plus SLOWER cancel each other");
        press(12); check(!running,"STOP wins over simultaneous RESUME");
        press(8); check(running,"resume after button chord");

        // ~ Reset during movement
        scenario="reset_during_activity";
        buttons=1; cycles(1000); reset_n=0; cycles(30);
        buttons=0; direction=0; reset_n=1;
        wait(debug_status[31]===1); cycles(50);
        check(leds==1 && speed==2 && running && debounced_buttons==0,"reset restores deterministic initial state");
        next_led(4'b0010);
        check(led_transitions>=20,"observed at least twenty real CPU-driven LED transitions");
        passed=1;
        $display("ALL TESTS PASSED: %0d checks, %0d LED transitions, real Nios V/m ELF execution",checks,led_transitions);
        $finish;
    end
    initial begin #70000000; $fatal(1,"Simulation watchdog expired (ELF boot or test deadlock)"); end
endmodule
