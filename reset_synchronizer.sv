/////////////////////////////////////////////////////////
// Synnchronize for Async reset assert and Sync deassert
/////////////////////////////////////////////////////////
module reset_synchronizer #(
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
