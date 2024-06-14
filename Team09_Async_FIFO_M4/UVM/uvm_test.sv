import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_environment.sv"

class fifo_test extends uvm_test;
`uvm_component_utils(fifo_test)
fifo_env env;
write_sequence wr_seq;
read_sequence rd_seq;

function new (string name = "fifo_test",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Test Class","Inside Test Class",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Test Class","Test build phase",UVM_HIGH)
	env = fifo_env::type_id::create("env",this);
endfunction

/******** END OF ELLABORATION ***************/

virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Test Class","Test Connect phase",UVM_HIGH)
endfunction

/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Test Class","Test Run phase",UVM_HIGH)
	phase.raise_objection(this);
	repeat(20) begin 
	wr_seq = write_sequence::type_id::create("wr_seq");
	rd_seq = read_sequence::type_id::create("rd_seq");
	wr_seq.start(env.wr_agnt.wr_seqr);
	rd_seq.start(env.rd_agnt.rd_seqr);
	end
endtask

endclass