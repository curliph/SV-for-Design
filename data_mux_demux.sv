module data_mux #(
  parameter integer DATA_WIDTH = 8,
  parameter integer MSEL_WIDTH = 1,
  parameter integer NO_CHANNEL = 2**MSEL_WIDTH
) (
  input  logic [DATA_WIDTH-1:0] in [NO_CHANNEL],
  input  logic [MSEL_WIDTH-1:0] sel,
  output logic [DATA_WIDTH-1:0] out
);
  
  assign out = in[sel];

endmodule

module data_demux #(
  parameter integer DATA_WIDTH = 8,
  parameter integer MSEL_WIDTH = 1,
  parameter integer NO_CHANNEL = 2**MSEL_WIDTH
) (
  input  logic [DATA_WIDTH-1:0] fb [NO_CHANNEL],
  input  logic [DATA_WIDTH-1:0] in,
  input  logic [MSEL_WIDTH-1:0] sel,
  output logic [DATA_WIDTH-1:0] out [NO_CHANNEL]
);
  
  genvar i;
  generate for (i=0; i<NO_CHANNEL; i++) begin : gen_demux
    assign out[i] = i==sel ? in : fb[i];
  end endgenerate

endmodule
