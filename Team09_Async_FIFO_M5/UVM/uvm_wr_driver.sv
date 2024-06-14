import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_fifo_interface.sv"
`include "uvm_wr_sequencer.sv"


class write_driver extends uvm_driver#(write_packet);
`uvm_component_utils(write_driver)

virtual uvm_fifo_intf vif;
write_packet item;

function new (string name = "write_driver",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Write Driver","Inside Driver Constructor",UVM_HIGH)
endfunction

/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Pkt Write Driver Class","Driver build phase",UVM_HIGH)
	if(!(uvm_config_db#(virtual uvm_fifo_intf)::get(this,"*","vif",vif)))
	begin 
		`uvm_error("DRIVER CLASS","Failed to get VIF from config db")
	end
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Write Driver Class","Driver Connect phase",UVM_HIGH)
endfunction


/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Pkt Write Driver Class","Driver Run phase",UVM_HIGH)
	forever begin 
		item = write_packet::type_id::create("item");
		seq_item_port.get_next_item(item);
		drive(item);
		seq_item_port.item_done();
	end
endtask


task drive(write_packet item);
	//wait(vif.wrst_n);
	@(negedge vif.w_clk);
	vif.data_in <= item.data_in;
	vif.w_en <= item.w_en;
endtask

endclass