/**********************************************************************/
/* ECE -593 FUNDAMENTALS OF PRESILICON VALIDATION                     */
/*				FINAL PROJECT										  */		
/* Authors : Achyuth Krishna Chepuri                                  */
/*			 Amrutha Regalla                                          */
/* 			 Sai Sri Harsha Atmakuri                                  */
/*			 Sathwik Reddy Madireddy                                  */ 
/**********************************************************************/

class fifo_uvmtest extends uvm_test;
`uvm_component_utils(fifo_uvmtest)

fifo_environment env;
fifo_sequence reset_seq;
fifo_sequence_write write_seq;
fifo_sequence_read read_seq;

//fifo_report_server srv_h;
int logfile;

function new(string name="fifo_uvmtest",uvm_component parent);
	super.new(name,parent);
	`uvm_info("TEST CLASS","Inside test class",UVM_LOW)
endfunction

/******* BUILD PHASE *********/

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("TEST CLASS","Inside test class",UVM_LOW)
	env = fifo_environment::type_id::create("env",this);
	//srv_h = new();
    //uvm_report_server::set_server(srv_h);
endfunction


/******** CONNECT PHASE ***********/
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("TEST CLASS","Inside test class connect phase",UVM_LOW)
endfunction

/******** RUN PHASE *********/
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("TEST CLASS","Inside test class run phase",UVM_LOW)
	phase.raise_objection(this);
	reset_seq=fifo_sequence::type_id::create("reset_seq");
	reset_seq.start(env.agnt.sqr);
	
	#10;
	write_seq=fifo_sequence_write::type_id::create("write_seq");
	write_seq.transaction_count = 1024;
	write_seq.start(env.agnt.sqr);
	
	#4;
	read_seq=fifo_sequence_read::type_id::create("read_seq");
	read_seq.transaction_count = 512;
	read_seq.start(env.agnt.sqr);

	#10;
	phase.drop_objection(this);
endtask

/******* START OF SIMULATION PHASE ********/
function void start_of_simulation_phase(uvm_phase phase);
	//my_report_server	server = new;
	super.start_of_simulation_phase(phase);
	`uvm_info("TEST CLASS","start of simulation phase - test",UVM_HIGH);
	logfile = $fopen("bug_logfile.txt","w");
	set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
	set_report_severity_file_hier(UVM_ERROR, logfile);
	//uvm_report_server::set_server( server );
endfunction
	
/************ END OF ELABORATION PHASE ************/
function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_root::get().print_topology();
endfunction

/*********** EXTRACT PHASE *********/
function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_type_name(), $psprintf("extract phase"), UVM_NONE)
endfunction

endclass