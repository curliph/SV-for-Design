`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2015 11:03:45
// Design Name: 
// Module Name: packages
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

package packages;
  //=================================================
  // TypeDefs declaration
  //=================================================
typedef enum  {FALSE, TRUE} bool;
typedef struct {
  bit   [7:0]   addr;
  bit   [7:0]   data;
  bit           wr;
  bit           rd;
} mem_s; 

typedef struct {
  logic [23:0]  data;
  logic         hs;
  logic         vs;
  logic         de;
} rgb_s; 

typedef struct {
  float i, r;
} Complex;

endpackage
/*
function Complex add(input Complex a, b)
  add.r = a.r + b.r;
  add.i = a.i + b.i;
endfunction
function Complex mul(input Complex a, b)
  mul.r = (a.r * b.r) + (a.i * b.i);
  mul.i = (a.r * b.i) + (a.i * b.r);
endfunction*/
// usage ComplexPkg::Complex cout = ComplexPkg::mul(a, b);
/*
localparam DATA_WIDTH = 32;
function logic [DATA_WIDTH:0] least_one(input logic [DATA_WIDTH-1:0] in);
  begin
  integer i;
    least_one[0] = in[0];
    least_one[DATA_WIDTH] = (in == {DATA_WIDTH{1'b0}});
    for (i=1; i<DATA_WIDTH; i=i+1) begin : U
      least_one[i] = in[i] && (in[i - 1:0] == {i{1'b0}});
    end
  end
endfunction
*/
interface axi3_HP_if (
  input logic ACLK,
  input logic ARESETN
);
  logic [31:0] araddr;
  logic [1:0]  arburst;
  logic [3:0]  arcache;
  logic [5:0]  arid;
  logic [3:0]  arlen;
  logic [1:0]  arlock;
  logic [2:0]  arprot;
  logic [3:0]  arqos;
  logic        arready;
  logic [2:0]  arsize;
  logic        arvalid;
  logic [31:0] awaddr;
  logic [1:0]  awburst;
  logic [3:0]  awcache;
  logic [5:0]  awid;
  logic [3:0]  awlen;
  logic [1:0]  awlock;
  logic [2:0]  awprot;
  logic [3:0]  awqos;
  logic        awready;
  logic [2:0]  awsize;
  logic        awvalid;
  logic [5:0]  bid;
  logic        bready;
  logic [1:0]  bresp;
  logic        bvalid;
  logic [63:0] rdata;
  logic [5:0]  rid;
  logic        rlast;
  logic        rready;
  logic [1:0]  rresp;
  logic        rvalid;
  logic [63:0] wdata;
  logic [5:0]  wid;
  logic        wlast;
  logic        wready;
  logic [7:0]  wstrb;
  logic        wvalid;
  
  modport Master (
    input  arready,
    input  awready,
    input  bid,
    input  bresp,
    input  bvalid,
    input  rdata,
    input  rid,
    input  rlast,
    input  rresp,
    input  rvalid,
    input  wready,

    output araddr,
    output arburst,
    output arcache,
    output arid,
    output arlen,
    output arlock,
    output arprot,
    output arqos,
    output arsize,
    output arvalid,
    output awaddr,
    output awburst,
    output awcache,
    output awid,
    output awlen,
    output awlock,
    output awprot,
    output awqos,
    output awsize,
    output awvalid,
    output bready,
    output rready,
    output wdata,
    output wid,
    output wlast,
    output wstrb,
    output wvalid
  );

  modport Slave (
    output arready,
    output awready,
    output bid,
    output bresp,
    output bvalid,
    output rdata,
    output rid,
    output rlast,
    output rresp,
    output rvalid,
    output wready,

    input  araddr,
    input  arburst,
    input  arcache,
    input  arid,
    input  arlen,
    input  arlock,
    input  arprot,
    input  arqos,
    input  arsize,
    input  arvalid,
    input  awaddr,
    input  awburst,
    input  awcache,
    input  awid,
    input  awlen,
    input  awlock,
    input  awprot,
    input  awqos,
    input  awsize,
    input  awvalid,
    input  bready,
    input  rready,
    input  wdata,
    input  wid,
    input  wlast,
    input  wstrb,
    input  wvalid
  );

endinterface

interface axi3_GP_if (
  input logic ACLK,
  input logic ARESETN
);
  wire [31:0] araddr;
  wire [1:0]  arburst;
  wire [3:0]  arcache;
  wire [11:0] arid;
  wire [3:0]  arlen;
  wire [1:0]  arlock;
  wire [2:0]  arprot;
  wire [3:0]  arqos;
  wire        arready;
  wire [2:0]  arsize;
  wire        arvalid;
  wire [31:0] awaddr;
  wire [1:0]  awburst;
  wire [3:0]  awcache;
  wire [11:0] awid;
  wire [3:0]  awlen;
  wire [1:0]  awlock;
  wire [2:0]  awprot;
  wire [3:0]  awqos;
  wire        awready;
  wire [2:0]  awsize;
  wire        awvalid;
  wire [11:0] bid;
  wire        bready;
  wire [1:0]  bresp;
  wire        bvalid;
  wire [31:0] rdata;
  wire [11:0] rid;
  wire        rlast;
  wire        rready;
  wire [1:0]  rresp;
  wire        rvalid;
  wire [31:0] wdata;
  wire [11:0] wid;
  wire        wlast;
  wire        wready;
  wire [3:0]  wstrb;
  wire        wvalid;
  
  modport Master (
    input  arready,
    input  awready,
    input  bid,
    input  bresp,
    input  bvalid,
    input  rdata,
    input  rid,
    input  rlast,
    input  rresp,
    input  rvalid,
    input  wready,

    output araddr,
    output arburst,
    output arcache,
    output arid,
    output arlen,
    output arlock,
    output arprot,
    output arqos,
    output arsize,
    output arvalid,
    output awaddr,
    output awburst,
    output awcache,
    output awid,
    output awlen,
    output awlock,
    output awprot,
    output awqos,
    output awsize,
    output awvalid,
    output bready,
    output rready,
    output wdata,
    output wid,
    output wlast,
    output wstrb,
    output wvalid
  );

  modport Slave (
    output arready,
    output awready,
    output bid,
    output bresp,
    output bvalid,
    output rdata,
    output rid,
    output rlast,
    output rresp,
    output rvalid,
    output wready,

    input  araddr,
    input  arburst,
    input  arcache,
    input  arid,
    input  arlen,
    input  arlock,
    input  arprot,
    input  arqos,
    input  arsize,
    input  arvalid,
    input  awaddr,
    input  awburst,
    input  awcache,
    input  awid,
    input  awlen,
    input  awlock,
    input  awprot,
    input  awqos,
    input  awsize,
    input  awvalid,
    input  bready,
    input  rready,
    input  wdata,
    input  wid,
    input  wlast,
    input  wstrb,
    input  wvalid
  );

endinterface

interface axi3_CMD_if # (
  parameter integer AXI_ADDR_WIDTH = 32
  )(
  input logic ACLK,
  input logic ARESETN
  );

  logic [AXI_ADDR_WIDTH-1 : 0] axaddr;
  logic [AXI_ADDR_WIDTH-1 : 0] axbyte;
  logic                        axvalid;
  logic                        axready;
  logic                        axdone;

  modport Slave (
    input  axaddr,
    input  axbyte,
    input  axvalid,
    output axready,
    output axdone
  );

  modport Master (
    output axaddr,
    output axbyte,
    output axvalid,
    input  axready,
    input  axdone
  );

endinterface

interface axi4s_if # (
  parameter integer AXIS_TDATA_WIDTH = 32
  )(
  input logic ACLK,
  input logic ARESETN
  );
		
  logic [AXIS_TDATA_WIDTH-1 : 0]     tdata;
  logic [(AXIS_TDATA_WIDTH/8)-1 : 0] tstrb;
  logic [(AXIS_TDATA_WIDTH/8)-1 : 0] tkeep;
  logic [32-1 : 0]                   tdest;
  logic                              tlast;
  logic                              tvalid;
  logic                              tready;

  modport Slave (
    input  tdata,
    input  tstrb,
    input  tkeep,
    input  tdest,
    input  tlast,
    input  tvalid,
    output tready
  );

  modport Master (
    output tdata,
    output tstrb,
    output tkeep,
    output tdest,
    output tlast,
    output tvalid,
    input  tready
  );

endinterface

interface rgb_if # (
  parameter integer PIX_DATA_WIDTH = 8
  )(
  input logic PCLK,
  input logic PRESETN
  );
		
  logic [PIX_DATA_WIDTH*3-1 : 0]     data;
  logic                              hs;
  logic                              vs;
  logic                              de;

  modport Slave (
    input  data,
    input  hs,
    input  vs,
    input  de
  );

  modport Master (
    output data,
    output hs,
    output vs,
    output de
  );

endinterface

interface ycbcr_444_if # (
  parameter integer PIX_DATA_WIDTH = 8
  )(
  input logic PCLK,
  input logic PRESETN
  );
		
  logic [PIX_DATA_WIDTH*3-1 : 0]     data;
  logic                              hs;
  logic                              vs;
  logic                              de;

  modport Slave (
    input  data,
    input  hs,
    input  vs,
    input  de
  );

  modport Master (
    output data,
    output hs,
    output vs,
    output de
  );

endinterface

interface ycbcr_422_if # (
  parameter integer PIX_DATA_WIDTH = 8
  )(
  input logic PCLK,
  input logic PRESETN
  );
		
  logic [PIX_DATA_WIDTH*2-1 : 0]     data;
  logic                              hs;
  logic                              vs;
  logic                              de;

  modport Slave (
    input  data,
    input  hs,
    input  vs,
    input  de
  );

  modport Master (
    output data,
    output hs,
    output vs,
    output de
  );

endinterface

interface fifo_if # (
  parameter integer WR_DATA_WIDTH = 32,
  parameter integer RD_DATA_WIDTH = 32
  );
		
  logic                       wr_clk;
  logic                       rd_clk;
  logic                       wr_rst;
  logic                       rd_rst;
  logic                       wr_en;
  logic                       rd_en;
  logic [WR_DATA_WIDTH-1 : 0] din;
  logic [RD_DATA_WIDTH-1 : 0] dout;
  logic                       full = 0;
  logic                       empty = 1;

  modport Read (
    input  rd_clk,
    input  rd_rst,
    input  rd_en,
    output dout,
    output full,
    output empty
  );

  modport Write (
    input  wr_clk,
    input  wr_rst,
    input  wr_en,
    input  din,
    output full,
    output empty
  );

  modport Slave (
    input  wr_clk,
    input  rd_clk,
    input  wr_rst,
    input  rd_rst,
    input  wr_en,
    input  rd_en,
    input  din,
    output dout,
    output full,
    output empty
  );

  modport Master (
    output wr_clk,
    output rd_clk,
    output wr_rst,
    output rd_rst,
    output wr_en,
    output rd_en,
    output din,
    input  dout,
    input  full,
    input  empty
  );

endinterface

interface sdp_bram_if # (
  parameter integer WR_DATA_WIDTH = 32,
  parameter integer RD_DATA_WIDTH = 32
  );
		
  logic                       clka;
  logic                       ena = 1;
  logic [3 : 0]               wea;
  logic [31 : 0]              addra;
  logic [WR_DATA_WIDTH-1 : 0] dina;
  logic                       clkb;
  logic                       enb = 1;
  logic [31 : 0]              addrb;
  logic [RD_DATA_WIDTH-1 : 0] doutb;

  modport Read (
    input  clkb,
    input  enb,
    input  addrb,
    output doutb
  );

  modport Write (
    input  clka,
    input  ena,
    input  wea,
    input  addra,
    input  dina
  );

  modport Slave (
    input  clka,
    input  ena,
    input  wea,
    input  addra,
    input  dina,
    input  clkb,
    input  enb,
    input  addrb,
    output doutb
  );

  modport Master (
    output clka,
    output ena,
    output wea,
    output addra,
    output dina,
    output clkb,
    output enb,
    output addrb,
    input  doutb
  );

endinterface

interface cpu_if (
  input logic CLK,
  input logic RESET
  );
		
  logic         timeout;
  logic         read;
  logic         write;
  logic  [31:0] write_data;
  logic  [31:2] address;
  logic  [31:0] read_data;
  logic         access_complete = 0;
  logic         invalid_address = 0;
  logic         invalid_access = 0;

  clocking cb_master@(posedge clk);
      default input #1 output #1;
      output read;
      output write;
      output write_data;
      output address;
      input  read_data;
      input  access_complete;
  endclocking

  modport tb_master(clocking cb_master,input clk);

  clocking cb_slave@(posedge clk);
      default input #1 output #1;
      input  read;
      input  write;
      input  write_data;
      input  address;
      output read_data;
      output access_complete;
  endclocking

  modport tb_slave(clocking cb_slave,input clk);

  modport Slave (
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

interface xgmii_if (
  input logic gtx_clk,
  input logic gtx_reset
  );
	
  logic        xgmii_tx_clk;
  logic [63:0] xgmii_txd;
  logic [7:0]  xgmii_txc;
  logic        xgmii_rx_clk;
  logic [63:0] xgmii_rxd;
  logic [7:0]  xgmii_rxc;

  modport Slave (
     input  xgmii_tx_clk,
     input  xgmii_txd,
     input  xgmii_txc,
     output xgmii_rx_clk,
     output xgmii_rxd,
     output xgmii_rxc
  );

  modport Master (
     output xgmii_tx_clk,
     output xgmii_txd,
     output xgmii_txc,
     input  xgmii_rx_clk,
     input  xgmii_rxd,
     input  xgmii_rxc
  );

endinterface

interface gmii_if (
  input logic gtx_clk,
  input logic gtx_reset
  );
		
  logic [7:0] gmii_txd;
  logic       gmii_tx_en;
  logic       gmii_tx_er;
  logic [7:0] gmii_rxd;
  logic       gmii_rx_dv;
  logic       gmii_rx_er;
  logic       clk_enable;
  logic       speedis100;
  logic       speedis10100;
		
  modport Slave (
     input  gmii_txd,
     input  gmii_tx_en,
     input  gmii_tx_er,
     output gmii_rxd,
     output gmii_rx_dv,
     output gmii_rx_er,
     output clk_enable,
     input  speedis100,
     input  speedis10100
  );

  modport Master (
     output gmii_txd,
     output gmii_tx_en,
     output gmii_tx_er,
     input  gmii_rxd,
     input  gmii_rx_dv,
     input  gmii_rx_er,
     input  clk_enable,
     output speedis100,
     output speedis10100
  );

endinterface

interface serial_if #( parameter CH_WIDTH = 0 ) (
  );
		
  logic [CH_WIDTH-1:0] txp;
  logic [CH_WIDTH-1:0] txn;
  logic [CH_WIDTH-1:0] rxp;
  logic [CH_WIDTH-1:0] rxn;
		
  modport Slave (
     input          txp,
     input          txn,
     output         rxp,
     output         rxn
  );

  modport Master (
     output          txp,
     output          txn,
     input           rxp,
     input           rxn
  );

endinterface

interface gt_if (
  );
		
  logic 		      txprbsforceerr;
  logic [2:0]	   loopback;
  logic           txpcsreset;
  logic           txpmareset;
  logic           rxpmareset;
  logic           rxdfelpmreset;
  logic [4:0]	   txprecursor;
  logic [4:0]	   txpostcursor;
  logic [3:0]	   txdiffctrl;
  logic           rxlpmen;
  logic  [1:0]	   txbufstatus;
  logic           txresetdone;
  logic           rxpmaresetdone;
  logic           rxresetdone;
  logic  [2:0]	   rxbufstatus;
  logic           rxprbserr; 
		
  modport Slave (
     output txprbsforceerr,
     output loopback,
     output txpcsreset,
     output txpmareset,
     output rxpmareset,
     output rxdfelpmreset,
     output txprecursor,
     output txpostcursor,
     output txdiffctrl,
     output rxlpmen,
     
     input  txbufstatus,
     input  txresetdone,
     input  rxpmaresetdone,
     input  rxresetdone,
     input  rxbufstatus,
     input  rxprbserr
  );

  modport Master (
     input 	txprbsforceerr,
     input  loopback,
     input  txpcsreset,
     input  txpmareset,
     input  rxpmareset,
     input  rxdfelpmreset,
     input  txprecursor,
     input  txpostcursor,
     input  txdiffctrl,
     input  rxlpmen,
     output txbufstatus,
     output txresetdone,
     output rxpmaresetdone,
     output rxresetdone,
     output rxbufstatus,
     output rxprbserr
  );

endinterface

interface pcspma_csr_if (
  );
		
  logic pma_loopback;
  logic pma_reset;
  logic global_tx_disable = 1'b0;
  logic pcs_loopback;
  logic pcs_reset;
  logic [57:0] test_patt_a_b = 58'd0;
  logic data_patt_sel = 1'b0;
  logic test_patt_sel = 1'b0;
  logic rx_test_patt_en = 1'b0;
  logic tx_test_patt_en = 1'b0;
  logic prbs31_tx_en;
  logic prbs31_rx_en;
  logic set_pma_link_status = 1'b1;
  logic set_pcs_link_status = 1'b1;
  logic clear_pcs_status2 = 1'b0;
  logic clear_test_patt_err_count;
  logic pma_link_status;
  logic rx_sig_det;
  logic pcs_rx_link_status;
  logic pcs_rx_locked;
  logic pcs_hiber;
  logic teng_pcs_rx_link_status;
  logic [279:272] pcs_err_block_count;
  logic [285:280] pcs_ber_count;
  logic pcs_rx_hiber_lh;
  logic pcs_rx_locked_ll;
  logic [303:288] pcs_test_patt_err_count;
		
  modport Slave (
     output pma_loopback,
     output pma_reset,
     output global_tx_disable,
     output pcs_loopback,
     output pcs_reset,
     output test_patt_a_b,
     output data_patt_sel,
     output test_patt_sel,
     output rx_test_patt_en,
     output tx_test_patt_en,
     output prbs31_tx_en,
     output prbs31_rx_en,
     output set_pma_link_status,
     output set_pcs_link_status,
     output clear_pcs_status2,
     output clear_test_patt_err_count,

     input  pma_link_status,
     input  rx_sig_det,
     input  pcs_rx_link_status,
     input  pcs_rx_locked,
     input  pcs_hiber,
     input  teng_pcs_rx_link_status,
     input  pcs_err_block_count,
     input  pcs_ber_count,
     input  pcs_rx_hiber_lh,
     input  pcs_rx_locked_ll,
     input  pcs_test_patt_err_count
  );

  modport Master (
     input  pma_loopback,
     input  pma_reset,
     input  global_tx_disable,
     input  pcs_loopback,
     input  pcs_reset,
     input  test_patt_a_b,
     input  data_patt_sel,
     input  test_patt_sel,
     input  rx_test_patt_en,
     input  tx_test_patt_en,
     input  prbs31_tx_en,
     input  prbs31_rx_en,
     input  set_pma_link_status,
     input  set_pcs_link_status,
     input  clear_pcs_status2,
     input  clear_test_patt_err_count,

     output pma_link_status,
     output rx_sig_det,
     output pcs_rx_link_status,
     output pcs_rx_locked,
     output pcs_hiber,
     output teng_pcs_rx_link_status,
     output pcs_err_block_count,
     output pcs_ber_count,
     output pcs_rx_hiber_lh,
     output pcs_rx_locked_ll,
     output pcs_test_patt_err_count
  );

endinterface

interface sgmii_support_if (
  );
		
  logic [4:0]  configuration_vector;
  logic        an_interrupt;
  logic [15:0] status_vector;
		
   modport Slave (
      output configuration_vector,
      input  an_interrupt,
      input  status_vector
   );

   modport Master (
      input  configuration_vector,
      output an_interrupt,
      output status_vector
   );

endinterface

module sdp_block_ram #(
    parameter MEM_INIT_FILE = "",
    parameter MEM_INIT_VAL  = 1'b0,
    parameter DATA_WIDTH    = 32,
    parameter DATA_DEPTH    = 16
  ) (
    input  logic                          clka,
    input  logic                          wena,
    input  logic [$clog2(DATA_DEPTH)-1:0] addra,
    input  logic [DATA_WIDTH-1:0]         dina,
    output logic [DATA_WIDTH-1:0]         douta,
    
    input  logic                          clkb,
    input  logic [$clog2(DATA_DEPTH)-1:0] addrb,
    output logic [DATA_WIDTH-1:0]         doutb
  );

  (* ram_style = "block" *)
  logic [DATA_WIDTH-1:0] mem [0:DATA_DEPTH-1] = '{default:{DATA_WIDTH{MEM_INIT_VAL}}};

  integer i;
  initial begin
     if (MEM_INIT_FILE != "") begin
        $readmemh(MEM_INIT_FILE, mem);
     end
  end
  
  always_ff @(posedge clka) begin 
    mem[addra] <= (wena) ? dina : mem[addra];
  end

  always_ff @(posedge clka) begin 
    douta <= mem[addra];
  end

  always_ff @(posedge clkb) begin 
    doutb <= mem[addrb];
  end
        
endmodule

module tdp_block_ram #(
    parameter MEM_INIT_FILE = "",
    parameter MEM_INIT_VAL  = 1'b0,
    parameter DATA_WIDTH    = 32,
    parameter DATA_DEPTH    = 16
  ) (
    input  logic                          clka,
    input  logic                          wena,
    input  logic [$clog2(DATA_DEPTH)-1:0] addra,
    input  logic [DATA_WIDTH-1:0]         dina,
    output logic [DATA_WIDTH-1:0]         douta,
    
    input  logic                          clkb,
    input  logic                          wenb,
    input  logic [$clog2(DATA_DEPTH)-1:0] addrb,
    input  logic [DATA_WIDTH-1:0]         dinb,
    output logic [DATA_WIDTH-1:0]         doutb
  );

  (* ram_style = "block" *)
  logic [DATA_WIDTH-1:0] mem [0:DATA_DEPTH-1] = '{default:{DATA_WIDTH{MEM_INIT_VAL}}};

  integer i;
  initial begin
     if (MEM_INIT_FILE != "") begin
        $readmemh(MEM_INIT_FILE, mem);
     end
  end
  
  always_ff @(posedge clka) begin 
    mem[addra] <= (wena) ? dina : mem[addra];
  end

  always_ff @(posedge clka) begin 
    douta <= mem[addra];
  end

  always_ff @(posedge clkb) begin 
    mem[addrb] <= (wenb) ? dinb : mem[addrb];
  end
  
  always_ff @(posedge clkb) begin 
    doutb <= mem[addrb];
  end
        
endmodule

module sdp_rw_cpu_if_bram #(
    parameter MEM_INIT_FILE = "",
    parameter MEM_INIT_VAL  = 1'b0,
    parameter DATA_WIDTH    = 32,
    parameter DATA_DEPTH    = 16
  ) (
    cpu_if.Slave                          cpu_if,
    
    input  logic                          clkb,
    input  logic [$clog2(DATA_DEPTH)-1:0] addrb,
    output logic [DATA_WIDTH-1:0]         doutb
  );
  
  sdp_block_ram #(
      .MEM_INIT_FILE ( MEM_INIT_FILE     ) ,
      .MEM_INIT_VAL  ( MEM_INIT_VAL      ) ,
      .DATA_WIDTH    ( DATA_WIDTH        ) ,
      .DATA_DEPTH    ( DATA_DEPTH        )
    ) sdp_block_ram_inst (
      .clka          ( cpu_if.CLK        ) ,
      .wena          ( cpu_if.write      ) ,
      .addra         ( cpu_if.address    ) ,
      .dina          ( cpu_if.write_data ) ,
      .douta         ( cpu_if.read_data  ) ,
      
      .clkb          ( clkb              ) ,
      .addrb         ( addrb             ) ,
      .doutb         ( doutb             )
    );
    
    always_ff @ (posedge cpu_if.CLK) begin
      cpu_if.access_complete <= cpu_if.read | cpu_if.write;
    end
  
endmodule

module sdp_ro_cpu_if_bram #(
    parameter MEM_INIT_FILE = "",
    parameter MEM_INIT_VAL  = 1'b0,
    parameter DATA_WIDTH    = 32,
    parameter DATA_DEPTH    = 16
  ) (
    cpu_if.Slave                          cpu_if,
    
    input  logic                          clka,
    input  logic                          wena,
    input  logic [$clog2(DATA_DEPTH)-1:0] addra,
    input  logic [DATA_WIDTH-1:0]         dina,
    output logic [DATA_WIDTH-1:0]         douta
  );
  
  sdp_block_ram #(
      .MEM_INIT_FILE ( MEM_INIT_FILE     ) ,
      .MEM_INIT_VAL  ( MEM_INIT_VAL      ) ,
      .DATA_WIDTH    ( DATA_WIDTH        ) ,
      .DATA_DEPTH    ( DATA_DEPTH        )
    ) sdp_block_ram_inst (
      .clka          ( clka              ) ,
      .wena          ( clka              ) ,
      .addra         ( addra             ) ,
      .dina          ( dina              ) ,
      .douta         ( douta             ) ,
      
      .clkb          ( cpu_if.CLK        ) ,
      .addrb         ( cpu_if.address    ) ,
      .doutb         ( cpu_if.read_data  )
    );
    
    always_ff @ (posedge cpu_if.CLK) begin
      cpu_if.access_complete <= cpu_if.read | cpu_if.write;
    end
  
endmodule

module counter #(
    parameter DATA_WIDTH = 32
) (
    input  logic                  reset,
    input  logic                  clk,
    input  logic                  clr,
    input  logic                  load_cntr,
    input  logic                  inc_cntr,
    input  logic                  dcr_cntr,
    input  logic [DATA_WIDTH-1:0] count_i,
    output logic [DATA_WIDTH-1:0] count_o
);

(* use_dsp48 = "yes" *) logic [DATA_WIDTH-1:0] counter;
assign count_o = counter;

always_ff @ (posedge clk) begin
    if (reset | clr) begin
        counter <= {DATA_WIDTH{1'b0}};
    end else if (load_cntr) begin
        counter <= count_i;
    end else if (inc_cntr) begin
        counter <= counter + 1;
    end else if (dcr_cntr) begin
        counter <= counter - 1;
    end else begin
        counter <= counter;
    end
end

endmodule

module block_ram #(
    parameter DATA_WIDTH = 32,
    parameter DATA_DEPTH = 512
) (
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          wen,
    input  logic [$clog2(DATA_DEPTH)-1:0] addr,
    input  logic [DATA_WIDTH-1:0]         din,
    output logic [DATA_WIDTH-1:0]         dout
);

(* ram_style = "block" *)logic [DATA_WIDTH-1:0] ram [0:DATA_DEPTH-1];

always_ff @(posedge clk) begin 
    ram[addr] <= (wen) ? din : ram[addr];
end

always_ff @(posedge clk) begin 
    dout <= ram[addr];
end

endmodule
