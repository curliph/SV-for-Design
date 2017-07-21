/////////////////////////////////////////////////////////
// Synnchronize for Async pulse/one-bit data
/////////////////////////////////////////////////////////
module pulse_synchronizer #(
  parameter bit     INIT_VALUE = 1'b0,
  parameter integer SYNC_STAGE = 4
) (
  input  logic clk,
  input  logic in,
  output logic out
);
  
  logic [SYNC_STAGE-1:0] data = {SYNNC_STAGE{INIT_VALUE}};
  
  always_ff @(posedge clk) begin
    data <= {data[SYNC_STAGE-2:0],in};
  end
  
  assign out = data[SYNC_STAGE-1];
  
endmodule
