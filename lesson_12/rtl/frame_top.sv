// frame_top.sv
// External pixels and button connected to the Nios V system
// OlexandrI.B

module frame_top (
    input  wire        clk, pixel_clk, reset_n, button,
    input  wire [7:0]  pixel_data,
    input  wire        pixel_valid,
    output wire        pixel_ready,
    output wire [31:0] debug_status
);
    (* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS" *)
    logic button_sync1, button_sync2;
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin button_sync1<=0; button_sync2<=0; end
        else begin button_sync1<=button; button_sync2<=button_sync1; end
    end
    frame_system soc (
        .clk_clk(clk), .clk_reset_reset_n(reset_n),
        .pixel_clock_clk(pixel_clk), .pixel_clock_reset_reset_n(reset_n),
        .button_export(button_sync2), .debug_export(debug_status),
        .pixels_pixel_data(pixel_data), .pixels_pixel_valid(pixel_valid),
        .pixels_pixel_ready(pixel_ready)
    );
endmodule
