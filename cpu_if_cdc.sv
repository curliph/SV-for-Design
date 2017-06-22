module cpu_if_cdc #( parameter SYNC_STAGE = 3 ) (
    cpu_if.Master cpu_h,
    cpu_if.Slave  cpu_l
);

logic cpu_l_ready;

// Read pulse sync logic
logic cpu_l_read_r1 = 0;
logic cpu_l_read_r2 = 0;
logic cpu_l_read_valid;

always_ff @(posedge cpu_l.clk) begin
    cpu_l_read_r1 <= cpu_l.read;
    cpu_l_read_r2 <= cpu_l_read_r1;
end

logic cpu_l_read_pulse;
logic cpu_l_read_pulse_valid;

assign cpu_l_read_pulse = ~cpu_l_read_r2 && cpu_l_read_r1;
assign cpu_l_read_pulse_valid = cpu_l_read_pulse & cpu_l_ready;

cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
cpu_if_pulse_sync_cpu_l_read_sync (
    .clk   ( cpu_l.clk ) ,
    .in    ( cpu_l_read_pulse_valid ) ,
    .out   ( cpu_l_read_sync ) 
);

cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
cpu_if_pulse_sync_cpu_h_read_sync (
    .clk   ( cpu_h.clk ) ,
    .in    ( cpu_l_read_sync ) ,
    .out   ( cpu_h_read_sync ) 
);

logic cpu_h_read_r1 = 0;
logic cpu_h_read_r2 = 0;

always_ff @(posedge cpu_h.clk) begin
    cpu_h_read_r1 <= cpu_h_read_sync;
    cpu_h_read_r2 <= cpu_h_read_r1;
end

logic cpu_h_read_pulse;
assign cpu_h_read_pulse = ~cpu_h_read_r2 && cpu_h_read_r1;

always_ff @(posedge cpu_h.clk) begin
    cpu_h.read <= cpu_h_read_pulse;
end

// Write pulse sync logic
logic cpu_l_write_r1 = 0;
logic cpu_l_write_r2 = 0;
logic cpu_l_write_valid;

always_ff @(posedge cpu_l.clk) begin
    cpu_l_write_r1 <= cpu_l.write;
    cpu_l_write_r2 <= cpu_l_write_r1;
end

logic cpu_l_write_pulse;
logic cpu_l_write_pulse_valid;

assign cpu_l_write_pulse = ~cpu_l_write_r2 && cpu_l_write_r1;
assign cpu_l_write_pulse_valid = cpu_l_write_pulse & cpu_l_ready;

cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
cpu_if_pulse_sync_cpu_l_write_sync (
    .clk   ( cpu_l.clk ) ,
    .in    ( cpu_l_write_pulse_valid ) ,
    .out   ( cpu_l_write_sync ) 
);

cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
cpu_if_pulse_sync_cpu_h_write_sync (
    .clk   ( cpu_h.clk ) ,
    .in    ( cpu_l_write_sync ) ,
    .out   ( cpu_h_write_sync )
);

logic cpu_h_write_r1 = 0;
logic cpu_h_write_r2 = 0;

always_ff @(posedge cpu_h.clk) begin
    cpu_h_write_r1 <= cpu_h_write_sync;
    cpu_h_write_r2 <= cpu_h_write_r1;
end

logic cpu_h_write_pulse;
assign cpu_h_write_pulse = ~cpu_h_write_r2 && cpu_h_write_r1;

always_ff @(posedge cpu_h.clk) begin
    cpu_h.write <= cpu_h_write_pulse;
end

logic [31:0] cpu_h_write_data_sync;

cpu_if_data_sync #( .DATA_WIDTH (32) )
cpu_if_data_sync_cpu_l_write_data_sync (
    .clk ( cpu_l.clk ) ,
    .sel ( cpu_l_write_pulse_valid ) ,
    .in  ( cpu_l.write_data ) ,
    .out ( cpu_l_write_data_sync )
);

cpu_if_data_sync #( .DATA_WIDTH (32) )
cpu_if_data_sync_cpu_h_write_data (
    .clk ( cpu_h.clk ) ,
    .sel ( cpu_h_write_pulse ) ,
    .in  ( cpu_l_write_data_sync ) ,
    .out ( cpu_h.write_data )
);

logic [31:2] cpu_l_address_sync;

