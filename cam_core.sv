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

  localparam ADDR_DEPTH = 2**ADDR_WIDTH;
  logic [DATA_WIDTH-0:0] lookup_table [ADDR_DEPTH];
  logic [ADDR_DEPTH-1:0] lookup_hit_onehot;
  logic [ADDR_DEPTH-1:0] lookup_hit_bin;
  
  always_ff @(posedge clk) begin
    if (cam_we) begin
      lookup_table[cam_addr] <= {cam_valid,cam_data};
    end
  end
  
  genvar i;
  generate for (i=0; i<ADDR_DEPTH; i++) begin : lookup_gen
    assign lookup_hit_onehot[i] = lookup_table[i] == {1'b1,lookup_data};
  end endgenerate
  
  always_comb begin
    lookup_hit_bin = 0;
    for (int j=0; j<ADDR_DEPTH; j++) begin
      if (lookup_hit_onehot[j]) begin
        lookup_hit_bin |= j[ADDR_DEPTH-1:0];
      end
    end
  end
  
  always_ff @(posedge clk) begin
    lookup_addr <= lookup_hit_bin;
    lookup_hit  <= |lookup_hit_onehot;
  end
  
endmodule
