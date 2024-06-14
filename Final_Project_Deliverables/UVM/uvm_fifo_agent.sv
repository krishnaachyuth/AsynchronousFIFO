/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/* Agent consists of driver,monitor and sequencer. In the build phase, create methods for the sequencer, driver, 
and monitor using the factory registration methods from the `uvm_object` class. */

class fifo_agent extends uvm_agent;
`uvm_component_utils(fifo_agent)  
fifo_sequencer sqr;
fifo_driver drv;
fifo_monitor mon;

function new(string name = "fifo_agent",uvm_component parent);
	super.new(name,parent);
	`uvm_info("AGENT CLASS","Agent",UVM_LOW)
endfunction

/********* BUILD PHASE ***********/
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("AGENT CLASS", "Build", UVM_LOW)
	sqr = fifo_sequencer::type_id::create("sqr",this);
	drv = fifo_driver::type_id::create("drv",this);
	mon = fifo_monitor::type_id::create("mon",this);
endfunction

/******** CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("AGENT CLASS", "Connect", UVM_LOW)
	drv.seq_item_port.connect(sqr.seq_item_export);
endfunction
	
/******* RUN PHASE *************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("AGENT CLASS", "Run", UVM_LOW)
endtask

endclass