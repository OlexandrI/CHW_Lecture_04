module expr_plain (
    input  logic        clk,
    input  logic [15:0] a, b, c, d,
    output logic [31:0] result
);

    // input registers
    logic [15:0] a_reg, b_reg, c_reg, d_reg;
    
    always_ff @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        c_reg <= c;
        d_reg <= d;
    end

    // long combination input
    always_ff @(posedge clk) begin
        result <= (a_reg * b_reg) + (c_reg * d_reg) + (a_reg * c_reg) + (b_reg * d_reg);
    end

endmodule
