# simulate_array.do
# Simulate RTL generated from the complete array function
# OlexandrI.B

onerror {quit -code 1 -f}
vlib work
vlog ../array_hls/moving_max.v ../tests/tb_array.v
vsim -wlf ../evidence/array_simulation.wlf -voptargs=+acc work.tb_array
log -r /*
run -all
if {[examine -radix unsigned /tb_array/passed] != 1} {quit -code 1 -f}
quit -code 0 -f
