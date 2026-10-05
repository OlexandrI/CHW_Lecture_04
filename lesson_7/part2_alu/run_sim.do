# run_sim.do
# Run the project testbench
# OlexandrI.B

onerror {quit -f -code 1}
vlib work
vlog -sv alu.sv tb_alu.sv
vsim -voptargs=+acc -wlf evidence/tb_alu.wlf tb_alu
log -r /*
run -all
if {[examine -radix unsigned /tb_alu/passed] != 1} {quit -f -code 1}
quit -f -code 0
