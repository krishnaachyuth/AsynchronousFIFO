/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

/*The actual randomization of input values occurs in transaction 
class or sequence classs and is sent to the driver through sequencer*/

class fifo_sequence extends uvm_sequence;
`uvm_object_utils(fifo_sequence) //fifo_sequence_item

fifo_sequence_item transaction;

function new(string name = "fifo_sequence");
	super.new(name);
	`uvm_info("FIFO_SEQUENCE", "Inside Constructor", UVM_LOW)
endfunction

task body();
begin	
	`uvm_info("FIFO_SEQUENCE","[FIFO SEQUENCE CLASS] Inside task body",UVM_LOW)
	transaction = fifo_sequence_item#(8,9,512)::type_id::create("transaction");
	start_item(transaction);
	transaction.norst.constraint_mode(0);
	assert (transaction.randomize() with {transaction.wrst==0;transaction.rrst==0;});
	`uvm_info("[SEQUENCE CLASS]",$sformatf("Generated item,:%s",transaction.convert2str()),UVM_LOW)
	$display("[RESET BODY]");
	$display("/**********************************************************/");
	finish_item(transaction);
end
endtask
endclass


class fifo_sequence_write extends uvm_sequence;
`uvm_object_utils(fifo_sequence_write)

fifo_sequence_item transaction_write;

function new(string name = "fifo_sequence_write");
	super.new(name);
	`uvm_info("FIFO_SEQUENCE_WRITE", "Inside Constructor Sequence Write", UVM_LOW)
endfunction

int transaction_count = 512;
task body();
begin
	for(int i = 0; i<transaction_count;i++)
	begin 
		`uvm_info("FIFO_SEQUENCE_WRITE","[FIFO SEQUENCE WRITE CLASS] Inside task body",UVM_LOW)
		transaction_write = fifo_sequence_item#(8,8,512)::type_id::create("transaction_write");
		start_item(transaction_write);
		assert (transaction_write.randomize() with {winc==1;rinc==0;});
		`uvm_info("[SEQUENCE CLASS]",$sformatf("Generated transaction write data:%s",transaction_write.convert2str()),UVM_LOW)
		$display("/*****************************************************************/");
		$display("/*****************************************************************/");
		finish_item(transaction_write);
		`uvm_info("[SEQUENCE CLASS]",$sformatf(" Generated new write data item: %d",i),UVM_LOW)
	end
	`uvm_info("[SEQUENCE CLASS]",$sformatf("Finished generating %d write transactions to write into FIFO",transaction_count),UVM_LOW)
end
endtask
endclass


class fifo_sequence_read extends uvm_sequence;
`uvm_object_utils(fifo_sequence_read)

fifo_sequence_item transaction_read;

function new(string name = "fifo_sequence_read");
	super.new(name);
	`uvm_info("FIFO_SEQUENCE_READ", "Inside Constructor Sequence Read", UVM_LOW)
endfunction

int transaction_count = 512;
task body();
begin
	for(int i = 0; i<transaction_count;i++)
	begin 
		`uvm_info("FIFO_SEQUENCE_READ","[FIFO SEQUENCE READ CLASS] Inside task body",UVM_LOW)
		transaction_read = fifo_sequence_item#(8,8,512)::type_id::create("transaction_read");
		start_item(transaction_read);
		assert (transaction_read.randomize() with {winc==0;rinc==1;});
		`uvm_info("[SEQUENCE CLASS]",$sformatf("Generated new read data:%s",transaction_read.convert2str()),UVM_LOW)
		$display("/*****************************************************************/");
		$display("/*****************************************************************/");		
		finish_item(transaction_read);
		`uvm_info("[SEQUENCE CLASS]",$sformatf(" Generated new data item: %d",i),UVM_LOW)
	end
	`uvm_info("[SEQUENCE CLASS]",$sformatf("Finished generating %d read transactions to read from FIFO",transaction_count),UVM_LOW)
end
endtask
endclass