// digit_debounce.sv
// Stable digit filter with input synchronizer
// OlexandrI.B

module digit_debounce #(
    parameter int STABLE_CYCLES = 500000
)(
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] digit_in,
    output logic [3:0] digit_clean
);
    localparam int COUNT_WIDTH = $clog2(STABLE_CYCLES + 1);
    (* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS" *)
    logic [3:0] digit_sync1, digit_sync2;
    logic [3:0] candidate;
    logic [COUNT_WIDTH-1:0] stable_count;

    // rst - async, input must stay stable before acceptance
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_sync1 <= 0;
            digit_sync2 <= 0;
            candidate <= 0;
            stable_count <= 0;
            digit_clean <= 0;
        end else begin
            digit_sync1 <= digit_in;
            digit_sync2 <= digit_sync1;

            if (digit_sync2 != candidate) begin
                candidate <= digit_sync2;
                stable_count <= 1;
                if (STABLE_CYCLES == 1)
                    digit_clean <= digit_sync2;
            end else if (stable_count < STABLE_CYCLES) begin
                stable_count <= stable_count + 1'b1;
                if (stable_count == STABLE_CYCLES - 1)
                    digit_clean <= candidate;
            end
        end
    end
endmodule
