// hps_top.sv
// HPS system with LED control
// OlexandrI.B

module hps_top (
    input  wire        clk, reset_n,
    input  wire [3:0]  buttons,
    input  wire        direction,
    output wire [3:0]  leds,
    output wire [31:0] debug_status,
    output wire [12:0] memory_mem_a,
    output wire [2:0]  memory_mem_ba,
    output wire        memory_mem_ck, memory_mem_ck_n, memory_mem_cke, memory_mem_cs_n,
    output wire        memory_mem_ras_n, memory_mem_cas_n, memory_mem_we_n, memory_mem_reset_n,
    inout  wire [7:0]  memory_mem_dq,
    inout  wire        memory_mem_dqs, memory_mem_dqs_n,
    output wire        memory_mem_odt, memory_mem_dm,
    input  wire        memory_oct_rzqin
);

    // Buttons and direction switch
    wire [4:0] inputs_sync;
    input_sync sync_inputs(clk, reset_n, {direction, buttons}, inputs_sync);

    // System from Platform Designer
    hps_system soc (
        .clk_clk            (clk),
        .reset_reset_n      (reset_n),
        .buttons_export     (inputs_sync[3:0]),
        .switches_export    (inputs_sync[4]),
        .leds_export        (leds),
        .debug_export       (debug_status),
        .memory_mem_a       (memory_mem_a),
        .memory_mem_ba      (memory_mem_ba),
        .memory_mem_ck      (memory_mem_ck),
        .memory_mem_ck_n    (memory_mem_ck_n),
        .memory_mem_cke     (memory_mem_cke),
        .memory_mem_cs_n    (memory_mem_cs_n),
        .memory_mem_ras_n   (memory_mem_ras_n),
        .memory_mem_cas_n   (memory_mem_cas_n),
        .memory_mem_we_n    (memory_mem_we_n),
        .memory_mem_reset_n (memory_mem_reset_n),
        .memory_mem_dq      (memory_mem_dq),
        .memory_mem_dqs     (memory_mem_dqs),
        .memory_mem_dqs_n   (memory_mem_dqs_n),
        .memory_mem_odt     (memory_mem_odt),
        .memory_mem_dm      (memory_mem_dm),
        .memory_oct_rzqin   (memory_oct_rzqin)
    );

endmodule
