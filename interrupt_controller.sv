module interrupt_controller #(
  parameter IRQ_SENSITIVITY = 1, // 0/1 level/edge
  parameter IRQ_ACTIVESTATE = 1, // 1/0 posedge/negedge or level-high/low
  parameter INTR_WIDTH = 8,
  parameter ADDR_WIDTH = 5,
  parameter DATA_WIDTH = 32,
) (
  input  logic                  clk,
  input  logic                  reset,
  input  logic [INTR_WIDTH-1:0] ext_intr,
  input  logic                  cpu_read,
  input  logic                  cpu_write,
  input  logic [ADDR_WIDTH-1:0] cpu_address,
  input  logic [DATA_WIDTH-1:0] cpu_write_data,
  output logic [DATA_WIDTH-1:0] cpu_read_data,
  output logic                  cpu_access_complete,
  output logic                  cpu_irq
);
  // interrupt controller registers
  logic [INTR_WIDTH-1:0] intr_ack;
  logic [INTR_WIDTH-1:0] intr_enable;
  logic [INTR_WIDTH-1:0] intr_status;
  logic [INTR_WIDTH-1:0] intr_pending;
  logic [INTR_WIDTH-1:0] read_data;
  // hw-irq generation
  logic intr_ack_all;
  logic intr_pending_all;
  
  always_ff @(posedge clk) begin
    intr_pending_all <= |intr_pending;
    intr_ack_all <= |intr_ack;
  end
  generate if (IRQ_SENSITIVITY) begin : irq_sensitivity
    logic intr_lvl,intr_lvl_d;
    if (IRQ_ACTIVESTATE) begin : irq_active_edge
      always_ff @(posedge clk) begin
        if (reset|intr_ack_all) begin
          intr_lvl <= 1'b0;
          intr_lvl_d <= 1'b0;
        end else if (intr_pending_all) begin
          intr_lvl <= 1'b1;
          intr_lvl_d <= intr_lvl;
        end
      end
      assign cpu_irq = intr_lvl & ~intr_lvl_d;
    end else begin
      always_ff @(posedge clk) begin
        if (reset|intr_ack_all) begin
          intr_lvl <= 1'b1;
          intr_lvl_d <= 1'b1;
        end else if (intr_pending_all) begin
          intr_lvl <= 1'b0;
          intr_lvl_d <= intr_lvl;
        end
      end
      assign cpu_irq = ~(~intr_lvl & intr_lvl_d);
    end
  end else begin
    if (IRQ_ACTIVESTATE) begin : irq_level_state
      always_ff @(posedge clk) begin
        if (reset|intr_ack_all) begin
          cpu_irq <= 1'b0;
        end else if (intr_pending_all) begin
          cpu_irq <= 1'b1;
        end
      end
    end else begin
      always_ff @(posedge clk) begin
        if (reset|intr_ack_all) begin
          cpu_irq <= 1'b1;
        end else if (intr_pending_all) begin
          cpu_irq <= 1'b0;
        end
      end
    end
  end endgenerate
  // sw-interrupt enable-register
  always_ff @(posedge clk) begin
    if (reset) begin
      intr_enable <= {INTR_WIDTH{1'b0}};
    end else if (cpu_write && cpu_address[ADDR_WIDTH-1:2] == 'd0) begin
      intr_enable <= cpu_write_data[INTR_WIDTH-1:0];
    end
  end
  
  generate for(genvar i=0; i<INTR_WIDTH; i++) begin: gen_intr
    // sw-interrupt ack-register & hw-selfclear
    always_ff @(posedge clk) begin
      if (reset|intr_ack[i]) begin
        intr_ack[i] <= 1'b0;
      end else if (cpu_write && cpu_address[ADDR_WIDTH-1:2] == 'd1) begin
        intr_ack[i] <= cpu_write_data[i];
      end
    end
    // hw-interrupt-status/sw-interrupt-inject register
    always_ff @(posedge clk) begin
      if (reset|intr_ack[i]) begin
        intr_pending[i] <= 1'b0;
      end else if (cpu_write && cpu_address[ADDR_WIDTH-1:2] == 'd2) begin
        intr_pending[i] <= intr_pending[i] | cpu_write_data[i];
      end else if (intr_enable[i] && intr_status[i]) begin
        intr_pending[i] <= 1'b1;
      end
    end
    // hw-interrupt-livestatus register
    always_ff @(posedge clk) begin
      if (reset|intr_ack[i]) begin
        intr_status[i] <= 1'b0;
      end else begin
        intr_status[i] <= ext_intr[i];
      end
    end
  end endgenerate
  // register read logic
  always_ff @(posedge clk) begin
    if (reset) begin
      read_data <= 'd0;
    end else if (cpu_read) begin
      case(cpu_address[3:2])
        2'd0    : read_data <= intr_enable;
        2'd1    : read_data <= intr_ack;
        2'd2    : read_data <= intr_pending;
        2'd3    : read_data <= intr_status;
        default : read_data <= 'd0;
      endcase
    end
  end
  assign cpu_read_data = {{ADDR_WIDTH-INTR_WIDTH{1'b0}},read_data};
  // register access complete
  always_ff @(posedge clk) begin
    cpu_access_complete <= cpu_read|cpu_write;
  end
  
endmodule
