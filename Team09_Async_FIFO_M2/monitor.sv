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
  trans_write.wdata = vif_ff.wdata;
 	if (vif_ff.winc ==1) 
	begin
   		mon2scb_write.put(trans_write);
		w_count = w_count + 1;		 
	end
endtask

 
task mon_read;
   transaction_read trans_read;
   trans_read = new(); 	  
  @(posedge vif_ff.rclk);
   trans_read.rinc = vif_ff.rinc;
   trans_read.rdata = vif_ff.rdata;
   trans_read.rempty = vif_ff.rempty; 
   	if (vif_ff.rinc==1)
	begin      	
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
		forever @(posedge vif_ff.wclk) 
		begin
			@(posedge vif_ff.wclk)
			mon_write();
		end
	end

	begin : write_completion
	  @(posedge vif_ff.wclk)
		wait (w_count == trans_count_write);
		disable write_monitor; 
		write_complete_flag = 1;
	end
    join_any

 if (write_complete_flag == 1) begin
	fork
	begin : read_monitor
	  forever @(posedge vif_ff.rclk) begin 
			mon_read();
		end
	end

	begin : read_completion
	  @(posedge vif_ff.rclk)
	  wait (r_count == trans_count_read);
	  disable read_monitor;
	end  
	join_any
 end
  @(posedge vif_ff.rclk);
  trans_read.rempty = vif_ff.rempty;
  mon2scb_read.put(trans_read.rempty);
  
  @(posedge vif_ff.wclk);
  trans_write.wfull = vif_ff.wfull;
  mon2scb_write.put(trans_write.wfull);
endtask

endclass
  
