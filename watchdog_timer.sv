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

endmodule
