
/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										                            */		
/* Authors : Achyuth Krishna Chepuri                                  */
/* 			     Sai Sri Harsha Atmakuri                                  */
/*			     Sathwik Reddy Madireddy                                  */ 
/*           Amrutha Regalla                                          */
/**********************************************************************/

module fifomem(
  winc, wfull, wclk,
   waddr, raddr,
   wdata,
   rdata
);
parameter DATASIZE = 8 ; // Memory data word width
parameter ADDRSIZE = 32 ; // Number of mem address bits
localparam DEPTH = 2**ADDRSIZE;//2*addsize

  input   winc, wfull, wclk;
  input   [ADDRSIZE-1:0] waddr, raddr;
  input   [DATASIZE-1:0] wdata;
  output  [DATASIZE-1:0] rdata;

logic [DATASIZE-1:0] mem [0:DEPTH-1];

assign rdata = mem[raddr];

always_ff @(posedge wclk)
begin
    if (winc & ~wfull)
      mem[waddr] <= wdata;
end

endmodule