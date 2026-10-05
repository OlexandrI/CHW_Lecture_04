// frame_rx_component.sv
// CSR control and AXI4-Stream to Avalon-ST adapter
// OlexandrI.B

module frame_rx_component (
    input  wire        clk, reset_n, pixel_clk, pixel_reset_n,
    input  wire [1:0]  csr_address,
    input  wire        csr_read, csr_write,
    input  wire [31:0] csr_writedata,
    output logic [31:0] csr_readdata,
    input  wire [7:0]  pixel_data,
    input  wire        pixel_valid,
    output wire        pixel_ready,
    output wire [31:0] st_data,
    output wire        st_valid,
    input  wire        st_ready,
    output wire        st_sop, st_eop,
    output wire [1:0]  st_empty
);
    wire busy;
    wire [31:0] words_sent;
    wire [3:0] tkeep;
    wire [31:0] axis_data;
    wire start = csr_write && csr_address == 0 && csr_writedata[0];
    frame_rx receiver (
        .clk(clk), .reset_n(reset_n), .pixel_clk(pixel_clk), .pixel_reset_n(pixel_reset_n),
        .start(start), .pixel_data(pixel_data), .pixel_valid(pixel_valid),
        .pixel_ready(pixel_ready), .busy(busy), .words_sent(words_sent),
        .m_axis_tdata(axis_data), .m_axis_tkeep(tkeep), .m_axis_tvalid(st_valid),
        .m_axis_tready(st_ready), .m_axis_tlast(st_eop), .m_axis_sop(st_sop)
    );
    // Both protocols use ready/valid with zero ready latency here
    // mSGDMA places the first stream symbol in bits 31:24
    assign st_data = {axis_data[7:0], axis_data[15:8], axis_data[23:16], axis_data[31:24]};
    assign st_empty = 0;
    always_comb begin
        case (csr_address)
            0: csr_readdata = {31'b0, busy};
            1: csr_readdata = words_sent;
            2: csr_readdata = 320 * 200;
            default: csr_readdata = 0;
        endcase
    end
endmodule
