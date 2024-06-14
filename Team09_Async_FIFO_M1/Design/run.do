vlib work

vlog fifo_memory.sv
vlog r_pointer_epty.sv
vlog sync_r2w.sv
vlog syncw2r.sv
vlog w_ptr_wfull.sv
vlog testbench.sv
vlog top.sv
vlog testbench.sv

vsim -c -gADDRSIZE=456 async_fifo1_tb
vsim work.async_fifo1_tb
vsim -voptargs=+acc work.async_fifo1_tb
add wave -r *
add wave sim:/async_fifo1_tb/* 
#do wave.do

run -all