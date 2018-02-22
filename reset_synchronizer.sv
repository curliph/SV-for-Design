/////////////////////////////////////////////////////////
// Synnchronize for Async reset assert and Sync deassert
/////////////////////////////////////////////////////////
module async_reset_synchronizer #(
  parameter SYNC_STAGE = 4
) (
  input  logic clk,
  input  logic reset_async,
  output logic reset_sync,
  output logic reset_sync_n
);
  
  logic [SYNC_STAGE-1:0] reset = {SYNNC_STAGE{1'b1}};
  
  always_ff @(posedge clk or posedge reset_async) begin
    if (reset_async) begin
      reset <= {SYNC_STAGE{1'b1}};
    end else begin
      reset <= {reset[SYNC_STAGE-2:0],1'b0};
    end
  end
  
  assign reset_sync   =  reset[SYNC_STAGE-1];
  assign reset_sync_n = !reset[SYNC_STAGE-1];
  
endmodule

module async_sync_reset_synchronizer #(
  parameter ASYNC_STAGE = 5,
  parameter SYNC_STAGE = 2
) (
  input  logic clk,
  input  logic reset_async,
  output logic reset_sync,
  output logic reset_sync_n
);
  
  logic [ASYNC_STAGE-1:0] reset_async_reg = {ASYNC_STAGE{1'b1}};
  logic [SYNC_STAGE-1:0] reset_sync_reg = {SYNC_STAGE{1'b1}};
  // async assert sync deassert using async-register
  // mitigate reset recovery and reset removal of deassertion of async-reset input 
  always_ff @(posedge clk or posedge reset_async) begin
    if (reset_async) begin
      reset_async_reg <= {ASYNC_STAGE{1'b1}};
    end else begin
      reset_async_reg <= {reset_async_reg[ASYNC_STAGE-2:0],1'b0};
    end
  end
  // sync assert sync deassert using sync-register
  // mitigate the CDC-syncronization of sync-reset output
  always_ff @(posedge clk) begin
    if (reset_async_reg[ASYNC_STAGE-1]) begin
      reset_sync_reg <= {SYNC_STAGE{1'b1}};
    end else begin
      reset_sync_reg <= {reset_sync_reg[SYNC_STAGE-2:0],1'b0};
    end
  end
  
  assign reset_sync   =  reset_sync_reg[SYNC_STAGE-1];
  assign reset_sync_n = !reset_sync_reg[SYNC_STAGE-1];
  
endmodule

