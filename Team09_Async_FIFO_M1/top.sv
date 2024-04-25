module async_fifo1(
  winc, wclk, wrst_n,
  rinc, rclk, rrst_n,
  wdata,

  rdata,
  wfull,
  rempty
);
parameter DATASIZE = 8;
parameter ADDRSIZE = 4;
input   winc, wclk, wrst_n;
input   rinc, rclk, rrst_n;
input   [DATASIZE-1:0] wdata;
output  [DATASIZE-1:0] rdata;
output  wfull;
output  rempty;

wire [ADDRSIZE-1:0] waddr, raddr;
wire [ADDRSIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

sync_r2w #(ADDRSIZE)sync_r2w (.*);
sync_w2r #(ADDRSIZE) sync_w2r (.*);
fifomem #(DATASIZE, ADDRSIZE) fifomem (.*);
rptr_empty #(ADDRSIZE) rptr_empty (.*);
wptr_full #(ADDRSIZE) wptr_full (.*);

endmodule