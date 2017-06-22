interface cpu_if (
    input logic clk,
    input logic reset
);

logic         timeout;
logic         read;
logic         write;
logic  [31:0] write_data;
logic  [31:2] address;
logic  [31:0] read_data;
logic         access_complete;
logic         invalid_address;
logic         invalid_access;

modport Slave (
    input  clk,
    input  reset,
    input  timeout,
    input  read,
    input  write,
    input  write_data,
    input  address,
    output read_data,
    output access_complete,
    output invalid_address,
    output invalid_access
);

modport Master (
    input  clk,
    input  reset,
    output timeout,
    output read,
    output write,
    output write_data,
    output address,
    input  read_data,
    input  access_complete,
    input  invalid_address,
    input  invalid_access
);

endinterface

