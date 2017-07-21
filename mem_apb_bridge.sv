// AMBA3-APB Slave to Master bridge with
// True-Round-Robin Arbiteration
module mem_apb_bridge #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32,
  parameter PSEL_WIDTH = 1
  ) (
  input  logic                  PCLK,
  input  logic                  PRESETn,
  output logic [ADDR_WIDTH-1:0] PADDR,
  output logic [PSEL_WIDTH-1:0] PSELx,
  output logic                  PENABLE,
  output logic                  PWRITE,
  output logic [DATA_WIDTH-1:0] PWDATA,
  input  logic                  PREADY,
  input  logic [DATA_WIDTH-1:0] PRDATA,
  input  logic                  PSLVERR,
  
  input  logic [PSEL_WIDTH-1:0] read,
  input  logic [PSEL_WIDTH-1:0] write,
  input  logic [ADDR_WIDTH-1:0] address,
  input  logic [DATA_WIDTH-1:0] write_data,
  output logic [DATA_WIDTH-1:0] read_data,
  output logic [PSEL_WIDTH-1:0] access_complete = 0,
  output logic [PSEL_WIDTH-1:0] invalid_access = 0,
  output logic [PSEL_WIDTH-1:0] invalid_address = 0
  );
  
  // state defanitions for APB Transactions
  typedef enum {IDLE,SETUP,ACCESS} state_type;
  state_type state = IDLE;
  
  logic [PSEL_WIDTH-1:0] channel_select;
    
  logic transfer_read;
  logic transfer_write;
  
  assign transfer_read  = read  && channel_select;
  assign transfer_write = write && channel_select;
    
  // PADDR generation logic
  always_ff @(posedge PCLK) begin
    if (state == IDLE && (transfer_read | transfer_write)) begin
      PADDR <= address;
    end else if (state == ACCESS && PREADY && (transfer_read | transfer_write)) begin
      PADDR <= address;
    end
  end
  
  // PWRITE generation logic
  always_ff @(posedge PCLK) begin
    if (!PRESETn) begin
      PWRITE <= 1'b0;
    end else if (state == IDLE && transfer_write) begin
      PWRITE <= 1'b1;
    end else if (state == ACCESS && PREADY && transfer_write) begin
      PWRITE <= 1'b1;
    end else if (state == ACCESS && PREADY) begin
      PWRITE <= 1'b0;
    end
  end
  
  // PWDATA generation logic
  always_ff @(posedge PCLK) begin
    if (state == IDLE && transfer_write) begin
      PWDATA <= write_data;
    end else if (state == ACCESS && PREADY && transfer_write) begin
      PWDATA <= write_data;
    end
  end
  
  // read_data generation logic
  always_ff @(posedge PCLK) begin
    if (state == ACCESS && PREADY && !PWRITE) begin
      read_data <= PRDATA;
    end
  end
  
  // access_complete generation logic
  always_ff @(posedge PCLK) begin
    if (!PRESETn) begin
      access_complete <= {PSEL_WIDTH{1'b0}};
    end else if (state == ACCESS && PREADY) begin
      access_complete <= channel_select >>> 1;
    end else begin
      access_complete <= {PSEL_WIDTH{1'b0}};
    end
  end
  
  // invalid_access generation logic
  always_ff @(posedge PCLK) begin
    if (!PRESETn) begin
      invalid_access <= {PSEL_WIDTH{1'b0}};
    end else if (state == ACCESS && PREADY && PSLVERR) begin
      invalid_access <= channel_select >>> 1;
    end else begin
      invalid_access <= {PSEL_WIDTH{1'b0}};
    end
  end
  
  // state-machine description
  always_ff @(posedge PCLK) begin
    if (!PRESETn) begin
      state <= IDLE;
      PSELx <= {PSEL_WIDTH{1'b0}};
      PENABLE <= 1'b0;
      channel_select <= {{PSEL_WIDTH-1{1'b0}},1'b1};
    end else begin
      case (state)
        IDLE : begin
          if (transfer_read | transfer_write) begin
            state <= SETUP;
            PSELx <= channel_select;
          end
          channel_select <= channel_select <<< 1;
        end
        SETUP : begin
          state <= ACCESS;
          PENABLE <= 1'b1;
        end
        ACCESS : begin
          if (PREADY && (transfer_read | transfer_write)) begin
            state <= SETUP;
            PSELx <= channel_select;
            channel_select <= channel_select <<< 1;
          end else if (PREADY) begin
            state <= IDLE;
            PSELx <= {PSEL_WIDTH{1'b0}};
            PENABLE <= 1'b0;
          end
        end
        default : begin
          state <= IDLE;
          PSELx <= {PSEL_WIDTH{1'b0}};
          PENABLE <= 1'b0;
          channel_select <= {{PSEL_WIDTH-1{1'b0}},1'b1};
        end
      endcase
    end
  end
  
endmodule
