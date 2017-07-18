// AMBA3-APB Master to Slave bridge
module #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32,
  parameter PSEL_WIDTH = 1
  ) (
  input  logic                  PCLK,
  input  logic                  PRESETn,
  input  logic [ADDR_WIDTH-1:0] PADDR,
  input  logic [PSEL_WIDTH-1:0] PSELx,
  input  logic                  PENABLE,
  input  logic                  PWRITE,
  input  logic [DATA_WIDTH-1:0] PWDATA,
  output logic                  PREADY,
  output logic [DATA_WIDTH-1:0] PRDATA,
  output logic                  PSLVERR,
  
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
  
  logic transfer_complete;
  logic transfer_slverror;
  
  assign transfer_complete = (|invalid_access) | (|invalid_address) | (|access_complete);
  assign transfer_slverror = (|invalid_access) | (|invalid_address);
  
  // read and write generation logic
  always_ff @(posedge PCLK) begin
    if (|PSELx && !PENABLE && PWRITE) begin
      read  <= {PSEL_WIDTH{1'b0}};
      write <= PSELx;
    end else if (|PSELx && !PENABLE) begin
      read  <= PSELx;
      write <= {PSEL_WIDTH{1'b0}};
    end else begin
      read  <= {PSEL_WIDTH{1'b0}};
      write <= {PSEL_WIDTH{1'b0}};
    end
  end
  
  // address generation logic
  always_ff @(posedge PCLK) begin
    if (|PSELx && !PENABLE) begin
      address <= PADDR;
    end
  end
  
  // write_data generation logic
  always_ff @(posedge PCLK) begin
    if (|PSELx && PENABLE && PWRITE) begin
      write_data <= PWDATA;
    end
  end
  
  // PREADY generation logic
  always_ff @(posedge PCLK) begin
    if (state == ACCESS && transfer_complete) begin
      PREADY <= 1'b1;
    end else begin
      PREADY <= 1'b0;
    end
  end
  
  // PRDATA generation logic
  always_ff @(posedge PCLK) begin
    if (state == ACCESS && transfer_complete) begin
      PRDATA <= read_data;
    end
  end
  
  // PSLVERR generation logic
  always_ff @(posedge PCLK) begin
    if (state == ACCESS && transfer_slverror) begin
      PSLVERR <= 1'b1;
    end else begin
      PSLVERR <= 1'b0;
    end
  end
  
  // state-machine description
  always_ff @(posedge PCLK) begin
    if (PRESETn) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE : begin
          if (|PSELx && !PENABLE) begin
            state <= SETUP;
          end
        end
        SETUP : begin
          if (|PSELx && PENABLE) begin
            state <= ACCESS;
          end else if (|PSELx && !PENABLE) begin
            state <= SETUP;
          end else begin
            state <= IDLE;
          end
        end
        ACCESS : begin
          if (!(|PSELx)) begin
            state <= IDLE;
          end else if (|PSELx && !PENABLE) begin
            state <= SETUP;
          end
        end
        default : begin
          state <= IDLE;
        end
      endcase
    end
  end
  
endmodule
