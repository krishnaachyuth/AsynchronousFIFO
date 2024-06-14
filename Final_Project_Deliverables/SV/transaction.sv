class transaction_write;
    	rand bit [7:0] wData;
        rand bit winc;
	bit wFull;
	 
endclass

class transaction_read;
       	rand bit rinc;

     	logic [7:0] rData;
		bit rEmpty;
	  

endclass
