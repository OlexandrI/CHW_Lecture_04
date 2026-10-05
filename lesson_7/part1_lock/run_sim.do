# run_sim.do
# Run the project testbench
# OlexandrI.B

onerror {quit -f -code 1}
vlib work
vlog -sv digit_debounce.sv lock_controller.sv tb_lock.sv
vsim -voptargs=+acc -wlf evidence/tb_lock.wlf tb_lock
log -r /*
log /tb_lock/scenario
run -all
if {[examine -radix unsigned /tb_lock/passed] != 1} {quit -f -code 1}
quit -f -code 0
