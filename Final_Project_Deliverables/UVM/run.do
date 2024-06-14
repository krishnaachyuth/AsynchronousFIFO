vlib test1
vmap work test1


vlog -lint fifo_mem.sv
vlog -lint rd_2_wr_sync.sv
vlog -lint wr_2_rd_sync.sv
vlog -lint read_ptr.sv
vlog -lint write_ptr.sv
vlog -lint async_top.sv
#vlog -lint uvm_report_server.sv
vlog -lint -work test1  -coveropt 3 +cover +acc async_top.sv

vlog -work test1  -coveropt 3 +cover +acc uvm_fifo_testtop.sv

vsim work.top
#vsim -c -gASIZE=4 FIFO
vsim  -voptargs=+acc work.top
#vsim -coverage top -voptargs="+cover=bcesfx"
#add wave sim:/top/*
#vsim -vopt -coverage test1.top -do "coverage save -onexit -directive -codeAll file1"
add wave sim:/top/DUT.fifo_mem_inst.*
#add wave sim:/top/as1.rhalf_empty
#add wave sim:/top/as1.whalf_full

#add wave -r *

run -all
#vcover report -details -codeAll -html file1