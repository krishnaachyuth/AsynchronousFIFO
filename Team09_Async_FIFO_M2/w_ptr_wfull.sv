module wptr_full(
winc, wclk, wrst_n,
wq2_rptr,
wfull,
waddr,
wptr
);

parameter ADDRSIZE = 32;
input   winc, wclk, wrst_n;
input   [ADDRSIZE :0] wq2_rptr;
output reg  wfull;
output  [ADDRSIZE-1:0] waddr;
output reg [ADDRSIZE :0] wptr;

reg [ADDRSIZE:0] wbin;
wire [ADDRSIZE:0] wgraynext, wbinnext;

always_ff @(posedge wclk or negedge wrst_n)
begin
	if (~wrst_n)
		{wbin, wptr} <= '0;
	else
		{wbin, wptr} <= {wbin + (winc & ~wfull), wgraynext};
end 

assign waddr = wbin[ADDRSIZE-1:0];
assign wbinnext = wbin + (winc & ~wfull);
assign wgraynext = (wbinnext>>1) ^ wbinnext;

assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

always_ff @(posedge wclk or negedge wrst_n)
begin
	if (~wrst_n)
		wfull <= 1'b0;
	else
		wfull <= wfull_val;
end

endmodule