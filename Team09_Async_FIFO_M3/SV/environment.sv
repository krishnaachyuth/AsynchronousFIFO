import fifo_pkg::*;

class environment;
bit rempty;
bit wfull;
generator gen;
driver driv;
monitor mon;
scoreboard scb;

mailbox gen2driv_read;
mailbox gen2driv_write;

mailbox mon2scb_read;
mailbox mon2scb_write;
 
virtual intf vif;
  
function new(virtual intf vif);
    this.vif = vif;
    gen2driv_read = new();
    gen2driv_write = new();

    mon2scb_read = new();
    mon2scb_write = new();

    gen = new(gen2driv_write, gen2driv_read);
    driv = new (vif,gen2driv_write,gen2driv_read);
    mon = new (vif, mon2scb_read,mon2scb_write);
    scb = new (mon2scb_write, mon2scb_read);
endfunction
       
task pre_test();      
	driv.reset();
endtask
    
task test();
  $display("[TB ENVIRONMENT] Number of Write Bursts and read bursts requested are %0d & %0d respectively ",gen.tx_count_write,gen.tx_count_read);

gen.main();   
fork
begin 
    $display("[TB ENVIRONMENT] DRIVE INITIATED");

	driv.main();    
end 

begin
   $display("[TB ENVIRONMENT] MONITOR INITIATED");

  	mon.main();  
end

begin
      $display("[TB ENVIRONMENT] SCOREBOARD INITIATED");

	scb.main(); 
end
join
 
$display("Checking DUT output values");
  scb.check();
$display("DUT Check accomplished");
      
endtask

task run();

pre_test();  	  
test(); 

endtask
        
endclass
