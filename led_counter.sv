// led_counter.sv
// Count to LED some
// OlexandrI.B

module led_counter (
    input  logic       clk,
    input  logic       rst,
    output logic [3:0] led
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 4'b0000;
        end else begin
            led <= led + 1'b1;
        end
    end

endmodule