cpu_if_data_sync #( .DATA_WIDTH (30) )
cpu_if_data_sync_cpu_l_address_sync (
    .clk ( cpu_l.clk ) ,
    .sel ( cpu_l_write_pulse_valid | cpu_l_read_pulse_valid ) ,
    .in  ( cpu_l.address ) ,
    .out ( cpu_l_address_sync )
);

cpu_if_data_sync #( .DATA_WIDTH (30) )
cpu_if_data_sync_cpu_h_address (
    .clk ( cpu_h.clk ) ,
    .sel ( cpu_h_write_pulse | cpu_h_read_pulse ) ,
    .in  ( cpu_l_address_sync ) ,
    .out ( cpu_h.address )
);

logic cpu_h_access_complete_r1 = 0;
logic cpu_h_access_complete_r2 = 0;

always_ff @(posedge cpu_h.clk) begin
    cpu_h_access_complete_r1 <= cpu_h.access_complete;
    cpu_h_access_complete_r2 <= cpu_h_access_complete_r1;
end

logic cpu_h_access_complete_pulse;
assign cpu_h_access_complete_pulse = ~cpu_h_access_complete_r2 && cpu_h_access_complete_r1;

logic cpu_h_access_complete_latch = 0;

always_ff @(posedge cpu_h.clk) begin
    cpu_h_access_complete_latch <= cpu_h_access_complete_latch ^ cpu_h_access_complete_pulse;
end

logic [31:0] cpu_h_read_data_latch;

cpu_if_data_sync #( .DATA_WIDTH (32) )
cpu_if_data_sync_cpu_h_read_data_latch (
    .clk ( cpu_h.clk ) ,
    .sel ( cpu_h_access_complete_pulse ) ,
    .in  ( cpu_h.read_data ) ,
    .out ( cpu_h_read_data_latch )
);

cpu_if_pulse_sync #( .SYNC_STAGE(SYNC_STAGE) ) 
cpu_if_pulse_sync_cpu_h_access_complete_latch (
    .clk   ( cpu_l.clk ) ,
    .in    ( cpu_h_access_complete_latch ) ,
    .out   ( cpu_l_access_complete_latch ) 
);

logic cpu_l_access_complete_r1 = 0;
logic cpu_l_access_complete_r2 = 0;

always_ff @(posedge cpu_l.clk) begin
    cpu_l_access_complete_r1 <= cpu_l_access_complete_latch;
    cpu_l_access_complete_r2 <= cpu_l_access_complete_r1;
end

logic cpu_l_access_complete_pulse;
assign cpu_l_access_complete_pulse = cpu_l_access_complete_r2 ^ cpu_l_access_complete_r1;

always_ff @(posedge cpu_l.clk) begin
    cpu_l.access_complete <= cpu_l_access_complete_pulse;
end

cpu_if_control_fsm cpu_l_control_fsm (
    .clk             ( cpu_l.clk ) , 
    .reset           ( cpu_l.reset ) , 
    .read            ( cpu_l_read_pulse ) , 
    .write           ( cpu_l_write_pulse ) , 
    .access_complete ( cpu_l_access_complete_pulse ) ,
    .ready           ( cpu_l_ready ) ,
    .read_busy       ( cpu_l_read_valid ) ,
    .write_busy      ( cpu_l_write_valid )
);

cpu_if_data_sync #( .DATA_WIDTH (32) )
cpu_if_data_sync_cpu_l_read_data (
    .clk ( cpu_l.clk ) ,
    .sel ( cpu_l_access_complete_pulse & cpu_l_read_valid ) ,
    .in  ( cpu_h_read_data_latch ) ,
    .out ( cpu_l.read_data )
);

endmodule

module cpu_if_data_sync #( parameter DATA_WIDTH = 1 ) (
    input  logic clk,
    input  logic sel,
    input  logic [DATA_WIDTH-1:0] in,
    output logic [DATA_WIDTH-1:0] out
);

logic [DATA_WIDTH-1:0] data = {DATA_WIDTH{1'b0}};

always_ff @(posedge clk) begin
    data <= sel ? in : data;
end

assign out = data;

endmodule

module cpu_if_pulse_sync #( parameter SYNC_STAGE = 3 ) (
    input  logic clk,
    input  logic in,
    output logic out
);

logic [SYNC_STAGE-1:0] data = {SYNC_STAGE{1'b0}};

always_ff @(posedge clk) begin
    data <= {data[SYNC_STAGE-2:0],in};
end

assign out = data[SYNC_STAGE-1];

endmodule
