import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_rd_monitor.sv"

class read_agent extends uvm_agent;
`uvm_component_utils(read_agent)

read_sequencer rd_seqr;
read_driver rd_drv;
read_monitor rd_mon;

function new (string name = "read_agent",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Read Agent","Inside Read Agent",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Pkt Read Agent Class","Agent build phase",UVM_HIGH)
	rd_drv = read_driver::type_id::create("rd_drv",this);
	rd_seqr = read_sequencer::type_id::create("rd_seqr",this);
	rd_mon = read_monitor::type_id::create("rd_mon",this);
endfunction

/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Read Agent Class","Agent Connect phase",UVM_HIGH)
	rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
endfunction

/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask


endclass

