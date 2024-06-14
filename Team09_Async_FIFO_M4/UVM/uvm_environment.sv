import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_scoreboard.sv"

class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env)

write_agent wr_agnt;
read_agent rd_agnt;
fifo_scoreboard scb;

function new (string name = "env",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Environment Class","Inside Environment Class",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Environment Class","Environment build phase",UVM_HIGH)
	wr_agnt = write_agent::type_id::create("wr_agnt",this);
	rd_agnt = read_agent::type_id::create("rd_agnt",this);
	scb = fifo_scoreboard::type_id::create("scb",this);
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Environment Class","Environment Connect phase",UVM_HIGH)
	wr_agnt.wr_mon.monitor_port.connect(scb.scoreboard_write_port);
	rd_agnt.rd_mon.rd_monitor_port.connect(scb.scoreboard_read_port);
endfunction


/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask

endclass