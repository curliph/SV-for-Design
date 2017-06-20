////////////////////////////////////////////////////////////////////////////////
//
// Description: This module generates the PWM signal running at 1KHz with Duty Cycle 
//              programmable using a 6 bit register (64 linear step from 0% to 100% DT).
//
////////////////////////////////////////////////////////////////////////////////
module pwm #(parameter CTR_LEN = 6) (
    input clk,
    input reset,
    input [CTR_LEN-1:0] compare,
    output pwm
);

reg pwm_q;
reg [CTR_LEN-1:0] ctr_q = {CTR_LEN{1'b0}};

assign pwm = pwm_q;

always_ff @( posedge clk ) begin
    if ( reset ) begin
        ctr_q <= {CTR_LEN{1'b0}};
    end else begin
        ctr_q <= ctr_q + 1;
    end
end

always_ff @( posedge clk ) begin
    if ( ctr_q < compare ) begin
        pwm_q <= 1'b1;
    end else begin
        pwm_q <= 1'b0;
    end
end

endmodule
