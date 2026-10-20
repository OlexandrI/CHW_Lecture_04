// moving_max_ip.sv
// 64-sample frame and sliding window for the HLS kernel
// OlexandrI.B

module moving_max_ip #(
    parameter bit PIPELINED=0
)(
    input  logic clk, rst, start,
    input  logic in_valid,
    input  logic signed [31:0] in_data,
    output wire in_ready,
    output logic out_valid,
    output logic signed [31:0] out_data,
    output logic busy, done
);
    localparam logic signed [31:0] INT_MIN=32'sh80000000;
    logic signed [31:0] history[0:6];
    logic [6:0] accepted;
    logic [5:0] produced;
    logic pending;
    wire launch=in_valid && in_ready;
    wire kernel_done;
    wire [31:0] kernel_result;
    assign in_ready=!rst && busy && accepted<64 && (PIPELINED || !pending);

    generate
        if (PIPELINED) begin: pipe_core
            max8_pipeline kernel (
                .clock(clk), .reset(rst), .start_port(launch),
                .a(in_data), .b(history[0]), .c(history[1]), .d(history[2]),
                .e(history[3]), .f(history[4]), .g(history[5]), .h(history[6]),
                .done_port(kernel_done), .return_port(kernel_result)
            );
        end else begin: plain_core
            max8_plain kernel (
                .clock(clk), .reset(rst), .start_port(launch),
                .a(in_data), .b(history[0]), .c(history[1]), .d(history[2]),
                .e(history[3]), .f(history[4]), .g(history[5]), .h(history[6]),
                .done_port(kernel_done), .return_port(kernel_result)
            );
        end
    endgenerate

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            busy<=0; done<=0; out_valid<=0; out_data<=0;
            accepted<=0; produced<=0; pending<=0;
            for (int k=0; k<7; k++) history[k]<=INT_MIN;
        end else begin
            done<=0; out_valid<=0;
            // Start a new block with an empty window
            if (start && !busy) begin
                busy<=1; accepted<=0; produced<=0; pending<=0;
                for (int k=0; k<7; k++) history[k]<=INT_MIN;
            end
            if (launch) begin
                accepted<=accepted+1'b1;
                pending<=1;
                for (int k=6; k>0; k--) history[k]<=history[k-1];
                history[0]<=in_data;
            end
            if (kernel_done && busy) begin
                pending<=0;
                out_valid<=1;
                out_data<=kernel_result;
                produced<=produced+1'b1;
                if (produced==63) begin busy<=0; done<=1; end
            end
        end
    end
endmodule
