module byte_write_sdp_ram #(
  parameter DATA_WIDTH = 16,
  parameter ADDR_WIDTH = 9
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
  logic [7:0][DATA_WIDTH/8-1:0] mem [2**(ADDR_WIDTH-ADDR_LSB)];
  
  logic                    wr_enable_r;
  logic [ADDR_WIDTH-1:0]   wr_address_r;
  logic [DATA_WIDTH-1:0]   wr_data_r;
  logic [DATA_WIDTH-1:0]   rd_data_r;
  logic [DATA_WIDTH/8-1:0] wr_strb_r;
  
  always_ff @(posedge wr_clk) begin
    wr_enable_r <= wr_enable;
    wr_address_r <= wr_address;
    wr_data_r <= wr_data;
    wr_strb_r <= wr_strb;
    rd_data_r <= mem[wr_address[ADDR_WIDTH-1:ADDR_LSB]];
  end
  integer i;
  always_ff @(posedge wr_clk) begin
    if (wr_enable_r) begin
      for (i=0; i<DATA_WIDTH/8; i++) begin
        if (wr_strb_r[i]) begin
          mem[wr_address_r[ADDR_WIDTH-1:ADDR_LSB]][i] <= wr_data_r[8*i+:8];
        end else begin
          mem[wr_address_r[ADDR_WIDTH-1:ADDR_LSB]][i] <= rd_data_r[8*i+:8];
        end
      end
    end
  end
  
  always_ff @(posedge rd_clk) begin
    rd_data <= mem[rd_address[ADDR_WIDTH-1:ADDR_LSB]];
  end
  
endmodule
