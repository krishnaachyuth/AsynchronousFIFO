/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/* Scoreboard is to validate the output from the DUT to the output of the reference model*/
class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils(fifo_scoreboard)
bit [7:0]transaction_queue[$];
fifo_sequence_item trans[$];
uvm_analysis_imp #(fifo_sequence_item,fifo_scoreboard) ap_port;

function new(string name="fifo_scoreboard",uvm_component parent);
	super.new(name,parent);
	`uvm_info("Scoreboard Class","Inside Scoreboard Class",UVM_LOW)
endfunction

/******** BUILD PHASE **********/
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("Scoreboard Class","Inside Build Phase",UVM_LOW)
	ap_port = new("ap_port",this);
endfunction

/******** CONNECT PHASE ********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("Scoreboard Class","Inside Connect Phase",UVM_LOW)
endfunction


/********** RUN PHASE ********/
task  run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("Scoreboard Class","Inside run Phase",UVM_LOW)
	forever begin 
		fifo_sequence_item current_transaction;
		wait(trans.size != 0);
		current_transaction= trans.pop_back();
		read(current_transaction);
	end
endtask


function void write(fifo_sequence_item seqitem);
	trans.push_front(seqitem);
	if(seqitem.winc & !seqitem.full)
	begin 
		transaction_queue.push_front(seqitem.data_in);
		`uvm_info("Scoreboard write data_in",$sformatf("Burst Dtails:w_en=%d, data_in=%d, full=%0d",seqitem.winc, seqitem.data_in, seqitem.full),UVM_LOW) 
	end
endfunction

task read(fifo_sequence_item read_trans);
	bit [7:0]expected_data;
	bit [7:0]actual_data;
	
	if(read_trans.rinc & !read_trans.empty)
	begin 
		actual_data = read_trans.data_out;
		expected_data = transaction_queue.pop_back();
		`uvm_info("Scoreboard_getting read data_in",$sformatf("Burtst Dtails:rinc=%d, data_in=%d, full=%0d",read_trans.rinc, read_trans.data_in, read_trans.empty),UVM_LOW)
	end
	if(actual_data != expected_data)
	begin 
		`uvm_error("Comparing read", $sformatf("transaction failed actual_data=%d, expected_data=%d", actual_data,expected_data)) 
	end
	else begin 
		`uvm_info("Comparing read", $sformatf("transaction passed actual_data=%d, expected_data=%d", actual_data,expected_data), UVM_LOW)
	end
endtask

endclass