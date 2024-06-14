import uvm_pkg::*;
`include "uvm_macros.svh"
`include "UVM_fifo_wr_cvg.sv"

class fifo_read_coverage extends uvm_subscriber#(read_packet);
`uvm_component_utils(fifo_read_coverage)

read_packet rd_cov;

real read_coverage;

covergroup FIFO_coverage;
  option.per_instance = 1;

  // Coverpoints for data inputs and outputs
  //coverpoint rd_cov.data_in {
  //  bins data_bin[] = {0, 255}; // Assuming 8-bit data size
  //}
  coverpoint rd_cov.data_out {
    bins data_bin[] = {255}; // Assuming 8-bit data size
  }

  // Coverpoints for pointer movement **NEED DFT to access pointers**
  //coverpoint in.wPtr {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
  //}
  //coverpoint rPtr {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
 // }

  // Coverpoints for flags
  rEmpty: coverpoint rd_cov.empty {
    bins empty_bin[] = {0};
  }
 // wFull: coverpoint rd_cov.full {
  //  bins full_bin[] = {0, 1};
  //}

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
  //coverpoint rd_cov.w_en;
  //coverpoint rd_cov.r_en;

  // Cross read_coverage between read and write pointers ***DFT***
 // cross w_r_cross w_r_cross_inst {
    //wPtr, rPtr;
 // }

  // Cross read_coverage between write clock and reset
//cross wclk,wrst_n {
//  bins wclk_rst = binsof(wclk) intersect {wrst_n};
//}

  // Cross read_coverage between read clock and reset
//  cross rclk,rrst_n{
//    bins rclk_rst = binsof(rclk) intersect {rrst_n};
//  }

  // Cross read_coverage between empty and full flags
  //cross in.rEmpty,in.wFull{
    //bins flag_Gen = binsof(rEmpty) intersect {wFull};
  //}

endgroup

function new(input string name = "fifo_read_coverage",uvm_component parent);
	
	super.new(name,parent);
	FIFO_coverage = new;
	//zeros_or_ones_on_ops = new;

	rd_cov = read_packet::type_id::create("rd_cov");

endfunction

virtual function void write(input read_packet t);
	//`uvm_info(get_type_name(),"Reading data from monitor for read_coverage",UVM_LOW);

	rd_cov = t;	
	FIFO_coverage.sample();
	read_coverage = FIFO_coverage.get_coverage();
	//zeros_or_ones_on_ops.sample();
	//cov2 = zeros_or_ones_on_ops.get_coverage();
	//`uvm_info(get_full_name(),$sformatf("Coverage is %d",read_coverage),UVM_NONE);	
endfunction

virtual function void extract_phase(uvm_phase phase);
  uvm_config_db#(real)::set(null,"uvm_test_top.env","fcov_score",read_coverage);
endfunction


endclass