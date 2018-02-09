module freq_comparator #(
  parameter SYNC_STAGE = 3,
  parameter DATA_WIDTH = 32
) (
  input  logic aclk,
  input  logic areset,
  input  logic bclk,
  input  logic breset,
  input  logic enable,
  input  logic [DATA_WIDTH-1:0] timeout_value,
  output logic compare_ge,
  output logic compare_done
);
  
  logic [DATA_WIDTH-1:0] atimeout_count;
  logic [DATA_WIDTH-1:0] btimeout_count,
  logic count_enable,count_enable_sync;
  logic timer_done,timer_done_sync;
  
  freq_comparator_adomain #(
    .DATA_WIDTH (DATA_WIDTH)
  ) freq_comparator_adomain (
    .clk             (aclk),
    .reset           (areset),
    .enable          (enable),
    .count_enable    (count_enable),
    .timer_done      (timer_done_sync),
    .timeout_value   (timeout_value),
    .timeout_compare (btimeout_count),
    .timeout_count   (atimeout_count),
    .compare_ge      (compare_ge),
    .compare_done    (compare_done)
  );
  // synchronize qualifier from aclk to bclk
  // 3-clock-cycle for a double-flop to get qualifier valid in bclk-domain
  data_sync #(
    .SYNC_STAGE (SYNC_STAGE)
  ) data_sync_enable (
    .clk  (bclk),
    .din  (count_enable),
    .dout (count_enable_sync)
  );
  // synchronize qualifier from aclk to bclk
  // 3-clock-cycle for a double-flop to get qualifier valid in bclk-domain
  data_sync #(
    .SYNC_STAGE (SYNC_STAGE)
  ) data_sync_done (
    .clk  (aclk),
    .din  (timer_done),
    .dout (timer_done_sync)
  );
  freq_comparator_bdomain #(
    .DATA_WIDTH (DATA_WIDTH)
  ) freq_comparator_bdomain (
    .clk           (bclk),
    .reset         (breset),
    .enable        (count_enable_sync),
    .count_enable  (count_enable),
    .timeout_count (btimeout_count),
    .timer_done    (timer_done)
  );
  
endmodule
