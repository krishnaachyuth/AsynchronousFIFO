import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_wr_sequence.sv"

class write_sequencer extends uvm_sequencer#(write_packet);
`uvm_component_utils(write_sequencer)

function new (string name = "write_sequencer",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Write Sequencer","Inside Sequencer Constructor",UVM_HIGH)
endfunction

/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Pkt Write Sequencer Class","Sequencer build phase",UVM_HIGH)
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Write Sequencer Class","Sequencer Connect phase",UVM_HIGH)
endfunction

endclass