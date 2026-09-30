// nios_top.sv
// Nios V system with LED control
// OlexandrI.B

module nios_top (
    input  logic        clk, reset_n,
    input  logic [3:0]  buttons,
    input  logic        direction,
    output wire  [3:0]  leds,
    output wire  [31:0] debug_status
);

    // Buttons and direction switch
    wire [4:0] inputs_sync;
    input_sync sync_inputs(clk, reset_n, {direction, buttons}, inputs_sync);

    // System from Platform Designer
    nios_system soc (
        .clk_clk        (clk),
        .reset_reset_n  (reset_n),
        .buttons_export (inputs_sync[3:0]),
        .switches_export(inputs_sync[4]),
        .leds_export    (leds),
        .debug_export   (debug_status)
    );

endmodule
