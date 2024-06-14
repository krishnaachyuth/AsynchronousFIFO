/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

class fifo_report_server extends uvm_report_server;
`uvm_object_utils(fifo_report_server)

function new (string name="fifo_report_server");
	super.new();
	$display( "Constructing report serevr %0s",name);
endfunction


virtual function string compose_message( uvm_severity severity,string name,string id,string message,string filename,int line );
	$display("From Super: \n %0s",super.compose_message(severity,name,id,message,filename,line));
endfunction

endclass