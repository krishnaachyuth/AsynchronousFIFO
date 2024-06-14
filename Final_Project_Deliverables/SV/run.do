
vlib work

vlog design.sv
vlog FIFO_package.sv
vlog transaction.sv
vlog interface.sv
vlog fifoscoreboard.sv
vlog fifomonitor.sv
vlog fifogenerator.sv
vlog fifodriver.sv
vlog fifoenvironment.sv
vlog fifotest.sv
vlog testbench.sv


#run test
vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll basetest.ucdb; run -all"

# vcover report -html basetest.ucdb