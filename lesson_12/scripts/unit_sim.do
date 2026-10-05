# unit_sim.do
# Test the receiver independently of the processor
# OlexandrI.B

onerror {quit -f -code 1}
vlib work
vlog -sv ../rtl/frame_rx.sv ../tests/tb_frame_rx.sv
vsim -L altera_mf_ver -voptargs=+acc -wlf ../evidence/receiver.wlf tb_frame_rx
log -r /*
log /tb_frame_rx/scenario
run -all
if {[examine -radix unsigned /tb_frame_rx/passed] != 1} {quit -f -code 1}
quit -f -code 0
