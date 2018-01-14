module cam_core #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 5
  ) (
  input  logic                  clk,
  input  logic                  reset,
  
  input  logic                  cam_we,
  input  logic [ADDR_WIDTH-1:0] cam_addr,
  input  logic [DATA_WIDTH-1:0] cam_data,
  input  logic                  cam_valid,
  
  input  logic [DATA_WIDTH-1:0] lookup_data,
  output logic [ADDR_WIDTH-1:0] lookup_addr,
  output logic                  lookup_hit
);



endmodule
