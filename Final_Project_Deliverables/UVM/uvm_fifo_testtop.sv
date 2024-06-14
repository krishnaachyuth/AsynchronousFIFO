/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uvm_fifo_interface.sv"
`include "uvm_fifo_transaction.sv"
`include "uvm_fifo_sequence.sv"
`include "uvm_fifo_sequencer.sv"
`include "uvm_fifo_driver.sv"
`include "uvm_fifo_monitor.sv"
`include "uvm_fifo_agent.sv"
`include "uvm_fifo_scoreboard.sv"
`include "uvm_fifo_coverage.sv"
//`include "uvm_report_server.sv"
`include "uvm_fifo_environment.sv"
`include "uvm_fifo_test.sv"


module top;


parameter Depth=512;
parameter Data_Width=8;
parameter Addr_Width=9;


bit rclk=0;
bit wclk=0;
bit wrst, rrst;

/*** INSTANTIATION ********/
uvm_fifo intf_DUT(.wclk(wclk),.rclk(rclk),.wrst(wrst),.rrst(rrst));
async_top #(.Depth(Depth), .Data_Width(Data_Width), .Addr_Width(Addr_Width)) DUT (.intf(intf_DUT));

initial begin 
	uvm_config_db#(virtual uvm_fifo)::set(null,"*","vif",intf_DUT);
end

always #10 rclk = !rclk;
always #4.16 wclk = !wclk;

initial begin
		run_test("fifo_uvmtest");
	end

initial begin
	    wrst = 0;
		rrst = 0;
		
		#15 wrst = 1;
		#15 rrst = 1;
    end
	
initial begin 
#100000;
$display("Sorry ran out of clocks");
$finish;
end

endmodule