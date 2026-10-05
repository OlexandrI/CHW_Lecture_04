# run_sim.do
# Run the project testbench
# OlexandrI.B

onerror {quit -f -code 1}
vlib work
vlog -sv ../part3_plain/expr_plain.sv expr_pipelined.sv tb_expr.sv
vsim -voptargs=+acc -wlf evidence/tb_expr.wlf tb_expr
log -r /*
run -all
if {[examine -radix unsigned /tb_expr/passed] != 1} {quit -f -code 1}
quit -f -code 0
