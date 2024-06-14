interface intf(input logic wclk,rclk,wrst,rrst);
logic [7:0] wData;
logic winc;
logic rinc;
    
logic [7:0] rData;
logic rEmpty;
logic wFull;
    
endinterface: intf
