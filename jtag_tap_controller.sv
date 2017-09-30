module jtag_tap_controller #(
  parameter DATA_WIDTH = 32
) (
  input  logic TCLK,
  input  logic TRST,
  input  logic TMS,
  input  logic TDI,
  output logic TDO,
  output logic clk,
  output logic reset,
  output logic [DATA_WIDTH-1:0] data_reg,
  output logic data_reg_valid,
  output logic [DATA_WIDTH-1:0] inst_reg,
  output logic inst_reg_valid
);
  
  assign clk = TCLK;
  assign reset = TRST;
  
  typedef enum {
    TEST_RESET,TEST_IDLE,
    DR_SELECT,DR_CAPTURE,DR_SHIFT,DR_EXIT1,DR_PAUSE,DR_EXIT2,DR_UPDATE,
    IR_SELECT,IR_CAPTURE,IR_SHIFT,IR_EXIT1,IR_PAUSE,IR_EXIT2,IR_UPDATE
  } state_type;
  state_type state;
  
  always_ff @(posedge clk) begin
    if (reset) begin
      data_reg_valid <= 1'b0;
    end else begin
      data_reg_valid <= state == DR_UPDATE;
    end
  end
  
  always_ff @(posedge clk) begin
    if (state == DR_SHIFT) begin
      data_reg <= {data_reg[DATA_WIDTH-2:0],TDI};
    end
  end
  
  always_ff @(posedge clk) begin
    if (reset) begin
      inst_reg_valid <= 1'b0;
    end else begin
      inst_reg_valid <= state == IR_UPDATE;
    end
  end
  
  always_ff @(posedge clk) begin
    if (state == IR_SHIFT) begin
      inst_reg <= {inst_reg[DATA_WIDTH-2:0],TDI};
    end
  end
  
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= TEST_RESET;
    end else begin
      case (state)
        TEST_RESET : state <= TMS ? TEST_RESET : TEST_IDLE;
        TEST_IDLE  : state <= TMS ? DR_SELECT  : TEST_IDLE;
        DR_SELECT  : state <= TMS ? IR_SELECT  : DR_CAPTURE;
        DR_CAPTURE : state <= TMS ? DR_EXIT1   : DR_SHIFT;
        DR_SHIFT   : state <= TMS ? DR_EXIT1   : DR_SHIFT;
        DR_EXIT1   : state <= TMS ? DR_UPDATE  : DR_PAUSE;
        DR_PAUSE   : state <= TMS ? DR_EXIT2   : DR_PAUSE;
        DR_EXIT2   : state <= TMS ? DR_UPDATE  : DR_SHIFT;
        DR_UPDATE  : state <= TMS ? DR_SELECT  : TEST_IDLE;
        IR_SELECT  : state <= TMS ? TEST_RESET : IR_CAPTURE;
        IR_CAPTURE : state <= TMS ? IR_EXIT1   : IR_SHIFT;
        IR_SHIFT   : state <= TMS ? IR_EXIT1   : IR_SHIFT;
        IR_EXIT1   : state <= TMS ? IR_UPDATE  : IR_PAUSE;
        IR_PAUSE   : state <= TMS ? IR_EXIT2   : IR_PAUSE;
        IR_EXIT2   : state <= TMS ? IR_UPDATE  : IR_SHIFT;
        IR_UPDATE  : state <= TMS ? DR_SELECT  : TEST_IDLE;
        default    : state <= TEST_RESET;
      endcase
    end
  end
  
endmodule
