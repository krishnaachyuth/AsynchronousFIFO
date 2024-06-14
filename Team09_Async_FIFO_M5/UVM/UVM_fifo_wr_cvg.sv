import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_scoreboard.sv"

class wr_fifo_coverage extends uvm_subscriber#(write_packet);
`uvm_component_utils(wr_fifo_coverage)

write_packet wr_cov;

real coverage;

covergroup FIFO_coverage;
  option.per_instance = 1;

  // Coverpoints for data inputs and outputs
  coverpoint wr_cov.data_in {
    bins data_bin[] = {255}; // Assuming 8-bit data size
  }
  //coverpoint in.rdata {
  //  bins data_bin[] = {0, 255}; // Assuming 8-bit data size
  //}

  // Coverpoints for pointer movement **NEED DFT to access pointers**
  //coverpoint in.wPtr {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
  //}
  //coverpoint rPtr {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
 // }

  // Coverpoints for flags
 // rEmpty: coverpoint in.rempty {
  //  bins empty_bin[] = {0, 1};
  //}
  wFull: coverpoint wr_cov.full {
    bins full_bin[] = {0};
  }

  // Coverpoints for clock and reset signals
 // coverpoint wclk;
 // coverpoint rclk;
 // coverpoint wrst_n;
 // coverpoint rrst_n;

  // Coverpoints for pointer synchronization **NEED DFT to access pointers**
  //coverpoint rPtr_s {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
 // }
  //coverpoint wPtr_s {
   // bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
  //}

  // Coverpoints for address generation **NEED DFT to access addressing signals**
 // coverpoint wAddr {
    //bins addr_bin[] = {0, 255}; // Assuming 8-bit address size
  //}
  //coverpoint rAddr {
   // bins addr_bin[] = {0, 255}; // Assuming 8-bit address size
  //}

  // Coverpoints for increment signals
  //coverpoint wr_cov.w_en;
  //coverpoint in.rinc;

  // Cross coverage between read and write pointers ***DFT***
 // cross w_r_cross w_r_cross_inst {
    //wPtr, rPtr;
 // }

  // Cross coverage between write clock and reset
//cross wclk,wrst_n {
//  bins wclk_rst = binsof(wclk) intersect {wrst_n};
//}

  // Cross coverage between read clock and reset
//  cross rclk,rrst_n{
//    bins rclk_rst = binsof(rclk) intersect {rrst_n};
//  }

  // Cross coverage between empty and full flags
  //cross in.rEmpty,in.wFull{
    //bins flag_Gen = binsof(rEmpty) intersect {wFull};
  //}

endgroup

function new(input string name = "wr_fifo_coverage",uvm_component parent);
	
	super.new(name,parent);
	FIFO_coverage = new;
	//zeros_or_ones_on_ops = new;

	wr_cov = write_packet::type_id::create("wr_cov");

endfunction

virtual function void write(input write_packet t);
	//`uvm_info(get_type_name(),"Reading data from monitor for coverage",UVM_LOW);

	wr_cov = t;	
	FIFO_coverage.sample();
	coverage = FIFO_coverage.get_coverage();
	//zeros_or_ones_on_ops.sample();
	//cov2 = zeros_or_ones_on_ops.get_coverage();
	//`uvm_info(get_full_name(),$sformatf("Coverage is %d",coverage),UVM_NONE);	
endfunction

virtual function void extract_phase(uvm_phase phase);
  uvm_config_db#(real)::set(null,"uvm_test_top.env","fcov_score",coverage);
endfunction


endclass