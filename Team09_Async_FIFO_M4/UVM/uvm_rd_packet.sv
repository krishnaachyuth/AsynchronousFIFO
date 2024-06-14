import uvm_pkg::*;
`include "uvm_macros.svh"

class read_packet extends uvm_sequence_item;
`uvm_object_utils(read_packet)

function new (string name = "read_packet");
	super.new(name);
endfunction

logic [7:0] data_out;
rand bit r_en;
logic empty;
constraint data{
				r_en dist {0 := 4,1 := 6};
				};
endclass
