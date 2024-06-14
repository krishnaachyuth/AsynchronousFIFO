/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

module fifo_mem #(parameter Data_Width=8,Addr_Width=9,Depth=512)(wclk,rclk,rrst,wrst,winc,rinc,full,empty,data_in,wr_addr,rd_addr,data_out);

input bit wclk,rclk,rrst,wrst,winc,rinc,full,empty;
  input logic [Addr_Width:0]  wr_addr, rd_addr;

  input logic [Data_Width-1:0] data_in;
  output logic [Data_Width-1:0]data_out;

  logic [Data_Width-1:0] fifo [0: Depth-1];

always_ff@(posedge wclk)
begin
  if(winc & !full)
begin
	/**** WRITE ****/
  fifo[wr_addr[Addr_Width-1:0]]<=data_in; 
end
end
  //assign data_out=fifo[rd_addr[Addr_Width-1:0]]; /**READ OPERATION**/
  assign data_out = 1; //error injection
endmodule
