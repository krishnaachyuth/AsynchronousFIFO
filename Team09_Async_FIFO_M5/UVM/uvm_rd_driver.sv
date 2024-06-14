import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_fifo_interface.sv"
`include "uvm_rd_sequencer.sv"


class read_driver extends uvm_driver#(read_packet);
`uvm_component_utils(read_driver)

virtual uvm_fifo_intf vif;
read_packet item;

function new (string name = "read_driver",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Read Driver","Inside Read Driver Constructor",UVM_HIGH)
endfunction

/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Pkt Read Driver Class","Driver build phase",UVM_HIGH)
	if(!(uvm_config_db#(virtual uvm_fifo_intf)::get(this,"*","vif",vif)))
	begin 
		`uvm_error("DRIVER CLASS","Failed to get VIF from config db")
	end
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Read Driver Class","Read Driver Connect phase",UVM_HIGH)
endfunction


/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Pkt Read Driver Class","Read Driver Run phase",UVM_HIGH)
	forever begin 
		item = read_packet::type_id::create("item");
		seq_item_port.get_next_item(item);
		drive(item);
		seq_item_port.item_done();
	end
endtask


task drive(read_packet item);
	//wait(vif.rrst_n);
	@(negedge vif.r_clk)
	vif.r_en <= item.r_en;
endtask

endclass