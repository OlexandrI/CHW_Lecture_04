// frame_rx.sv
// 8-bit pixels to AXI4-Stream through a dual-clock FIFO
// OlexandrI.B

module frame_rx #(
    parameter int FRAME_BYTES = 320 * 200,
    parameter int FIFO_WORDS = 256
)(
    input  logic        clk, reset_n,
    input  logic        pixel_clk, pixel_reset_n,
    input  logic        start,
    input  logic [7:0]  pixel_data,
    input  logic        pixel_valid,
    output wire         pixel_ready,
    output wire         busy,
    output logic [31:0] words_sent,
    output wire [31:0]  m_axis_tdata,
    output wire [3:0]   m_axis_tkeep,
    output wire         m_axis_tvalid,
    input  logic        m_axis_tready,
    output wire         m_axis_tlast,
    output wire         m_axis_sop
);
    localparam int BYTE_COUNT_WIDTH = $clog2(FRAME_BYTES);
    localparam int FIFO_COUNT_WIDTH = $clog2(FIFO_WORDS);
    logic start_toggle, start_sync1, start_sync2, start_seen;
    logic seen_sync1, seen_sync2, active_sync1, active_sync2;
    logic active;
    logic [BYTE_COUNT_WIDTH-1:0] byte_count;
    logic [1:0] lane;
    logic [23:0] packed_bytes;
    wire full, empty;
    wire [33:0] fifo_q;
    wire accepted = pixel_valid && pixel_ready;
    wire write_word = accepted && lane == 3;
    wire last_word = byte_count == FRAME_BYTES - 1;
    wire first_word = byte_count == 3;
    wire read_word = m_axis_tvalid && m_axis_tready;

    // Keep the request pending until the other clock domain sees it
    assign busy = (start_toggle != seen_sync2) || active_sync2 || !empty;
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            start_toggle <= 0;
            seen_sync1 <= 0; seen_sync2 <= 0;
            active_sync1 <= 0; active_sync2 <= 0;
            words_sent <= 0;
        end else begin
            seen_sync1 <= start_seen; seen_sync2 <= seen_sync1;
            active_sync1 <= active; active_sync2 <= active_sync1;
            if (start && !busy) begin
                start_toggle <= ~start_toggle;
                words_sent <= 0;
            end else if (read_word)
                words_sent <= words_sent + 1;
        end
    end

    // The first accepted byte occupies bits 7:0 (little-endian RAM)
    assign pixel_ready = active && !full;
    always_ff @(posedge pixel_clk or negedge pixel_reset_n) begin
        if (!pixel_reset_n) begin
            start_sync1 <= 0; start_sync2 <= 0; start_seen <= 0;
            active <= 0; lane <= 0; byte_count <= 0; packed_bytes <= 0;
        end else begin
            start_sync1 <= start_toggle; start_sync2 <= start_sync1;
            if (start_sync2 != start_seen) begin
                start_seen <= start_sync2;
                active <= 1; lane <= 0; byte_count <= 0; packed_bytes <= 0;
            end else if (accepted) begin
                case (lane)
                    0: packed_bytes[7:0] <= pixel_data;
                    1: packed_bytes[15:8] <= pixel_data;
                    2: packed_bytes[23:16] <= pixel_data;
                    default: ;
                endcase
                lane <= lane + 1'b1;
                byte_count <= byte_count + 1'b1;
                if (last_word) active <= 0;
            end
        end
    end

    // Metadata crosses the FIFO together with its data, never separately
    dcfifo #(
        .intended_device_family("Cyclone V"), .lpm_type("dcfifo"),
        .lpm_width(34), .lpm_numwords(FIFO_WORDS), .lpm_widthu(FIFO_COUNT_WIDTH),
        .lpm_showahead("ON"), .overflow_checking("ON"), .underflow_checking("ON"),
        .use_eab("ON"), .rdsync_delaypipe(4), .wrsync_delaypipe(4),
        .read_aclr_synch("ON"), .write_aclr_synch("ON")
    ) fifo (
        .aclr(!reset_n || !pixel_reset_n),
        .wrclk(pixel_clk), .wrreq(write_word),
        .data({first_word, last_word, pixel_data, packed_bytes}), .wrfull(full),
        .rdclk(clk), .rdreq(read_word), .q(fifo_q), .rdempty(empty),
        .rdfull(), .wrempty(), .rdusedw(), .wrusedw(), .eccstatus()
    );
    assign m_axis_tdata = fifo_q[31:0];
    assign m_axis_tlast = fifo_q[32];
    assign m_axis_sop = fifo_q[33];
    assign m_axis_tkeep = 4'b1111;
    assign m_axis_tvalid = !empty;
endmodule
