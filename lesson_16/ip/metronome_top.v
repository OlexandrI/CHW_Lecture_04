// metronome_top.v
// Nios V system, clock/reset and tick output
// OlexandrI.B

module metronome_top (
    input wire clk, reset_n,
    output wire tick
);
    wire [31:0] firmware_status;
    metronome_system soc (
        .clk_clk(clk), .reset_reset_n(reset_n),
        .tick_export(tick), .status_export(firmware_status)
    );
endmodule
