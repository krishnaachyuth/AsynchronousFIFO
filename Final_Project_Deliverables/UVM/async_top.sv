/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

module async_top #(parameter Depth=512,Data_Width=8,Addr_Width=9) (uvm_fifo intf );
/***** Instantiation of sub modules *****/

/***** FLOP SYNCRONISERS ****/
  wr_2_rd_sync #(Addr_Width) w2rsync_inst(.rclk(intf.rclk),.rrst(intf.rrst),.wptr(intf.wptr),.wptr_s(intf.wptr_s));
  rd_2_wr_sync #(Addr_Width) r2wsync_inst(.wclk(intf.wclk),.wrst(intf.wrst),.rptr(intf.rptr),.rptr_s(intf.rptr_s));

/***** WRITE POINTER *****/
  write_ptr #(Addr_Width) write_ptr_inst (.wclk(intf.wclk),.wrst(intf.wrst),.winc(intf.winc),.rptr_s(intf.rptr_s),.wr_addr(intf.wr_addr),.wptr(intf.wptr),.full(intf.full),.half_full(intf.half_full));

/******* READ POINTER *****/
  read_ptr #(Addr_Width) read_ptr_inst (.rclk(intf.rclk),.rrst(intf.rrst),.rinc(intf.rinc),.wptr_s(intf.wptr_s),.rd_addr(intf.rd_addr),.rptr(intf.rptr),.empty(intf.empty),.half_empty(intf.half_empty));

/******* FIFO MEMORY ********/
  fifo_mem #(Data_Width,Addr_Width,Depth) fifo_mem_inst (.wclk(intf.wclk),.rclk(intf.rclk),.rrst(intf.rrst),.wrst(intf.wrst),.winc(intf.winc),.rinc(intf.rinc),.full(intf.full),.empty(intf.empty),.data_in(intf.data_in),.wr_addr(intf.wr_addr),.rd_addr(intf.rd_addr),.data_out(intf.data_out));

endmodule
