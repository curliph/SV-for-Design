////////////////////////////////////////////////////////////////////////////////
//
// Description: This module generates the 64KHz clk signal from 25MHz input clk.
//
////////////////////////////////////////////////////////////////////////////////
module freq_divider #(
    parameter INPUT_CLK_FREQ = 25000, 
    parameter OUTPUT_CLK_FREQ = 64
) (
    input clk_in,
    input reset,
    output clk_out
);

localparam COUNT_MAX = (INPUT_CLK_FREQ/OUTPUT_CLK_FREQ)/2;
localparam COUNT_BIT = $clog2(COUNT_MAX);

logic clk_out_q = 1'b0;
logic [COUNT_BIT-1:0] count = {COUNT_BIT{1'b0}};
logic end_of_count;

assign clk_out = clk_out_q;

always_ff @( posedge clk_in ) begin
    if ( reset ) begin
        count <= {COUNT_BIT{1'b0}};
    end else if ( end_of_count ) begin
        count <= {COUNT_BIT{1'b0}};
    end else begin
        count <= count + 1'b1;
    end
end

always_ff @( posedge clk_in ) begin
    end_of_count <= count == COUNT_MAX-2;
end

always_ff @( posedge clk_in ) begin
    if ( reset ) begin
        clk_out_q <= 1'b0;
    end else if ( end_of_count ) begin
        clk_out_q <= ~clk_out_q;
    end
end

endmodule
