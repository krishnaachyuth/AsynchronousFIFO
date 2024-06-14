import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_rd_sequence.sv"

class read_sequencer extends uvm_sequencer#(read_packet);
`uvm_component_utils(read_sequencer)

function new (string name = "read_sequencer",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Read Sequencer","Inside Read Sequencer Constructor",UVM_HIGH)
endfunction

/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Pkt Read Sequencer Class","Read Sequencer build phase",UVM_HIGH)
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Read Sequencer Class","Read Sequencer Connect phase",UVM_HIGH)
endfunction

endclass