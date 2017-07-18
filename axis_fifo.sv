////////////////////////////////////////////////////////////////////////////////
//
// Description: The top -level FIFO module is a parameterized FIFO design with all sub-blocks 
//              instantiated using the recommended practice of doing named port connections.
// Reference  : Simulation and Synthesis Techniques for Asynchronous FIFO Design 
//              Clifford E. Cummings, Sunburst Design, Inc. 
//              cliffc@sunburst-design.com
//
////////////////////////////////////////////////////////////////////////////////
module axis_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_DEPTH = 4
) (
    axi4s_if.Slave   s,
    axi4s_if.Master  m
);

wire [DATA_WIDTH+DATA_WIDTH/8+1-1:0] m_tdata_int;
wire s_full;
wire m_empty;

fifo #(
    .DSIZE  ( DATA_WIDTH ) ,
    .ASIZE  ( ADDR_DEPTH )
) fifo (
    .wfull  ( s_full ) ,
    .wdata  ( {s.tlast, s.tkeep, s.tdata} ) ,
    .winc   ( s.tvalid & s.tready ) , 
    .wclk   ( s.aclk ) , 
    .wrst_n ( s.areset_n ) ,
    .rempty ( m.empty ) ,
    .rdata  ( m_tdata_int ) ,
    .rinc   ( m.tvalid & m.tready ) , 
    .rclk   ( m.aclk ) , 
    .rrst_n ( m.areset_n )
);

assign s.tready = ~s_full; 
assign m.tvalid = ~m_empty;
assign m.tdata  = m_tdata_int[DATA_WIDTH-1:0];
assign m.tkeep  = m_tdata_int[DATA_WIDTH+DATA_WIDTH/8-1:DATA_WIDTH];
assign m.tlast  = m_tdata_int[DATA_WIDTH+DATA_WIDTH/8];

endmodule
////////////////////////////////////////////////////////////////////////////////
// FIFO top-level module
////////////////////////////////////////////////////////////////////////////////
module fifo #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
) (
    output logic [DSIZE-1:0] rdata,
    output logic             wfull,
    output logic             rempty,
    input  logic [DSIZE-1:0] wdata,
    input  logic             winc, wclk, wrst_n,
    input  logic             rinc, rclk, rrst_n
);

logic [ASIZE-1:0] waddr, raddr;
logic [ASIZE:0]   wptr, rptr, wq2_rptr, rq2_wptr;

sync_r2w sync_r2w ( .wq2_rptr(wq2_rptr), .rptr(rptr),
    .wclk(wclk), .wrst_n(wrst_n) );

sync_w2r sync_w2r ( .rq2_wptr(rq2_wptr), .wptr(wptr),
    .rclk(rclk), .rrst_n(rrst_n) );

fifomem #(DSIZE, ASIZE) fifomem (
    .rdata(rdata), .wdata(wdata), .waddr(waddr), 
    .raddr(raddr), .wclken(winc), .wfull(wfull),
    .wclk(wclk) );

rptr_empty #(ASIZE) rptr_empty (
    .rempty(rempty), .raddr(raddr), .rptr(rptr), 
    .rq2_wptr(rq2_wptr), .rinc(rinc), .rclk(rclk), 
    .rrst_n(rrst_n) );

wptr_full #(ASIZE) wptr_full (
    .wfull(wfull), .waddr(waddr), .wptr(wptr), 
    .wq2_rptr(wq2_rptr), .winc(winc),  .wclk(wclk),
    .wrst_n(wrst_n) );

endmodule
////////////////////////////////////////////////////////////////////////////////
// FIFO memory buffer
////////////////////////////////////////////////////////////////////////////////
module fifomem #(
    parameter  DATASIZE = 8,
    parameter  ADDRSIZE = 4
) (
    output logic [DATASIZE-1:0] rdata,
    input  logic [DATASIZE-1:0] wdata,
    input  logic [ADDRSIZE-1:0] waddr, raddr,
    input  logic                wclken, wfull, wclk
);
`ifdef VENDORRAM
    // instantiation of a vendor's dual-port RAM
    vendor_ram mem (.dout(rdata), .din(wdata),
        .waddr(waddr), .raddr(raddr),
        .wclken(wclken), .wclken_n(wfull), .clk(wclk)
    );
`else
    // RTL Verilog memory model
    localparam DEPTH = 1<<ADDRSIZE;
    logic [DATASIZE-1:0] mem [0:DEPTH-1];

    assign rdata = mem[raddr];

    always_ff @(posedge wclk) begin
        if (wclken && !wfull) begin
            mem[waddr] <= wdata;
        end
    end
