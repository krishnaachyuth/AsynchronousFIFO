/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/*This module includes all the signals which are needed to be randomised along with other signals.*/

class fifo_sequence_item #(parameter DATA_WIDTH=8,ADDR_WIDTH=9,DEPTH=512) extends uvm_sequence_item;
`uvm_object_utils(fifo_sequence_item #(8,9,512))

rand bit rinc;
rand bit winc;
rand bit [DATA_WIDTH-1:0] data_in;
bit [DATA_WIDTH-1:0] data_out;
bit empty;
bit full;
bit half_empty;
bit half_full;
bit [ADDR_WIDTH:0] wr_addr, rd_addr;
rand bit wrst;
rand bit rrst;

constraint norst {wrst == 1 && rrst ==1;}
constraint data{data_in inside {[0:255]};}

function string convert2str();
	return $sformatf("w_en = %d, r_en =%d,data_in = %d",winc,rinc,data_in);
endfunction

function new(string name = "fifo_sequence_item");
	super.new(name);
endfunction

endclass