import uvm_pkg::*;
`include "uvm_macros.svh"

class write_packet extends uvm_sequence_item;
`uvm_object_utils(write_packet)

function new (string name = "write_packet");
	super.new(name);
endfunction

rand logic [7:0] data_in;
rand bit w_en;
logic full;

constraint data{data_in inside {[0:255]};
				w_en dist {0 := 4,1 := 6};
				};


endclass
