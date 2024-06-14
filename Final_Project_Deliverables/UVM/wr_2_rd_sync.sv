/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

module wr_2_rd_sync #(parameter  Addr_Width=9)(rclk,rrst,wptr,wptr_s);

input bit rclk,rrst;
 input [Addr_Width:0]wptr;
 output logic [Addr_Width:0]wptr_s;

 logic [Addr_Width:0] wr_ptr1;
 always_ff@(posedge rclk) begin
    if(!rrst) begin
       wr_ptr1 <= 0;
      wptr_s <= 0;
    end
    else begin
      wr_ptr1 <= wptr;
      wptr_s <= wr_ptr1;
    end
  end
endmodule
