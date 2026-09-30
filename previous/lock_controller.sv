`timescale 1ns / 1ps

module lock_controller (
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] digit_in,
    output logic       unlocked_led
);

    // Debounce input
    logic [3:0] digit_clean;
    logic [3:0] digit_sync1, digit_sync2;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_sync1 <= 4'b0;
            digit_sync2 <= 4'b0;
            digit_clean <= 4'b0;
        end else begin
            digit_sync1 <= digit_in;
            digit_sync2 <= digit_sync1;
            if (digit_sync1 == digit_sync2) begin
                digit_clean <= digit_sync2;
            end
        end
    end

    // FSM (Three-process pattern)
    
    typedef enum logic [1:0] {
        LOCKED   = 2'b00,
        WAIT_D2  = 2'b01,
        WAIT_D3  = 2'b10,
        UNLOCKED = 2'b11
    } state_t;

    state_t state, next_state;

    // sequence logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= LOCKED;
        else
            state <= next_state;
    end

    // Combination logic
    always_comb begin
        // Default same state
        next_state = state;

        case (state)
            LOCKED: begin
                if (digit_clean == 4'd5)
                    next_state = WAIT_D2;
                else if (digit_clean != 4'd0)
                    next_state = LOCKED;
            end
            
            WAIT_D2: begin
                if (digit_clean == 4'd3)
                    next_state = WAIT_D3;
                else if (digit_clean != 4'd0 && digit_clean != 4'd5) 
                    next_state = LOCKED;
            end
            
            WAIT_D3: begin
                if (digit_clean == 4'd7)
                    next_state = UNLOCKED;
                else if (digit_clean != 4'd0 && digit_clean != 4'd3)
                    next_state = LOCKED;
            end
            
            UNLOCKED: begin
                next_state = UNLOCKED;
            end
            
            default: next_state = LOCKED;
        endcase
    end

    // Combination logic (out)
    always_comb begin
        if (state == UNLOCKED)
            unlocked_led = 1'b1;
        else
            unlocked_led = 1'b0;
    end

endmodule
