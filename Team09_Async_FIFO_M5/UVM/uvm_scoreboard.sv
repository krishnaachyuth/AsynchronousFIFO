import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_write_agent.sv"
`include "uvm_rd_agent.sv"

`uvm_analysis_imp_decl(_monitor_port)
`uvm_analysis_imp_decl(_rd_monitor_port)

class fifo_scoreboard extends uvm_test;
`uvm_component_utils(fifo_scoreboard)

uvm_analysis_imp_monitor_port#(write_packet,fifo_scoreboard)scoreboard_write_port;
uvm_analysis_imp_rd_monitor_port#(read_packet,fifo_scoreboard)scoreboard_read_port;

write_packet transactions_write[$];
read_packet transactions_read[$];
int empty_count_write;
int empty_count_read;

function new (string name = "fifo_scoreboard",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Scoreboard Class","Inside Scoreboard Class",UVM_HIGH)
endfunction


/******** BUILD PHASE *************/
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Scoreboard Class","Inside Build Phase",UVM_HIGH)
	scoreboard_write_port = new("scoreboard_write_port",this);
	scoreboard_read_port = new("scoreboard_read_port",this);
endfunction


/********* CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Scoreboard Class","Scoreboard Connect phase",UVM_HIGH)	
endfunction


/********* WRITE METHOD*************/
function void write_monitor_port(write_packet write_item);
	if(write_item.w_en == 1)	begin
	transactions_write.push_back(write_item);
	end
	/*if(read_item.r_en == 1)	begin
	transactions_read.push_back(read_item);
	end*/
endfunction

/********* WRITE METHOD *************/
function void write_rd_monitor_port(read_packet read_item);
	logic [7:0] pop_data_write;
	logic [7:0] pop_data_read;
	if(read_item.r_en == 1)	begin
	transactions_read.push_back(read_item);
	end
	
	//empty_count = transactions_write.size;
	if(transactions_write.size > 0 && transactions_read.size>0)
	begin 
	//if(read_item.r_en == '1) begin
	 //compare();
	pop_data_write = transactions_write.pop_front().data_in;
	pop_data_read = transactions_read.pop_front().data_out;
	//result = get_actual.compare(pop_data);
	if(pop_data_write == pop_data_read)
		`uvm_info("SCOREBOARD", $sformatf("MATCH Expected Data: %0h --- DUT Read Data: %0h", pop_data_write, pop_data_read), UVM_MEDIUM)
    else
        `uvm_error("SCOREBOARD", $sformatf("Expected Data: %0h Does not match DUT Read Data: %0h", pop_data_write, pop_data_read ))
    end 
	//end
endfunction

/******** TASK COMPARE **********/
/*
task compare();
        logic [7:0] pop_data;
		pop_data = transactions_write.pop_front().data_in;
		if(pop_data == read_item.data_out)
		`uvm_info("SCOREBOARD", $sformatf("MATCH Expected Data: %0h --- DUT Read Data: %0h", pop_data, read_item.data_out), UVM_MEDIUM)
    else
       `uvm_error("SCOREBOARD", $sformatf("Expected Data: %0h Does not match DUT Read Data: %0h", read_item.data_out, pop_data))
endtask*/


/********** RUN PHASE **************/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask


endclass