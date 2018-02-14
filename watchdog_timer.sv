module watchdog_timer #(
  parameter TIMR_WIDTH = 16
) (
  input  logic                  clk,
  input  logic                  reset,
  input  logic                  timer_start, // pulse
  input  logic [TIMR_WIDTH-1:0] timer_value,
  output logic                  interrupt
);
  
  logic [TIMR_WIDTH-1:0] timer_count;
  
  always_ff @(posedge clk) begin
    if (reset) begin
      timer_count <= {TIMR_WIDTH{1'b1}};
    end else if (timer_start) begin
      timer_count <= timer_value;
    end else if (|timer_count) begin
      timer_count <= timer_count - 1'b1;
    end
  end
  // live-interrupt to interrupt controller
  always_ff @(posedge clk) begin
    interrupt <= ~(|timer_count);
  end
  
endmodule
