// mux_latch.sv
// Make latch example
// OlexandrI.B

module mux_latch (
    input  logic sel,
    input  logic in0,
    input  logic in1,
    output logic out
);

    always_comb begin
        case (sel)
            // 1'b1 and default missed :(
            1'b0: out = in0;
				// Uncoment next two lines to make me happy ;)
				//1'b1:    out = in1;
            //default: out = 1'b0;
        endcase
    end

endmodule
