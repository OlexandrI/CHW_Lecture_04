# simulate.do
# Compare RTL outputs with the C++ reference
# OlexandrI.B

onerror {quit -code 1 -f}
if {![info exists variant]} {set variant plain}
vlib work
vlog ../hls_${variant}/max8.v
if {$variant eq "pipeline"} {
    vlog -sv +define+PIPELINED ../rtl/moving_max_ip.sv ../tests/tb_moving_max.sv
} else {
    vlog -sv ../rtl/moving_max_ip.sv ../tests/tb_moving_max.sv
}
vsim -wlf ../evidence/${variant}_simulation.wlf -voptargs=+acc work.tb_moving_max
log -r /*
run -all
if {[examine -radix unsigned /tb_moving_max/passed] != 1} {quit -code 1 -f}
quit -code 0 -f
