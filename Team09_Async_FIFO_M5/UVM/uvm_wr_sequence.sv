import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_wr_packet.sv"

class write_sequence extends uvm_sequence #(write_packet);
`uvm_object_utils(write_sequence)

function new (string name = "write_sequence");
	super.new(name);
	`uvm_info("Pkt Write Sequence","Inside Constructor",UVM_HIGH)
endfunction

write_packet wr_pkt;

task body();
	wr_pkt = write_packet::type_id::create("wr_pkt");
	
	repeat(20)
	begin 
		start_item(wr_pkt);
		assert (wr_pkt.randomize());
		finish_item(wr_pkt);
	end
endtask
endclass