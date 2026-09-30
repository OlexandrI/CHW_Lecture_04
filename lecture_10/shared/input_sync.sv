// input_sync.sv
// Synchronize buttons and switch
// OlexandrI.B

module input_sync (
    input  logic       clk, reset_n,
    input  logic [4:0] asynchronous_inputs,
    output logic [4:0] synchronized_inputs
);

    (* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS" *)
    logic [4:0] stage1;

    // Two stages for asynchronous inputs, reset is active low
    always_ff @(posedge clk or negedge reset_n)
        if (!reset_n) begin
            stage1 <= '0;
            synchronized_inputs <= '0;
        end else begin
            stage1 <= asynchronous_inputs;
            synchronized_inputs <= stage1;
        end

endmodule
