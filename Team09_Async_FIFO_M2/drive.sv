import fifo_pkg::*;

class driver;
int trans_count_read;
int trans_count_write;
 
virtual intf intf_vi;
   	
mailbox gen2driv_write;
mailbox gen2driv_read;

  
function new(virtual intf intf_vi, mailbox gen2driv_write,mailbox gen2driv_read);   
	this.intf_vi = intf_vi;
    this.gen2driv_write = gen2driv_write;
	this.gen2driv_read = gen2driv_read;   
endfunction

     
task reset;       
	intf_vi.wdata = '0;
	intf_vi.winc = 0;
	intf_vi.rinc = 0; 
endtask
  
task drive_write();
	transaction_write txw;
	txw=new();
	gen2driv_write.get(txw);
  	intf_vi.winc = txw.winc;
    intf_vi.wdata = txw.wdata;
    @(posedge intf_vi.wclk);
  	@(posedge intf_vi.wclk);   
endtask
       
task drive_read();
    transaction_read txr;
	txr=new();
    gen2driv_read.get(txr);
	intf_vi.rinc = txr.rinc;
  	@(posedge intf_vi.rclk);
  	@(posedge intf_vi.rclk);
endtask   

     
task  main();
	fork
	begin
	repeat(10) @(posedge intf_vi.wclk);
	for (integer i = 0; i < trans_count_write ; i++) 
		drive_write();
	intf_vi.winc=0;
	intf_vi.wdata=0;
	end
	
	begin
	repeat(10) @(posedge intf_vi.rclk);
	for (integer j = 0; j < trans_count_read ; j++) 
		drive_read(); 
	intf_vi.rinc=0;
	end
	join
endtask
         
endclass
