import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_rd_driver.sv"

class read_monitor extends uvm_monitor;
`uvm_component_utils(read_monitor)

virtual uvm_fifo_intf vif;
read_packet item;

uvm_analysis_port #(read_packet) rd_monitor_port;

function new (string name = "read_monitor",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Read Monitor","Inside Read Monitor Constructor",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	rd_monitor_port = new("rd_monitor_port",this);
	`uvm_info("Pkt Read Monitor Class","Read Monitor build phase",UVM_HIGH)
	if(!(uvm_config_db#(virtual uvm_fifo_intf)::get(this,"*","vif",vif)))
	begin 
		`uvm_error("Read Monitor CLASS","Failed to get VIF from config db")
	end
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Read Monitor Class","Read Monitor Connect phase",UVM_HIGH)
endfunction


/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Pkt Read Monitor Class","Read Monitor Run phase",UVM_HIGH)
	forever begin 
		item = read_packet::type_id::create("item");
		//wait(vif.rrst_n);
		//wait(!vif.empty);
		
		@(negedge vif.r_clk)
		wait(!vif.empty);
		if(vif.r_en && vif.rrst_n) begin
		item.data_out = vif.data_out;
		item.r_en = vif.r_en;
		item.empty = vif.empty;
		rd_monitor_port.write(item); end
	end
endtask

endclass