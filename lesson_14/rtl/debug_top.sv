// debug_top.sv
// Lock controller with Signal Tap and VIO
// OlexandrI.B

module debug_top #(
    parameter int DEBOUNCE_CYCLES = 500000
)(
    input  wire       clk, rst,
    input  wire [3:0] digit_in,
    output wire      unlocked_led
);
    wire [6:0] vio_source;
    wire [3:0] selected_digit = vio_source[5] ? vio_source[3:0] : digit_in;
    wire selected_reset = rst || vio_source[4];
    wire [7:0] debug_word;
    wire [3:0] digit_clean = debug_word[3:0];
    wire [1:0] state = debug_word[5:4];
    wire [1:0] next_state = debug_word[7:6];
    wire [12:0] probes = {unlocked_led, next_state, state, digit_clean, selected_digit};
    logic [12:0] previous_probes;
    logic [8:0] capture_tail;
    wire probes_changed = probes != previous_probes;

    lock_controller #(.DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)) lock (
        .clk(clk), .rst(selected_reset), .digit_in(selected_digit),
        .unlocked_led(unlocked_led), .debug_word(debug_word)
    );

    // Keep 384 clocks after the last change
    always_ff @(posedge clk or posedge selected_reset) begin
        if (selected_reset) begin
            previous_probes <= 0;
            capture_tail <= 0;
        end else begin
            previous_probes <= probes;
            if (probes_changed) capture_tail <= 384;
            else if (capture_tail != 0) capture_tail <= capture_tail - 1'b1;
        end
    end
    wire capture_enable = vio_source[6] && (probes_changed || selected_reset || capture_tail != 0);

    // Five probes: digit, clean digit, state, next state and LED
    ila_0 ila_inst (
        .clk(clk),
        .probe0(selected_digit),
        .probe1(digit_clean),
        .probe2(state),
        .probe3(next_state),
        .probe4(unlocked_led),
        .capture_enable(capture_enable),
        .vio_source(vio_source)
    );
endmodule
