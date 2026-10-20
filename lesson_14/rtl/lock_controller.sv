// lock_controller.sv
// Three-process lock FSM with debug output, code 5 -> 3 -> 7
// OlexandrI.B

module lock_controller #(
    parameter int DEBOUNCE_CYCLES = 500000
)(
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] digit_in,
    output logic       unlocked_led,
    output wire  [7:0] debug_word
);
    logic [3:0] digit_clean;
    digit_debounce #(.STABLE_CYCLES(DEBOUNCE_CYCLES)) filter (
        .clk(clk), .rst(rst), .digit_in(digit_in), .digit_clean(digit_clean)
    );

    typedef enum logic [1:0] {
        LOCKED   = 2'b00,
        WAIT_D2  = 2'b01,
        WAIT_D3  = 2'b10,
        UNLOCKED = 2'b11
    } state_t;
    (* syn_encoding = "user" *) state_t state;
    state_t next_state;
    assign debug_word = {next_state, state, digit_clean};

    // State register, rst - async
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= LOCKED;
        else
            state <= next_state;
    end

    // Next state, 0 means released buttons
    always_comb begin
        next_state = state;
        case (state)
            LOCKED: begin
                if (digit_clean == 4'd5)
                    next_state = WAIT_D2;
            end
            WAIT_D2: begin
                if (digit_clean == 4'd3)
                    next_state = WAIT_D3;
                else if (digit_clean != 0 && digit_clean != 5)
                    next_state = LOCKED;
            end
            WAIT_D3: begin
                if (digit_clean == 4'd7)
                    next_state = UNLOCKED;
                else if (digit_clean != 0 && digit_clean != 3)
                    next_state = LOCKED;
            end
            UNLOCKED: next_state = UNLOCKED;
            default:  next_state = LOCKED;
        endcase
    end

    // Output logic
    always_comb begin
        unlocked_led = (state == UNLOCKED);
    end
endmodule
