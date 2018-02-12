module interrupt_controller #(
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
  
  logic [INTR_WIDTH-1:0] intr_ack;
  logic [INTR_WIDTH-1:0] intr_enable;
  logic [INTR_WIDTH-1:0] intr_status;
  logic [INTR_WIDTH-1:0] intr_pending;
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
      cpu_read_data <= 'd0;
    end else if (cpu_read) begin
      case(cpu_address[3:2])
        2'd0    : cpu_read_data <= intr_enable;
        2'd1    : cpu_read_data <= intr_ack;
        2'd2    : cpu_read_data <= intr_pending;
        2'd3    : cpu_read_data <= intr_status;
        default : cpu_read_data <= 'd0;
      endcase
    end
  end
  
endmodule
