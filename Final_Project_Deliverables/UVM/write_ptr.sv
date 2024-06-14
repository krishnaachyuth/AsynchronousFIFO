/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

module write_ptr #(parameter Addr_Width=9)(wclk,wrst,winc,rptr_s,wr_addr,wptr,full,half_full);

	input bit wclk, wrst, winc;
	input logic [Addr_Width:0] rptr_s;
	output bit full;
	output logic [Addr_Width:0] wr_addr, wptr;
	output logic half_full;
	logic wr_full;
	logic half_full_val;
	logic [Addr_Width:0]wr_addr_next; 
	logic [Addr_Width:0]wr_ptr_next;

	assign wr_addr_next= wr_addr + (winc & !full);
	assign wr_ptr_next= (wr_addr_next>>1)^wr_addr_next; 

	always_ff@(posedge wclk or negedge wrst)
begin
	if(!wrst)
		/*** setting default values on reset ***/
		begin
		wr_addr<='0; 
		wptr<='0;
		end 
	else begin
		wr_addr<=wr_addr_next;/*increment binary write pointer*/
		wptr<=wr_ptr_next;/*increment gray write pointer*/
	end
end

	always_ff@(posedge wclk or negedge wrst)
begin
	if(!wrst)
	full<=0;
else
	full<=wr_full;
end

assign wr_full= (wr_ptr_next=={~rptr_s[Addr_Width:Addr_Width-1],rptr_s[Addr_Width-2:0]});/*full condition check*/

/*** Half full evaluation **/
assign half_full_val = 	(wr_ptr_next - rptr_s) == (2**(Addr_Width-1));

	always_ff@(posedge wclk or negedge wrst)
begin
	if(!wrst)
		half_full <= 0;
	else 
		half_full <= half_full_val;
end
endmodule















 