`endif
endmodule
////////////////////////////////////////////////////////////////////////////////
// Read-domain to write-domain synchronizer
////////////////////////////////////////////////////////////////////////////////
module sync_r2w #( parameter ADDRSIZE = 4 ) (
    output logic [ADDRSIZE:0] wq2_rptr,
    input  logic [ADDRSIZE:0] rptr,
    input  logic              wclk, wrst_n
);

logic [ADDRSIZE:0] wq1_rptr;

always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
        {wq2_rptr,wq1_rptr} <= 0;
    end else begin
        {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
    end
end

endmodule
////////////////////////////////////////////////////////////////////////////////
// Write-domain to read-domain synchronizer
////////////////////////////////////////////////////////////////////////////////
module sync_w2r #( parameter ADDRSIZE = 4 ) (
    output logic [ADDRSIZE:0] rq2_wptr,
    input  logic [ADDRSIZE:0] wptr,
    input  logic              rclk, rrst_n
);

logic [ADDRSIZE:0] rq1_wptr;

always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
        {rq2_wptr,rq1_wptr} <= 0;
    end else begin
        {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
    end
end

endmodule
////////////////////////////////////////////////////////////////////////////////
// Read pointer & empty generation logic
////////////////////////////////////////////////////////////////////////////////
module rptr_empty #( parameter ADDRSIZE = 4 ) (
    output logic                rempty,
    output logic [ADDRSIZE-1:0] raddr,
    output logic [ADDRSIZE  :0] rptr,
    input  logic [ADDRSIZE  :0] rq2_wptr,
    input  logic                rinc, rclk, rrst_n
);

logic [ADDRSIZE:0] rbin;
logic [ADDRSIZE:0] rgraynext, rbinnext;
//-------------------
// GRAYSTYLE2 pointer
//-------------------
always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
        {rbin, rptr} <= 0;
    end else begin
        {rbin, rptr} <= {rbinnext, rgraynext};
    end
end
// Memory read-address pointer (okay to use binary to address memory)
assign raddr     = rbin[ADDRSIZE-1:0];
assign rbinnext  = rbin + (rinc & ~rempty);
assign rgraynext = (rbinnext>>1) ^ rbinnext;
//---------------------------------------------------------------
// FIFO empty when the next rptr == synchronized wptr or on reset
//---------------------------------------------------------------
assign rempty_val = (rgraynext == rq2_wptr);

always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
        rempty <= 1'b1;
    end else begin        
        rempty <= rempty_val;
    end
end

endmodule
////////////////////////////////////////////////////////////////////////////////
// Write pointer & full generation logic
////////////////////////////////////////////////////////////////////////////////
module wptr_full  #( parameter ADDRSIZE = 4 ) (
    output logic                wfull,
    output logic [ADDRSIZE-1:0] waddr,
    output logic [ADDRSIZE  :0] wptr,
    input  logic [ADDRSIZE  :0] wq2_rptr,
    input  logic                winc, wclk, wrst_n
);

logic [ADDRSIZE:0] wbin;
logic [ADDRSIZE:0] wgraynext, wbinnext;
// GRAYSTYLE2 pointer
always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
        {wbin, wptr} <= 0;
    end else begin
        {wbin, wptr} <= {wbinnext, wgraynext};
    end
end
// Memory write-address pointer (okay to use binary to address memory)
assign waddr = wbin[ADDRSIZE-1:0];
assign wbinnext  = wbin + (winc & ~wfull);
assign wgraynext = (wbinnext>>1) ^ wbinnext;
//------------------------------------------------------------------
// Simplified version of the three necessary full-tests:
// assign wfull_val=((wgnext[ADDRSIZE]    !=wq2_rptr[ADDRSIZE]  ) &&
//                   (wgnext[ADDRSIZE-1]  !=wq2_rptr[ADDRSIZE-1]) &&
//                   (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
//------------------------------------------------------------------
assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

always_ff @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin 
        wfull  <= 1'b0;
    end else begin
        wfull  <= wfull_val;
    end
end

endmodule
