import fifo_pkg::*;

class scoreboard;
logic [7:0] hold_rData[$];
logic [7:0] verif_rData;
logic detect_rEmpty, detect_wFull;
logic [7:0] hold_wData[$];
logic [7:0] verif_wData;
int trans_count_write =0;
int trans_count_read=0;
int w_count=0;
int r_count=0;
 
mailbox mon2scb_write;
mailbox mon2scb_read;
   
function new(mailbox mon2scb_write, mailbox mon2scb_read);
   this.mon2scb_write = mon2scb_write;
   this.mon2scb_read = mon2scb_read;
endfunction
 
task score_write;
	transaction_write trans_w; 
	trans_w = new(); 
	mon2scb_write.get(trans_w);
   $display("[TB SCOREBOARD]\t Scoreboard write enable = %0h \t wData = %0h", trans_w.winc, trans_w.wdata);

	hold_wData.push_back(trans_w.wdata);
	$display("[TB SCOREBOARD] \t Scoreboard Data pushed back into FIFO: wData = %0h \t", trans_w.wdata);
	w_count++; 
	if (trans_w.wfull == 1)
	detect_wFull = 1;  
endtask

task score_read;
    transaction_read trans_r;
    trans_r = new(); 
    mon2scb_read.get(trans_r);  
  	hold_rData.push_back(trans_r.rdata);
	$display("[TB SCOREBOARD] \t Scoreboard read push: rData = %0h \t", trans_r.rdata);
    r_count++; 
endtask
  
task main();
    repeat (trans_count_write) 
	begin
        wait (mon2scb_write.num() > 0);
        score_write();
    end

    repeat (trans_count_read)
	begin
        wait (mon2scb_read.num() > 0);
        score_read();
    end
endtask


task check();
transaction_read trans_r;
transaction_write trans_w;
trans_r = new();
trans_w = new(); 
mon2scb_read.get(trans_r.rempty);
mon2scb_write.get(trans_w.wfull);

for (integer i=0; i < hold_wData.size; i++) begin
 verif_wData = hold_wData[i];
 verif_rData = hold_rData[i];


 $display("[TB SCOREBOARD] Expected written data = %h, Actual read data = %h", verif_wData, verif_rData);
  if (verif_wData != verif_rData)
	$error("[TB SCOREBOARD] Scoreboard check failed :: Expected written data = %0h, Actual read data = %0h", verif_wData,verif_rData);
end

if (trans_w.wfull == 1)
     $display("FIFO Full");
   else $display("FIFO is not Full");
   
   if (trans_r.rempty == 1)
     $display("FIFO Empty");
   else $display("FIFO is not Empty");
   
endtask 


endclass
