/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

module read_ptr #(parameter Addr_Width=9)(rclk,rrst,rinc,wptr_s,rd_addr,rptr,empty,half_empty);

	input bit rclk,rrst, rinc;
	input logic [Addr_Width:0]wptr_s;
	output bit empty;
	output logic [Addr_Width:0]rd_addr,rptr;
	output logic half_empty;
	

 	logic rd_empty;
	logic half_empty_val;
	logic [Addr_Width:0] rd_addr_next;
	logic [Addr_Width:0] rd_ptr_next;


	assign rd_addr_next= rd_addr + (rinc & !empty);
	assign rd_ptr_next=(rd_addr_next>>1)^rd_addr_next; /*Binary to Gray conversion*/
	assign rd_empty= (wptr_s == rd_ptr_next); /* empty check */ 

	always_ff@(posedge rclk or negedge rrst)
begin
	if(!rrst)
		begin
		rd_addr<=0; 
		rptr<=0;
		end 
	else begin
		rd_addr<=rd_addr_next;/* increment binary read pointer value */
		rptr<=rd_ptr_next;/* Increment gray read pointer */
	end
end

	always_ff@(posedge rclk or negedge rrst)
begin
if(!rrst)
	empty<=1;
else
	empty<=rd_empty;
	
end

assign half_empty_val=(wptr_s - rd_ptr_next) < (2**(Addr_Width-1)); /* half empty condition check */
	
always_ff@(posedge rclk or negedge rrst)
begin
	if(!rrst)
		half_empty <= 1'b1;
	else 
		half_empty <= half_empty_val;
end
endmodule












 
