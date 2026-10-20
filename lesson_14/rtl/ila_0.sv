// ila_0.sv
// Five probes for Signal Tap and VIO
// OlexandrI.B

module ila_0 (
    input  wire        clk,
    input  wire [3:0]  probe0, probe1,
    input  wire [1:0]  probe2, probe3,
    input  wire        probe4,
    input  wire        capture_enable,
    output wire [6:0]  vio_source
);
    // probe0=digit, probe1=filtered digit, probe2=state,
    // probe3=next state, probe4=unlocked LED: 4+4+2+2+1=13
    wire [12:0] probes = {probe4, probe3, probe2, probe1, probe0};
    debug_ip debug_cores (
        .clk_clk(clk), .vio_clk_clk(clk),
        .tap_acq_data_in(probes), .tap_acq_trigger_in(probes),
        .capture_storage_enable(capture_enable),
        .vio_input_probe(probes), .vio_output_source(vio_source)
    );
endmodule
