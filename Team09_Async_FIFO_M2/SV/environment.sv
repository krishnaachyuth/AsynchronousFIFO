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
gen.main();   
fork
begin 
	driv.main();    
end 

begin
  	mon.main();  
end

begin
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
