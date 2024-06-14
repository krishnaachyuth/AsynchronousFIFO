/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/*Sequencer module manages the generation and sequencing of stimulus trasanctions 
Build Phase and connect phase are used in the sequencer to connect to the driver and 
pass items from sequence to driver*/

class fifo_sequencer extends uvm_sequencer #(fifo_sequence_item);
	`uvm_component_utils(fifo_sequencer)  
	
	function new (string name ="fifo_sequencer",uvm_component parent);
		super.new(name,parent);
		`uvm_info("SEQUENCER CLASS", "Inside Sequencer Constructor!",UVM_LOW)
	endfunction 
/******* BUILD PHASE *******/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SEQUENCER CLASS", "Sequencer Build Phase!",UVM_LOW)
	endfunction
/******* CONNECT PHASE ******/	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SEQUENCER CLASS", "Sequencer Connect Phase!",UVM_LOW)
	endfunction

endclass
