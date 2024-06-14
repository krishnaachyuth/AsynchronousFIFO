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
   
covergroup FIFO_coverage;
  option.per_instance = 1;

  // Coverpoints for data inputs and outputs
  coverpoint in.wdata {
    bins data_bin[] = {0, 255}; // Assuming 8-bit data size
  }
  coverpoint in.rdata {
    bins data_bin[] = {0, 255}; // Assuming 8-bit data size
  }

  // Coverpoints for pointer movement **NEED DFT to access pointers**
  //coverpoint in.wPtr {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
  //}
  //coverpoint rPtr {
    //bins ptr_bin[] = {0, 255}; // Assuming 8-bit address size
 // }

  // Coverpoints for flags
  rEmpty: coverpoint in.rempty {
    bins empty_bin[] = {0, 1};
  }
  wFull: coverpoint in.wfull {
    bins full_bin[] = {0, 1};
  }

  // Coverpoints for clock and reset signals
  coverpoint wclk;
  coverpoint rclk;
  coverpoint wrst_n;
  coverpoint rrst_n;

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
  coverpoint in.winc;
  coverpoint in.rinc;

  // Cross coverage between read and write pointers ***DFT***
 // cross w_r_cross w_r_cross_inst {
    //wPtr, rPtr;
 // }

  // Cross coverage between write clock and reset
cross wclk,wrst_n {
  bins wclk_rst = binsof(wclk) intersect {wrst_n};
}

  // Cross coverage between read clock and reset
  cross rclk,rrst_n{
    bins rclk_rst = binsof(rclk) intersect {rrst_n};
  }

  // Cross coverage between empty and full flags
  //cross in.rEmpty,in.wFull{
    //bins flag_Gen = binsof(rEmpty) intersect {wFull};
  //}

endgroup
  
//covergroup instantiation
FIFO_coverage FIFO_c;

  initial begin
    FIFO_c = new();
    forever begin @(posedge wclk or posedge rclk)
      FIFO_c.sample();
    end
  end


 
endmodule

