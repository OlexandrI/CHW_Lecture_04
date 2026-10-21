# unit_sim.do
# Run the same testbench on the good or broken module
# OlexandrI.B

onerror {quit -code 1 -f}
if {![info exists broken]} {set broken 0}
vlib work
if {$broken} {
    vlog +define+BUGGY ../tests/metronome_bug.v ../tests/tb_metronome.v
} else {
    vlog ../ip/metronome.v ../tests/tb_metronome.v
}
set wf ../results/unit_pass.wlf
if {$broken} {set wf ../results/unit_fail.wlf}
vsim -voptargs=+acc -wlf $wf work.tb_metronome
log -r /*
onfinish stop
run -all
if {[examine -radix unsigned /tb_metronome/passed] != 1} {quit -code 1 -f}
quit -code 0 -f
