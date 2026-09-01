// top_decoder.sv
// Using decoder module as two instances with different params
// OlexandrI.B

module top_decoder (
    input  logic [1:0] in_4,
    input  logic [2:0] in_8,
    output logic [3:0] out_4,
    output logic [7:0] out_8
);

    // Instance with WIDTH=4
    decoder #(.WIDTH(4)) dec_inst4 (
        .in  (in_4),
        .out (out_4)
    );

    // Instance with WIDTH=8
    decoder #(.WIDTH(8)) dec_inst8 (
        .in  (in_8),
        .out (out_8)
    );

endmodule
