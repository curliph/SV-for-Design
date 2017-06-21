////////////////////////////////////////////////////////////////////////////////
//
// Description: This module generates the PWM signal running at 1KHz with Duty Cycle 
//              programmable using a 6 bit register (64 linear step from 0% to 100% DT).
//
////////////////////////////////////////////////////////////////////////////////
module pwm #(parameter CTR_LEN = 6) (
    input  logic clk,
    input  logic reset,
    input  logic [CTR_LEN-1:0] compare,
    output logic pwm = 0
);

logic [CTR_LEN-1:0] ctr_q = {CTR_LEN{1'b0}};

always_ff @( posedge clk ) begin
    if ( reset ) begin
        ctr_q <= {CTR_LEN{1'b0}};
    end else begin
        ctr_q <= ctr_q + 1;
    end
end

always_ff @( posedge clk ) begin
    if ( ctr_q < compare ) begin
        pwm <= 1'b1;
    end else begin
        pwm <= 1'b0;
    end
end

endmodule
