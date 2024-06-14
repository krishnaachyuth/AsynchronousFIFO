vlib work
vlog FIFO_package.sv
vlog fifo_memory.sv
vlog r_pointer_epty.sv
vlog sync_r2w.sv
vlog syncw2r.sv
vlog w_ptr_wfull.sv
vlog testbench.sv
vlog top.sv
#vlog testbench.sv
vlog transaction.sv
vlog interface.sv
vlog scoreboard.sv
vlog monitor.sv
vlog gen.sv
vlog drive.sv
vlog environment.sv
vlog fifotest.sv
vlog testbench.sv

vsim -c -gADDRSIZE=456 tb_top
vsim work.tb_top
vsim -voptargs=+acc work.tb_top
vsim -coverage tb_top -voptargs="+cover=bcesfx"
#add wave -r *
#add wave sim:/tb_top/* 
#do wave.do

run -all