import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_wr_driver.sv"

class write_monitor extends uvm_monitor;
`uvm_component_utils(write_monitor)

virtual uvm_fifo_intf vif;
write_packet item;

uvm_analysis_port #(write_packet) monitor_port;

function new (string name = "write_monitor",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Pkt Write Monitor","Inside Monitor Constructor",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	monitor_port = new("monitor_port",this);
	`uvm_info("Pkt Write Monitor Class","Monitor build phase",UVM_HIGH)
	if(!(uvm_config_db#(virtual uvm_fifo_intf)::get(this,"*","vif",vif)))
	begin 
		`uvm_error("Monitor CLASS","Failed to get VIF from config db")
	end
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Pkt Write Monitor Class","Monitor Connect phase",UVM_HIGH)
endfunction

/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Pkt Write Monitor Class","Monitor Run phase",UVM_HIGH)
	
	forever begin 
		item = write_packet::type_id::create("item");
		//wait(vif.wrst_n);
		
		@(posedge vif.w_clk)
		wait(!vif.full);
		if(vif.w_en && vif.wrst_n) begin
		item.data_in = vif.data_in;
		item.w_en = vif.w_en;
		monitor_port.write(item); end
	end

endtask

endclass