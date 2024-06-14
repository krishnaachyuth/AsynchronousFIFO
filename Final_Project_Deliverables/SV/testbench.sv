`include "interface.sv"
`include "fifotest.sv"


module tb_top;
  bit rclk,wclk,rrst,wrst;
  always #4 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  intf in (wclk,rclk,wrst,rrst);
  test t1 (in);

  FIFO DUT (.wData(in.wData),
            .wFull(in.wFull),
            .rEmpty(in.rEmpty),
            .winc(in.winc),

            .rinc(in.rinc),
            .wclk(in.wclk),
            .rclk(in.rclk),
            .rrst(in.rrst),
            .wrst(in.wrst),
            .rData(in.rData));
  
  

   initial begin
    wclk =0;
    rclk=0;
    wrst =0;
    rrst=0;
    in.rinc=0;
    in.winc=0;
    #1
    rrst =1;
    wrst=1;


    

   end

 
endmodule

