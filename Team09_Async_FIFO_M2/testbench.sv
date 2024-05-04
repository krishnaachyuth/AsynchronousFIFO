`include "interface.sv"
`include "fifotest.sv"


module tb_top;
  bit rclk,wclk,rrst_n,wrst_n;
  always #8.334 wclk = ~wclk;
  always #50 rclk = ~rclk;
  
  intf in (wclk,rclk,wrst_n , rrst_n );
  test t1 (in);

  async_fifo1 DUT (.wdata(in.wdata),
            .wfull(in.wfull),
            .rempty(in.rempty),
            .winc(in.winc),

            .rinc(in.rinc),
            .wclk(in.wclk),
            .rclk(in.rclk),
            .rrst_n(in.rrst_n),
            .wrst_n(in.wrst_n),
            .rdata(in.rdata));
  
   initial begin
    wclk =0;
    rclk=0;
    wrst_n =0;
    rrst_n=0;
    in.rinc=0;
    in.winc=0;
    #1
    rrst_n =1;
    wrst_n=1;

   end

 
endmodule

