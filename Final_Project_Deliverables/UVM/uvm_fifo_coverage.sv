/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/* Coverage */
class fifo_coverage extends uvm_subscriber#(fifo_sequence_item);
`uvm_component_utils(fifo_coverage)
uvm_analysis_imp #(fifo_sequence_item,fifo_coverage)coverage_port;

real coverage1;
real coverage2;
real coverage3;

real total_coverage;
fifo_sequence_item cov_tx;

virtual uvm_fifo vif;

covergroup CG_1 with function sample(fifo_sequence_item cov_tx) ;
    CP_1: coverpoint cov_tx.wr_addr { 
       bins wr_addr[]= {[0:255]};
     }
	 CP_2: coverpoint cov_tx.rd_addr { 
     bins rd_addr[]= {[0:255]};
     }
     wr_rd_addr: cross CP_1,CP_2;
   endgroup

covergroup CG_2 with function sample(fifo_sequence_item wrd_pkt) ;

CP_3:coverpoint wrd_pkt.wrst{
             //bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
CP_4:coverpoint wrd_pkt.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
CP_5:coverpoint wrd_pkt.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
			 
CP_6 : coverpoint wrd_pkt.winc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

CP_7 : coverpoint wrd_pkt.data_in {
             bins wr_data = {[0:255]};
			  }

CP_8 : coverpoint wrd_pkt.rinc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
			  
read_fifo_empty:cross CP_6,CP_4;       
read_write_fifo_empty:cross CP_6,CP_7,CP_4;  
read_and_clear:cross CP_6,CP_3;      
write_and_fifo_full:cross CP_7,CP_5;   
read_write_clear:cross CP_6,CP_3,CP_8;   
clear_and_fifo_empty:cross CP_4,CP_3; 

endgroup

covergroup test_read with function sample(fifo_sequence_item rd_pkt) ;
c5 : coverpoint rd_pkt.rinc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint rd_pkt.rrst {
             bins rd_rstn_high = {1};
			 bins rd_rstn_low = {0};
			 }			 

c7 : coverpoint rd_pkt.data_out {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint rd_pkt.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c9:coverpoint rd_pkt.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c11 : coverpoint rd_pkt.winc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

read_fifo_emptyr:cross c5,c8;       
//read_write_fifo_emptyr:cross c11,c5,c8;  
//read_and_clear_read:cross c5,c6;      
write_and_fifo_fullr:cross c9,c11;   
//read_write_clear:cross c5,c6,c11;   
//clear_and_fifo_empty:cross c6,c8; 
//commands_while_reset: cross c5,c6,c11;

endgroup

function new(string name="fifo_coverage",uvm_component parent);
super.new(name,parent);
`uvm_info("[COVERAGE CLASS]","Inside Coverage class",UVM_LOW)
CG_2=new();
test_read=new();
endfunction

/******** BUILD PHASE ***********/
function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("[COVERAGE CLASS]","Inside Coverage class build phase",UVM_LOW)
coverage_port=new("coverage_port",this);
endfunction


function void write(fifo_sequence_item t);
this.cov_tx=t;
test_read.sample(t);
CG_2.sample(t);
endfunction


/************ EXTRACT PHASE ***********/
function void extract_phase(uvm_phase phase);
super.extract_phase(phase);
coverage1 = CG_2.get_coverage();
coverage2 = test_read.get_coverage();
endfunction

/************ REPORT PHASE ************/
function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("[COVERAGE CLASS]",$sformatf("Coverage = %0f%%",coverage1),UVM_LOW);
`uvm_info("[COVERAGE CLASS]",$sformatf("Coverage = %0f%%",coverage2),UVM_LOW);
endfunction

endclass