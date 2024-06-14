/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/*The environment mirrors the agent's structure, but it invokes the "create" method for the agent, 
scoreboard, and coverage using factory registration techniques during the build phase. 
Environment establishes connections between the monitor's analysis port and both the scoreboard and coverage analysis ports.*/

class fifo_environment extends uvm_env;
`uvm_component_utils(fifo_environment)
fifo_agent agnt;
fifo_scoreboard scb;
fifo_coverage coverage;

function new(string name="fifo_environment",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Environment Class","Inside environment class",UVM_LOW)
endfunction

/******** BUILD PHASE ************/
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Environment Class","Inside environment class Build phase",UVM_LOW)
	agnt = fifo_agent::type_id::create("agnt",this);
	scb = fifo_scoreboard ::type_id::create("scb",this);
	coverage = fifo_coverage::type_id::create("coverage",this);
endfunction

/******* CONNECT PHASE ************/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Environment Class","Inside environment class Connect phase",UVM_LOW)
	agnt.mon.monitor_port.connect(scb.ap_port);
	agnt.mon.monitor_port.connect(coverage.coverage_port);
endfunction

	
/********** RUN PHASE ***************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Environment Class","Inside environment class Run phase",UVM_LOW)
endtask

endclass