`include "environment.sv"

program test(intf in);
  environment env;
  logic [5:0] read_request;
  logic [5:0] write_request;
  initial begin
    read_request = 8;
    write_request = 8;
    
    env = new(in);
    env.gen.tx_count_read =8;
    env.gen.tx_count_write =8;
    
    env.driv.trans_count_read=8;
    env.driv.trans_count_write=8;
    
    env.mon.trans_count_write=8;
    env.mon.trans_count_read=8;
    
    env.scb.trans_count_write=8;
    env.scb.trans_count_read=8;

    env.run();
    $finish;
  end
endprogram
