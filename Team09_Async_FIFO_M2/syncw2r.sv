module sync_w2r(
rclk, rrst_n,
wptr,
rq2_wptr
);

parameter ADDRSIZE = 32;
input   rclk, rrst_n;
input   [ADDRSIZE:0] wptr;
output reg [ADDRSIZE:0] rq2_wptr;
reg [ADDRSIZE:0] rq1_wptr;

always_ff @(posedge rclk or negedge rrst_n)
begin
	if (~rrst_n)
		{rq2_wptr,rq1_wptr} <= 0;
	else
		{rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
end

endmodule