// ADD/SUB Design {SUB = using 2's Complement Addition}
// 2'Complement ADD = 1'Complement (OP) + 1
// ADD = OP1 +  OP2 + 1'b0;
// SUB = OP1 + ~OP2 + 1'b1;
// XOR = if (A==1) ~B else B;
// Sum/Diff = OP1 + (OP2^ctrl) + ctrl;
module optimal_add_sub #(
  parameter DATA_WIDTH = 8
) (
  input  logic [DATA_WIDTH-1:0] op1,
  input  logic [DATA_WIDTH-1:0] op2,
  input  logic ctrl, // 0/1 = ADD/SUB
  output logic [DATA_WIDTH-0:0] result
);
  
  logic cout;
  logic [DATA_WIDTH-1:0] sum;
  // Full-Addrer
  bin_full_adder #(
    .DATA_WIDTH (DATA_WIDTH)
  ) bin_full_adder_inst (
    .op1  (op1),
    .op2  ({DATA_WIDTH{ctrl}} ^ op2),
    .cin  (ctrl),
    .sum  (sum),
    .cout (cout)
  );
  assign result = {cout,sum};
  
endmodule

module bin_full_adder #(
  parameter DATA_WIDTH = 8
) (
  input  logic [DATA_WIDTH-1:0] op1,
  input  logic [DATA_WIDTH-1:0] op2,
  input  logic cin,
  output logic [DATA_WIDTH-1:0] sum,
  output logic cout
);
  
  always_comb begin
    {cout,sum} = op1 + op2 + cin;
  end
  
endmodule
