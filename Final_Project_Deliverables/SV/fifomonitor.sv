import fifo_pkg::*;

class monitor;

int w_count;
int trans_count_write;
int trans_count_read;
int r_count;

virtual intf vif_ff;
mailbox mon2scb_write;
mailbox mon2scb_read;
 
  
function new(virtual intf vif_ff,mailbox mon2scb_read, mailbox mon2scb_write);
  this.vif_ff = vif_ff;
  this.mon2scb_read = mon2scb_read;
  this.mon2scb_write = mon2scb_write;
endfunction


task mon_write;
     
  transaction_write trans_write;
  trans_write = new(); 	  
  
  trans_write.winc = vif_ff.winc;
  trans_write.wData = vif_ff.wData;
 	if (vif_ff.winc==1) begin
	 $display ("[TB MONITOR]\t Monitor winc = %0h \t wData = %0h \t w_count=%0d", trans_write.winc, trans_write.wData, w_count+1);

   		mon2scb_write.put(trans_write);
		w_count=w_count +1;
		 
		end
endtask

 
task mon_read;

   transaction_read trans_read;
   trans_read = new(); 	  
  @(posedge vif_ff.rclk);

   trans_read.rinc = vif_ff.rinc;
   trans_read.rData = vif_ff.rData;
  trans_read.rEmpty = vif_ff.rEmpty;
     
   	if (vif_ff.rinc==1)begin
      $display ("[TB MONITOR] \t Monitor rinc = %0h \t rData = %0h \t rcount=%0d", trans_read.rinc, trans_read.rData, r_count+1);
      	
      mon2scb_read.put(trans_read);
		r_count= r_count +1;
		end
endtask
    
    
task main();
bit write_complete_flag = 0;
  transaction_read trans_read;
  transaction_write trans_write;
   trans_read = new(); 
   trans_write = new();
 	
  
    fork
        begin : write_monitor
            forever @(posedge vif_ff.wclk) begin
                @(posedge vif_ff.wclk)
              	//$display("monwrite %h", w_count);
                mon_write();
            end
        end

        begin : write_completion
          @(posedge vif_ff.wclk)
            wait (w_count == trans_count_write);
            //$display("waitcondition"); 
            disable write_monitor; 
          	write_complete_flag = 1;
        end
    join_any

 if (write_complete_flag == 1) begin
        fork
            begin : read_monitor
              forever @(posedge vif_ff.rclk) begin 
                    mon_read();
                //$display("monread %h", r_count);
                end
            end

            begin : read_completion
              @(posedge vif_ff.rclk)
              //$display("%h trans_count read",trans_count_read);  
              wait (r_count == trans_count_read);
              //$display("read waitcondition");
              disable read_monitor;
            end
          
        join_any
 end
  //update full and empty after everything is done and we clock once
  @(posedge vif_ff.rclk);
  trans_read.rEmpty = vif_ff.rEmpty;
  mon2scb_read.put(trans_read.rEmpty);
  
  @(posedge vif_ff.wclk);
  trans_write.wFull = vif_ff.wFull;
  mon2scb_write.put(trans_write.wFull);
endtask

endclass
  
