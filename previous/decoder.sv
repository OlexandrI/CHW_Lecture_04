// decoder.sv
// Simple decored with param implementation
// OlexandrI.B

module decoder #(
    parameter int WIDTH = 4
)(
    input  logic [((WIDTH > 1) ? $clog2(WIDTH) : 1)-1:0] in,
    output logic [WIDTH-1:0]    out
);

    localparam int IN_WIDTH = (WIDTH > 1) ? $clog2(WIDTH) : 1;

    always_comb begin
        out = '0;
        out = (1'b1 << in);
    end

endmodule
