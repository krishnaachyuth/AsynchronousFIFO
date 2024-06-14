interface uvm_fifo_intf(input bit w_clk,r_clk,wrst_n,rrst_n);
	logic w_en,r_en,full ,empty;
	logic [7:0] data_in,data_out;
	logic whalf_full;
	logic rhalf_empty;
	
	/*
	clocking wcb @(posedge w_clk);
		default input #1ns;
		input w_en, full, data_in, w_clk;
	endclocking
	
	clocking rcb @(posedge r_clk);
		default input #1ns;
		input r_en, empty, data_out, r_clk;
	endclocking
	
	modport wm ( clocking wcb);
	modport rm ( clocking rcb);*/
endinterface