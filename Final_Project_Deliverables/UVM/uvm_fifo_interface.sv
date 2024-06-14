/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

interface uvm_fifo(input bit wclk, rclk, wrst, rrst);
parameter Depth=512, Data_Width=8, Addr_Width=9;
logic winc, rinc;
logic [Addr_Width:0] rptr_s, wptr_s, wr_addr, wptr,rd_addr, rptr;
bit full, empty;
logic [Data_Width-1:0] data_in,data_out;
logic  [Data_Width-1:0] wr_data_q[$],rd_data;
logic half_empty;
logic half_full;

/********** assertions *********/

assert property (@(posedge rclk)
 disable iff (!rrst)
 (rptr == wptr) |-> empty
) else $error("FIFO empty signal error at time %t", $time);


assert property (@(posedge wclk)
disable iff (!wrst)
  (wptr + 1 == rptr) |=> full
) else $error("FIFO full signal error at time %t", $time);
  
  
 assert property (@(posedge wclk)
disable iff (!wrst)
                  winc |-> !($isunknown(data_in))
) else $error("FIFO data_in signal error at time %t", $time);
   
  
assert property (@(posedge rclk)
 disable iff (!rrst)
 rinc |-> !($isunknown(data_out))
 ) else $error("FIFO data_out signal error at time %t", $time);

assert property (@(posedge wclk)
                 disable iff (!wrst)
                 (!wrst |-> (wptr == 0))
) else $error("Write pointer reset error at time %t", $time);

  assert property (@(posedge rclk)
                   disable iff (!rrst)
                   (!rrst |-> (rptr == 0))
) else $error("Write pointer reset error at time %t", $time);
endinterface 
