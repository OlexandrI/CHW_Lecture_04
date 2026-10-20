# simulate.do
# Compile debug IP and run the testbench
# OlexandrI.B

onerror {quit -f -code 1}
exec python3 ../scripts/prepare_simulation.py
set QSYS_SIMDIR ../debug_ip/simulation
source $QSYS_SIMDIR/mentor/msim_setup.tcl
dev_com
com
vlog -sv ../rtl/digit_debounce.sv ../rtl/lock_controller.sv ../rtl/ila_0.sv ../rtl/debug_top.sv ../tests/tb_debug.sv
set TOP_LEVEL_NAME tb_debug
set USER_DEFINED_ELAB_OPTIONS "-voptargs=+acc -wlf ../evidence/debug_simulation.wlf"
elab
log -r /tb_debug/*
log /tb_debug/scenario
run -all
if {[examine -radix unsigned /tb_debug/passed] != 1} {quit -f -code 1}
quit -f -code 0
