// metronome_bug.v
// Deliberate off-by-one error for the same testbench
// OlexandrI.B

module metronome_bug #(
    parameter integer CLK_HZ = 50000000
)(
    input  wire clk, reset,
    input  wire [1:0] address,
    input  wire read, write,
    input  wire [3:0] byteenable,
    input  wire [31:0] writedata,
    output reg  [31:0] readdata,
    output wire waitrequest,
    output reg tick
);
    localparam [63:0] CLOCKS_PER_MINUTE = 64'd60 * CLK_HZ;
    function [31:0] clocks_for;
        input integer tempo;
        reg [63:0] value;
        begin
            value=CLOCKS_PER_MINUTE/tempo;
            clocks_for=value[31:0];
        end
    endfunction
    reg [7:0] bpm;
    reg enabled;
    reg [31:0] counter, ticks, period, next_period;
    // Period table, calculated during synthesis
    (* ramstyle = "logic" *) reg [31:0] period_table [0:255];
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) begin
            if (i<30) period_table[i]=clocks_for(30);
            else if (i>240) period_table[i]=clocks_for(240);
            else period_table[i]=clocks_for(i);
        end
    end

    wire [31:0] byte_mask = {{8{byteenable[3]}},{8{byteenable[2]}},
                            {8{byteenable[1]}},{8{byteenable[0]}}};
    wire [31:0] bpm_write = ({24'd0,bpm} & ~byte_mask) | (writedata & byte_mask);
    wire [7:0] bounded_bpm = (bpm_write<30)?8'd30:((bpm_write>240)?8'd240:bpm_write[7:0]);
    wire set_bpm = write && address==0 && |byteenable;
    wire set_enable = write && address==1 && byteenable[0];
    assign waitrequest=1'b0;

    always @* begin
        readdata=0;
        if (read) begin
            case (address)
                0: readdata={24'd0,bpm};
                1: readdata={31'd0,enabled};
                2: readdata=ticks;
                default: readdata=0;
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bpm<=120; enabled<=0; counter<=0; ticks<=0; tick<=0;
            period<=clocks_for(120);
            next_period<=clocks_for(120);
        end else begin
            tick<=0;
            if (set_bpm) begin
                bpm<=bounded_bpm;
                next_period<=period_table[bounded_bpm];
            end
            // Disable first, restart clears TICKS
            if (set_enable && !writedata[0]) begin
                enabled<=0; counter<=0;
            end else if (set_enable && !enabled) begin
                enabled<=1; counter<=0; ticks<=0;
                period<=next_period;
            end else if (enabled) begin
                if (counter==period) begin
                    counter<=0; tick<=1; ticks<=ticks+1'b1;
                    // New BPM after the current interval
                    period<=set_bpm?period_table[bounded_bpm]:next_period;
                end else counter<=counter+1'b1;
            end else counter<=0;
        end
    end
endmodule
