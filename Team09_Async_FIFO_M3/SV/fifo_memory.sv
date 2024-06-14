
// **************FIFO memory*****************************

module fifomem(
  winc, wfull, wclk,
   waddr, raddr,
   wdata,
   rdata , rinc , rempty , rclk
);
parameter DATASIZE = 8 ; // Memory data word width
parameter ADDRSIZE = 32 ; // Number of mem address bits
localparam DEPTH = 2**ADDRSIZE;//2*addsize

  input   winc, wfull, wclk , rinc , rempty , rclk;
  input   [ADDRSIZE-1:0] waddr, raddr;
  input   [DATASIZE-1:0] wdata;
  output logic [DATASIZE-1:0] rdata;

logic [DATASIZE-1:0] mem [0:DEPTH-1];

always_ff @(posedge rclk)
begin
	if (rinc & ~rempty)
		rdata = mem[raddr];
end

always_ff @(posedge wclk)
begin
    if (winc & ~wfull)
      mem[waddr] <= wdata;
end

endmodule