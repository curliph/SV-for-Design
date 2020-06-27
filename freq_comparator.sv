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
  logic [DATA_WIDTH-1:0] btimeout_count;
  logic count_enable,count_enable_sync;
  
  freq_comparator_adomain #(
    .DATA_WIDTH (DATA_WIDTH)
  ) freq_comparator_adomain (
    .clk             (aclk),
    .reset           (areset),
    .enable          (enable),
    .count_enable    (count_enable), // flop this signal so as to transfer to bdomin
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
  
  freq_comparator_bdomain #(
    .SYNC_STAGE (SYNC_STAGE),
    .DATA_WIDTH (DATA_WIDTH)
  ) freq_comparator_bdomain (
    .clk           (bclk),
    .reset         (breset),
    .enable        (count_enable_sync),
    .timeout_count (btimeout_count)
  );
  
endmodule

module freq_comparator_bdomain #(
  parameter DATA_WIDTH = 32
) (
  input  logic clk,
  input  logic reset,
  input  logic enable,
  output logic [DATA_WIDTH-1:0] timeout_count
);
  
  always_ff @(posedge clk) begin
    if (reset) begin
      timeout_count <= {DATA_WIDTH{1'b0}};
    end else if(enable) begin
      timeout_count <= timeout_count + 1'b1;
    end
  end
  
endmodule

module freq_comparator_adomain #(
  parameter SYNC_STAGE = 3,
  parameter DATA_WIDTH = 32
) (
  input  logic clk,
  input  logic reset,
  input  logic enable,
  output logic count_enable, // flop this signal so as to transfer to bdomin
  input  logic [DATA_WIDTH-1:0] timeout_value,
  input  logic [DATA_WIDTH-1:0] timeout_compare,
  output logic [DATA_WIDTH-1:0] timeout_count,
  output logic compare_ge,
  output logic compare_done
);
  
  logic end_of_count,end_of_count_sync;
  logic enable_d;
  
  // synchronize qualifier from aclk to bclk
  // 3-clock-cycle for a double-flop to get qualifier valid in bclk-domain
  data_sync #(
    .SYNC_STAGE (3*SYNC_STAGE)
  ) data_sync_enable (
    .clk  (clk),
    .din  (end_of_count),
    .dout (end_of_count_sync)
  );
  
  always_ff @(posedge clk) begin
    if (reset) begin
      timeout_count <= {DATA_WIDTH{1'b0}};
    end else if(count_enable) begin
      timeout_count <= timeout_count + 1'b1;
    end
  end
  
  always_ff @(posedge clk) begin
    if (reset) begin
      count_enable <= 1'b0;
    end else if(~count_enable && ~enable_d && enable) begin
      count_enable <= 1'b1;
    end else if (end_of_count) begin
      count_enable <= 1'b0;
    end
  end
  
  always_ff @(posedge clk) begin
    enable_d <= enable;
    end_of_count <= timeout_count > timeout_value;
    if (end_of_count_sync) begin
      compare_ge <= timeout_count >= timeout_compare;
    end
  end
  
endmodule
