module byte_write_sdp_ram #(
  parameter ADDR_DEPTH = 32
  parameter DATA_WIDTH = 16,
  parameter ADDR_WIDTH = 32
) (
  input  logic                    wr_clk,
  input  logic                    wr_enable,
  input  logic [ADDR_WIDTH-1:0]   wr_address,
  input  logic [DATA_WIDTH-1:0]   wr_data,
  input  logic [DATA_WIDTH/8-1:0] wr_strb,
  input  logic                    rd_clk,
  input  logic [ADDR_WIDTH-1:0]   rd_address,
  output logic [DATA_WIDTH-1:0]   rd_data
);
  
  localparam ADDR_LSB = $clog2(DATA_WIDTH/8);
  localparam ADDR_MSB = $clog2(ADDR_DEPTH)+ADDR_LSB;
  logic [7:0][DATA_WIDTH/8-1:0] mem [ADDR_DEPTH];
  
  genvar i;
  generate for (i=0; i<DATA_WIDTH/8; i++) begin : write_byte
  always_ff @(posedge wr_clk) begin
    if (wr_enable) begin
        if (wr_strb[i]) begin
          mem[wr_address[ADDR_MSB-1:ADDR_LSB]][i] <= wr_data[8*i+:8];
        end
    end
  end
  end endgenerate
  
  always_ff @(posedge rd_clk) begin
    rd_data <= mem[rd_address[ADDR_MSB-1:ADDR_LSB]];
  end
  
endmodule
