// top_all.sv
// Combine all to one file for one vis
// OlexandrI.B

module top_all (
    // LED-counter
    input  logic       clk,
    input  logic       rst,
    output logic [3:0] led,

    // Decoders
    input  logic [1:0] dec_in_4,
    output logic [3:0] dec_out_4,
    input  logic [2:0] dec_in_8,
    output logic [7:0] dec_out_8,

    // Mux latch free
    input  logic       mux_sel,
    input  logic       mux_in0,
    input  logic       mux_in1,
    output logic       mux_out
);

    decoder #(.WIDTH(4)) u_dec4 (
        .in  (dec_in_4),
        .out (dec_out_4)
    );

    decoder #(.WIDTH(8)) u_dec8 (
        .in  (dec_in_8),
        .out (dec_out_8)
    );

    mux_fixed u_mux (
        .sel (mux_sel),
        .in0 (mux_in0),
        .in1 (mux_in1),
        .out (mux_out)
    );
	 
    led_counter u_counter (
        .clk (clk),
        .rst (rst),
        .led (led)
    );

endmodule
