// alu.sv
// Registered 4-bit ALU
// OlexandrI.B

module alu (
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] a, b,
    input  logic [1:0] op,
    input  logic       oe,
    output logic [3:0] result
);
    logic [3:0] a_reg, b_reg;
    logic [1:0] op_reg;
    logic oe_reg;

    // Input registers, rst - async
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            op_reg <= 0;
            oe_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            op_reg <= op;
            oe_reg <= oe;
        end
    end

    // Registered result, disabled output is zero
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            result <= 0;
        else if (!oe_reg)
            result <= 0;
        else begin
            case (op_reg)
                2'b00: result <= a_reg + b_reg;
                2'b01: result <= a_reg - b_reg;
                2'b10: result <= a_reg & b_reg;
                2'b11: result <= a_reg | b_reg;
                default: result <= 0;
            endcase
        end
    end
endmodule
