/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/* 			     Sai Sri Harsha Atmakuri                              */
/*			     Sathwik Reddy Madireddy                              */ 
/*           Amrutha Regalla                                          */
/**********************************************************************/

module async_fifo1_tb;

parameter DATADDRSIZE = 8;
parameter ADDRSIZE = 4;

wire [DATADDRSIZE-1:0] rdata;
wire wfull;
wire rempty;
reg [DATADDRSIZE-1:0] wdata;
reg winc, wclk, wrst_n;
reg rinc, rclk, rrst_n;


reg [DATADDRSIZE-1:0] verif_data_q[$];
reg [DATADDRSIZE-1:0] verif_wdata;



async_fifo1 #(DATADDRSIZE, ADDRSIZE) dut (.*);

initial begin
wclk = 1'b0;
rclk = 1'b0;

fork
  forever #33.33ns wclk = ~wclk;
  forever #50ns rclk = ~rclk;
join
end

initial begin
winc = 1'b0;
wdata = '0;
wrst_n = 1'b0;
repeat(5) @(posedge wclk);
wrst_n = 1'b1;

for (int iter=0; iter<2; iter++) begin
  for (int i=0; i<460; i++) begin
	@(posedge wclk iff !wfull);
	winc = (i%2 == 0)? 1'b1 : 1'b0;
	if (winc) begin
	  wdata = $urandom;
	  verif_data_q.push_front(wdata);
	end
  end
  #1us;
end
end

initial begin
rinc = 1'b0;

rrst_n = 1'b0;
repeat(5) @(posedge rclk);
rrst_n = 1'b1;

for (int iter=0; iter<2; iter++) begin
  for (int i=0; i<460; i++) begin
	@(posedge rclk iff !rempty)
	rinc = (i%2 == 0)? 1'b1 : 1'b0;
	if (rinc) begin
	  verif_wdata = verif_data_q.pop_back();
	  $display("Checking rdata: expected wdata = %h, rdata = %h", verif_wdata, rdata);
	  assert(rdata === verif_wdata) else $error("Checking failed: expected wdata = %h, rdata = %h", verif_wdata, rdata);
	end
  end
end

$finish;
end

endmodule