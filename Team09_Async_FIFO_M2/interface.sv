interface intf(input logic wclk,rclk,wrst_n,rrst_n);
logic [7:0] wdata;
logic winc;
logic rinc;
    
logic [7:0] rdata;
logic rempty;
logic wfull;
    
endinterface
