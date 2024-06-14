import uvm_pkg::*;
`include "uvm_macros.svh"

/*
`include "uvm_fifo_interface.sv"
`include "uvm_wr_packet.sv"
`include "uvm_wr_sequence.sv"
`include "uvm_wr_sequencer.sv"
`include "uvm_wr_driver.sv"
`include "uvm_write_monitor.sv"
`include "uvm_write_agent.sv"
`include "uvm_scoreboard.sv"
`include "uvm_environment.sv"
*/
`include "uvm_test.sv"


module top;

logic w_clk;
logic r_clk;
logic wrst_n;
logic rrst_n;

uvm_fifo_intf intf(w_clk,r_clk,wrst_n,rrst_n);


//asynchronous_fifo as1 ( .wclk(intf.w_clk), .wrst_n(intf.wrst_n), .rclk(intf.r_clk), .rrst_n(intf.rrst_n), .w_en(intf.w_en), .r_en(intf.r_en), .data_in(intf.data_in), .data_out(intf.data_out), .full(intf.full), .empty(intf.empty));

FIFO as1 ( .wclk(intf.w_clk), .wrst(intf.wrst_n), .rclk(intf.r_clk), .rrst(intf.rrst_n), .winc(intf.w_en), .rinc(intf.r_en), .wData(intf.data_in), .rData(intf.data_out), .wFull(intf.full), .rEmpty(intf.empty));

initial begin 
	uvm_config_db #(virtual uvm_fifo_intf)::set(null,"*","vif",intf);
end

initial begin 
	run_test("fifo_test");
	//$finish();
end


always #10 w_clk = ~w_clk;
always #35 r_clk = ~r_clk;

initial
begin
	w_clk = 1'b0;
	wrst_n = 1'b1;
	r_clk = 1'b0;
	rrst_n = 1'b1;
	intf.w_en = 1'b0;
	intf.r_en = 1'b0;
	fork
		begin
			repeat(10) 
				begin
					//@(posedge w_clk)
					#5;
					wrst_n = 1'b0;
				end
			@(posedge w_clk)
			wrst_n = 1'b1;
		end
	
		begin
			repeat(3)
				begin
					//@(posedge r_clk)
					#17.5
					rrst_n = 1'b0;
				end
			@(posedge r_clk)
			rrst_n = 1'b1;		
		end
	join
/*w_clk=0;
r_clk=0;
wrst_n =0;
rrst_n=1;
intf.r_en=0;
intf.w_en=0;
@(negedge r_clk);
rrst_n =0;
@(negedge r_clk);
@(negedge r_clk);
rrst_n =1;
wrst_n=1;*/
	
end

initial begin 
	#20000;
	$display("Sorry! Ran out of clock cycles");
	$finish();
end

endmodule