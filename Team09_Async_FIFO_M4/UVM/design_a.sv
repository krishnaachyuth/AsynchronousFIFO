//
// Top level wrapper
//
module FIFO
#(
  parameter DSIZE = 8,
  parameter ASIZE = 8 //size 256 for fifo depth
 )
(
  input  logic winc, wclk, wrst,
  input  logic rinc, rclk, rrst,
  input  logic [DSIZE-1:0] wData,

  output logic [DSIZE-1:0] rData,
  output logic wFull,
  output logic rEmpty
);

  logic [ASIZE-1:0] waddr, raddr;
  logic [ASIZE:0] wptr, rptr, rptr_s, wptr_s;

  sync_r2w sync_r2w (.*);
  sync_w2r sync_w2r (.*);
  fifomem #(DSIZE, ASIZE) fifomem (.*);
  rptr_empty #(ASIZE) rptr_empty (.*);
  wptr_full #(ASIZE) wptr_full (.*);

endmodule


//
// FIFO memory
//
module fifomem
#(
  parameter DATASIZE = 8, // Memory data word width
  parameter ADDRSIZE = 8  // Number of mem address bits
)
(
  input  logic winc, wFull, wclk, rinc, rEmpty, rclk,
  input  logic [ADDRSIZE-1:0] waddr, raddr,
  input  logic [DATASIZE-1:0] wData,
  output logic [DATASIZE-1:0] rData
);

  // memory model
  localparam DEPTH = 1<<ADDRSIZE;

  logic [DATASIZE-1:0] mem [0:DEPTH-1];

  always @(posedge rclk) //write if not empty and read increment is high
    if (rinc && !rEmpty)
      rData = mem[raddr];

  always @(posedge wclk)
    if (winc && !wFull)
      mem[waddr] <= wData;
     // mem[waddr] <= 1; use this for error injection

endmodule


//
// Read pointer to write clock synchronizer
//
module sync_r2w
#(
  parameter ADDRSIZE = 8
)
(
  input  logic wclk, wrst,
  input  logic [ADDRSIZE:0] rptr,
  output logic [ADDRSIZE:0] rptr_s
);

  logic [ADDRSIZE:0] wq1_rptr;

  always_ff @(posedge wclk or negedge wrst) //2 cycle sync
    if (!wrst) {rptr_s,wq1_rptr} <= 0;
    else {rptr_s,wq1_rptr} <= {wq1_rptr,rptr};

endmodule


//
// Write pointer to read clock synchronizer
//
module sync_w2r
#(
  parameter ADDRSIZE = 8
)
(
  input  logic rclk, rrst,
  input  logic [ADDRSIZE:0] wptr,
  output logic [ADDRSIZE:0] wptr_s
);

  logic [ADDRSIZE:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst) //2 cycle sync
    if (!rrst)
      {wptr_s,rq1_wptr} <= 0;
    else
      {wptr_s,rq1_wptr} <= {rq1_wptr,wptr};

endmodule


//
// Read pointer and empty generation
//
module rptr_empty
#(
  parameter ADDRSIZE = 8
)
(
  input  logic rinc, rclk, rrst,
  input  logic [ADDRSIZE :0] wptr_s,
  output logic rEmpty,
  output logic [ADDRSIZE-1:0] raddr,
  output logic [ADDRSIZE :0] rptr
);

  logic [ADDRSIZE:0] rbin;
  logic [ADDRSIZE:0] rgraynext, rbinnext;

  always_ff @(posedge rclk or negedge rrst)
    if (!rrst)
      {rbin, rptr} <= '0;
    else
      {rbin, rptr} <= {rbin + (rinc & ~rEmpty), rgraynext};

  // Memory read-address pointer
  assign raddr = rbin[ADDRSIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rEmpty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  
  // FIFO empty when the next rptr == synchronized wptr or on reset
  
  assign rEmpty_val = (rgraynext == wptr_s);

  always_ff @(posedge rclk or negedge rrst)
    if (!rrst)
      rEmpty <= 1'b1;
    else
      rEmpty <= rEmpty_val;

endmodule


//
// Write pointer and full generation
//
module wptr_full
#(
  parameter ADDRSIZE = 8
)
(
  input  logic winc, wclk, wrst,
  input  logic [ADDRSIZE :0] rptr_s,
  output logic wFull,
  output logic [ADDRSIZE-1:0] waddr,
  output logic [ADDRSIZE :0] wptr
);

  logic [ADDRSIZE:0] wbin;
  logic [ADDRSIZE:0] wgraynext, wbinnext;

  
  always_ff @(posedge wclk or negedge wrst)
    if (!wrst)
      {wbin, wptr} <= '0;
    else
      {wbin, wptr} <= {wbin + (winc & ~wFull), wgraynext};

  // Memory write-address pointer (okay to use binary to address memory)
  assign waddr = wbin[ADDRSIZE-1:0];
  assign wbinnext = wbin + (winc & ~wFull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;
 //Full when grey pointer is not equal to MSB and MSB-1 and is equal to the rest of the synchronized read pointer
  assign wFull_val = (wgraynext=={~rptr_s[ADDRSIZE:ADDRSIZE-1], rptr_s[ADDRSIZE-2:0]});
  

  always_ff @(posedge wclk or negedge wrst)
    if (!wrst)
      wFull <= 1'b0;
    else
      wFull <= wFull_val; 

endmodule

