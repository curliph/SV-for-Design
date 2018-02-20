module cpu_if_cdc #( parameter SYNC_STAGE = 3 ) (
  cpu_if.Master cpu_h,
  cpu_if.Slave  cpu_l
);
  
  logic cpu_access_ready;
  logic cpu_access_type;
  logic cpu_access_request;
  logic [31:2] cpu_address;
  logic [31:0] cpu_write_data;
  logic [31:0] cpu_read_data;
  
  cpu_if_control_fsm cpu_l_control_fsm (
    .clk             ( cpu_l.clk ) , 
    .reset           ( cpu_l.reset ) , 
    .read            ( cpu_l.read ) , 
    .write           ( cpu_l.write ) , 
    .access_complete ( cpu_l.access_complete ) ,
    .access_type     ( cpu_access_type ) ,
    .access_ready    ( cpu_access_ready )
  );
  
  cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
  cpu_if_pulse_sync_req (
    .aclk   ( cpu_l.clk ) ,
    .areset ( cpu_l.reset ) ,
    .adin   ( (cpu_l.read|cpu_l.write) & cpu_access_ready ) ,
    .bclk   ( cpu_h.clk ) ,
    .bdout  ( cpu_access_request ) 
  );
  
  always_ff @(posedge cpu_l.clk) begin
    if ((cpu_l.read|cpu_l.write) & cpu_access_ready) begin
      cpu_address <= cpu_l.address;
    end
  end
  always_ff @(posedge cpu_l.clk) begin
    if (cpu_l.write & cpu_access_ready) begin
      cpu_write_data <= cpu_l.write_data;
    end
  end
  
  assign cpu_h.read = cpu_access_request & ~cpu_access_type;
  assign cpu_h.write = cpu_access_request & cpu_access_type;
  assign cpu_h.address = cpu_address;
  assign cpu_h.write_data = cpu_write_data;
  
  cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
  cpu_if_pulse_sync_ack (
    .aclk   ( cpu_h.clk ) ,
    .areset ( cpu_h.reset ) ,
    .adin   ( cpu_h.access_complete ) ,
    .bclk   ( cpu_l.clk ) ,
    .bdout  ( cpu_l.access_complete ) 
  );
  
  always_ff @(posedge cpu_h.clk) begin
    if (cpu_h.access_complete) begin
      cpu_read_data <= cpu_h.read_data;
    end
  end
  assign cpu_l.read_data = cpu_read_data;
  
endmodule

module cpu_if_pulse_sync #( parameter SYNC_STAGE = 3 ) (
  input  logic aclk,
  input  logic areset,
  input  logic adin,
  input  logic bclk,
  output logic bdout
);
  
  logic aqualifier;
  logic bqualifier,bqualifier_d;
  always_ff @(posedge aclk) begin
    if (areset) begin
      qualifier <= 1'b0
    end else begin
      qualifier <= qualifier ^ adin;
    end
  end
  cpu_if_bit_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
  cpu_if_bit_sync_qualifier (
    .clk   ( bclk ) ,
    .din   ( aqualifier ) ,
    .dout  ( bqualifier ) 
  );
  always_ff @(posedge bclk) begin
    bqualifier_d <= bqualifier;
  end
  assign bdout = bqualifier_d ^ bqualifier;
  
endmodule

module cpu_if_bit_sync #( parameter SYNC_STAGE = 3 ) (
  input  logic clk,
  input  logic din,
  output logic dout
);
  
  logic [SYNC_STAGE-1:0] data;
  always_ff @(posedge clk) begin
    data <= {data[SYNC_STAGE-2:0],din};
  end
  assign dout = data[SYNC_STAGE-1];
  
endmodule
