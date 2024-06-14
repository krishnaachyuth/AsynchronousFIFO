/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/*Monitor continously gathers data from DUT and sends to scoreboard.
During build phase, monitor uses uvm_config_db to ensure proper connection 
with the interface*/

class fifo_monitor extends uvm_monitor;
`uvm_component_utils(fifo_monitor)
virtual uvm_fifo vif;
fifo_sequence_item item;

uvm_analysis_port #(fifo_sequence_item)monitor_port;

/*********** Constructor Creation **********/
function new (string name= "fifo_monitor",uvm_component parent);
	super.new(name,parent);
	`uvm_info("fifo_monitor Class","Mon","UVM_LOW");
endfunction

/*********** BUILD PHASE *************/
function void build_phase(uvm_phase phase);
	super.build_phase(phase); //fifo_sequence_item
	`uvm_info("fifo_monitor Class", "Mon",UVM_LOW)
	monitor_port = new("monitor_port", this);
	if(!(uvm_config_db # (virtual uvm_fifo):: get (this, "*", "vif", vif))) 
	begin
	`uvm_error ("DRIVER CLASS", "Failed")
	end
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("fifo_monitor Class","fifo_monitor Connect phase",UVM_LOW)
endfunction

/********* RUN PHASE ************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("fifo_monitor Class","fifo_monitor Run phase",UVM_LOW)
	forever begin 
		item = fifo_sequence_item#(8,9,512)::type_id::create("item");
		wait(vif.wrst && vif.rrst);
		if(vif.winc & !vif.rinc)
		begin 
			@(posedge vif.wclk);
			item.winc = vif.winc;
			item.rinc = vif.rinc;
			item.wr_addr = vif.wr_addr;
			item.rd_addr = vif.rd_addr;
			item.data_in = vif.data_in;
			item.data_out = vif.data_out;
			item.full = vif.full;
			item.empty = vif.empty;
			item.half_full = vif.half_full;
			item.half_empty = vif.half_empty;
			`uvm_info("DRIVER_WRITE",$sformatf("Burst Dtails:time=%0d,winc=%d,rinc=%d,data_in=%d,full=%0d,half_full=%0d,empty=%0d,half_empty=%0d,wr_addr=%d",$time,vif.winc,vif.rinc,vif.data_in,vif.full,vif.half_full,vif.empty,vif.half_empty,vif.wr_addr),UVM_LOW)
		end
		
		if(!vif.winc & vif.rinc)
		begin 
			@(posedge vif.rclk);
			item.winc = vif.winc;
			item.rinc = vif.rinc;
			item.wr_addr = vif.wr_addr;
			item.rd_addr = vif.rd_addr;
			item.data_in = vif.data_in;
			item.data_out = vif.data_out;
			item.full = vif.full;
			item.empty = vif.empty;
			item.half_full = vif.half_full;
			item.half_empty = vif.half_empty;
			`uvm_info("DRIVER_READ",$sformatf("Burst Dtails:time=%0d,winc=%d,rinc=%d,data_out=%d,full=%0d,half_full=%0d,empty=%0d,half_empty=%0d,rd_addr=%d",$time,vif.winc,vif.rinc,vif.data_out,vif.full,vif.half_full,vif.empty,vif.half_empty,vif.rd_addr),UVM_LOW)
		end
		
		monitor_port.write(item);
	end
endtask

endclass
	