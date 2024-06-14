import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_rd_packet.sv"

class read_sequence extends uvm_sequence #(read_packet);
`uvm_object_utils(read_sequence)

function new (string name = "read_sequence");
	super.new(name);
	`uvm_info("Pkt Read Sequence","Inside Read Sequence Constructor",UVM_HIGH)
endfunction

read_packet rd_pkt;

task body();
	rd_pkt = read_packet::type_id::create("rd_pkt");
	
	repeat(10)
	begin 
		start_item(rd_pkt);
		assert (rd_pkt.randomize());
		finish_item(rd_pkt);
	end
endtask
endclass