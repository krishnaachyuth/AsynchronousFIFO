/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										                            */		
/* Authors : Achyuth Krishna Chepuri                                  */
/* 			     Sai Sri Harsha Atmakuri                                  */
/*			     Sathwik Reddy Madireddy                                  */ 
/*           Amrutha Regalla                                          */
/**********************************************************************/

module sync_r2w(
wclk, wrst_n,
rptr,
wq2_rptr//readpointer with write side
);

parameter ADDRSIZE = 32;
input   wclk, wrst_n;
input   [ADDRSIZE:0] rptr;
output reg  [ADDRSIZE:0] wq2_rptr;//readpointer with write side
reg [ADDRSIZE:0] wq1_rptr;

always_ff @(posedge wclk or negedge wrst_n)
begin
	if (~wrst_n) 
		{wq2_rptr,wq1_rptr} <= 0;
	else 
		{wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
end

endmodule