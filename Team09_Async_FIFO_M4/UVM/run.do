vlog -lint design_a.sv
vlog -lint uvm_fifo_interface.sv

vlog -lint uvm_wr_packet.sv
vlog -lint uvm_wr_sequence.sv
vlog -lint uvm_wr_sequencer.sv
vlog -lint uvm_wr_driver.sv
vlog -lint uvm_write_monitor.sv
vlog -lint uvm_write_agent.sv

vlog -lint uvm_rd_packet.sv
vlog -lint uvm_rd_sequence.sv
vlog -lint uvm_rd_sequencer.sv
vlog -lint uvm_rd_driver.sv
vlog -lint uvm_rd_monitor.sv
vlog -lint uvm_rd_agent.sv

vlog -lint uvm_scoreboard.sv
vlog -lint uvm_environment.sv
vlog -lint uvm_test.sv
vlog -lint uvm_test_top.sv


vsim work.top

vsim  -voptargs=+acc work.top
add wave sim:/top/*
add wave sim:/top/as1.*
#add wave sim:/top/as1.rptr_h.*

#add wave -r *

run -all