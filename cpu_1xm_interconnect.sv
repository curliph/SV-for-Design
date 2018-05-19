`timescale 1ns/1ps
module cpu_1xm_interconnect #(
  parameter int MASK_MSB = 20,
  parameter int MASK_LSB = 20,
  parameter int MSEL_WIDTH = MASK_MSB-MASK_LSB+1,
  parameter int CHANNEL_NO = 2**MSEL_WIDTH,
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) (
  input  logic                  clk,
  input  logic                  reset,
  
  input  logic                  cpu_s_write,
  input  logic                  cpu_s_read,
  input  logic [ADDR_WIDTH-1:0] cpu_s_address,
  input  logic [DATA_WIDTH-1:0] cpu_s_write_data,
  output logic [DATA_WIDTH-1:0] cpu_s_read_data,
  output logic                  cpu_s_access_ready,
  output logic                  cpu_s_access_complete,
  
  output logic                  cpu_m_write          [CHANNEL_NO],
  output logic                  cpu_m_read           [CHANNEL_NO],
  output logic [ADDR_WIDTH-1:0] cpu_m_address        [CHANNEL_NO],
  output logic [DATA_WIDTH-1:0] cpu_m_write_data     [CHANNEL_NO],
  input  logic [DATA_WIDTH-1:0] cpu_m_read_data      [CHANNEL_NO],
  input  logic                  cpu_m_access_ready   [CHANNEL_NO],
  input  logic                  cpu_m_access_complete[CHANNEL_NO]
);
  
  logic cpu_s_access_valid;
  logic cpu_m_access_valid;
  
endmodule
