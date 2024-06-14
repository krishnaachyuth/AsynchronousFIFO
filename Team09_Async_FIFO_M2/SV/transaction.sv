class transaction_write;
    rand bit [7:0] wdata;
    rand bit winc;
	bit wfull;	 
endclass

class transaction_read;
    rand bit rinc;
    logic [7:0] rdata;
	bit rempty;
endclass
