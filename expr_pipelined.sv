module expr_pipelined (
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

    // additional pipeline registers
    logic [31:0] p1, p2, p3, p4;

    always_ff @(posedge clk) begin
        p1 <= a_reg * b_reg;
        p2 <= c_reg * d_reg;
        p3 <= a_reg * c_reg;
        p4 <= b_reg * d_reg;
    end

    // output registers
    always_ff @(posedge clk) begin
        result <= p1 + p2 + p3 + p4;
    end

endmodule
