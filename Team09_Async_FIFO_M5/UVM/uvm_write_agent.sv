import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_write_monitor.sv"

class write_agent extends uvm_agent;
`uvm_component_utils(write_agent)

write_sequencer wr_seqr;
write_driver wr_drv;
write_monitor wr_mon;

function new (string name = "write_agent",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Write Agent","Inside Agent",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Pkt Write Agent Class","Agent build phase",UVM_HIGH)
	wr_drv = write_driver::type_id::create("wr_drv",this);
	wr_seqr = write_sequencer::type_id::create("wr_seqr",this);
	wr_mon = write_monitor::type_id::create("wr_mon",this);
endfunction

/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Write Agent Class","Agent Connect phase",UVM_HIGH)
	wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
endfunction

/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask


endclass

