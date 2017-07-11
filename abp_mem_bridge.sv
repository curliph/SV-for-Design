// AMBA3-APB Master to Slave bridge
module #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32,
  parameter PSEL_WIDTH = 1
  ) (
  input  logic PCLK,
  input  logic PRESETn,
  input  logic [ADDR_WIDTH-1:0] PADDR,
  input  logic [PSEL_WIDTH-1:0] PSELx,
  input  logic PSELECT,
  input  logic PWRITE,
  input  logic [DATA_WIDTH-1:0] PWDATA,
  output logic PREADY,
  output logic [DATA_WIDTH-1:0] PRDATA,
  output logic PSLVERR,
  
  output logic [PSEL_WIDTH-1:0] read,
  output logic [PSEL_WIDTH-1:0] write,
  output logic [ADDR_WIDTH-1:0] address,
  output logic [DATA_WIDTH-1:0] write_data,
  input  logic [DATA_WIDTH-1:0] read_data,
  input  logic [PSEL_WIDTH-1:0] access_complete,
  input  logic [PSEL_WIDTH-1:0] invalid_access,
  input  logic [PSEL_WIDTH-1:0] invalid_address
  );
  
  // state defanitions for APB Transactions
  typedef enum {IDLE,SETUP,ACCESS} state_type;
  state_type state = IDLE;
  
  // state-machine description
  always @(posedge PCLK) begin
    if (PRESETn) begin
    end else begin
    end
  end
  
endmodule
