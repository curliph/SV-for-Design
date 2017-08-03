// axis register slice for better timing and pipelining
module axis_registerslice #(
  parameter DATA_WIDTH = 8
  ) (
  input  logic                  aclk,
  input  logic                  areset,
  input  logic                  aclken,
  
  input  logic [DATA_WIDTH-1:0] s_tdata,
  input  logic                  s_tvalid,
  output logic                  s_tready,
  
  output logic [DATA_WIDTH-1:0] m_tdata,
  output logic                  m_tvalid,
  input  logic                  m_tready
  );
  
  // reset pipeline register
  logic [1:0] areset_d = 2'b11;
  
  // reset sync logic
  always_ff @(posedge aclk) begin
    if (aclken) begin
      areset_d <= {areset_d[0],areset};
    end
  end
    
  // state defenitions for axis-pipeline reg
  typedef enum {
    IDLE,           // No data store locally
    ONE_TX_LOCAL,   // One slave data stored locally
    TWO_TX_LOCAL    // Two slave data stored locally
  } state_type;
  state_type state = IDLE;
  
  logic [DATA_WIDTH-1:0] tdata [2]; // array to store max(2) data
  assign m_tdata = tdata[0];
  
  // slave tdata store logic
  always_ff @(posedge aclk) begin
    if (aclken) begin
      if (state == IDLE && s_tvalid) begin
        tdata[0] <= s_tdata;
      end else if (state == ONE_TX_LOCAL && s_tvalid && m_tready) begin
        tdata[0] <= s_tdata;
      end else if (state == TWO_TX_LOCAL && m_tready) begin
        tdata[0] <= tdata[1];
      end
      if (s_tvalid && s_tready) begin
        tdata[1] <= s_tdata;
      end
    end
  end
  
  // state-machine description for axis-pipeline reg   
  always_ff @(posedge aclk) begin
    if (areset) begin
      s_tready <= 1'b0;
      m_tvalid <= 1'b0;
      state <= IDLE;
    end else if (aclken && areset_d == 2'b10) begin
      s_tready <= 1'b1;
      m_tvalid <= 1'b0;
      state <= IDLE;
    end else if (aclken && areset_d == 2'b00) begin
      case (state)
        IDLE : begin
          if (s_tvalid) begin
            state <= ONE_TX_LOCAL;
            m_tvalid <= 1'b1;
          end
        end
        ONE_TX_LOCAL : begin
          if (~s_tvalid && m_tready) begin
            state <= IDLE;
            m_tvalid <= 1'b0;
          end else if (s_tvalid && ~m_tready) begin
            state <= TWO_TX_LOCAL;
            s_tready <= 1'b0;
            m_tvalid <= 1'b1;
          end
        end
        TWO_TX_LOCAL : begin
          if (m_tready) begin
            state <= ONE_TX_LOCAL;
            s_tready <= 1'b1;
            m_tvalid <= 1'b1;
          end
        end
        default : begin
          s_tready <= 1'b1;
          m_tvalid <= 1'b0;
          state <= IDLE;
        end
      endcase
    end
  end
  
endmodule
