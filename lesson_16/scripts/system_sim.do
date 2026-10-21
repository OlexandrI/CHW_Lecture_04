# system_sim.do
# Execute the compiled ELF on the generated Nios V system
# OlexandrI.B

onerror {quit -code 1 -f}
set QSYS_SIMDIR ../metronome_system/simulation
source $QSYS_SIMDIR/mentor/msim_setup.tcl
dev_com
com
vlog ../ip/metronome_top.v
vlog -sv ../tests/tb_system.sv
set TOP_LEVEL_NAME tb_system
set USER_DEFINED_ELAB_OPTIONS "-voptargs=+acc=npr+tb_system+metronome_top+metronome -wlf ../results/system.wlf"
elab
log /tb_system/clk /tb_system/reset_n /tb_system/tick /tb_system/firmware_status
log /tb_system/byte_offset /tb_system/write_bpm /tb_system/write_enable /tb_system/read_ticks
log /tb_system/address /tb_system/read /tb_system/write /tb_system/writedata /tb_system/readdata
log /tb_system/bpm /tb_system/enabled /tb_system/ticks /tb_system/checks /tb_system/passed
log /tb_system/writes /tb_system/reads /tb_system/events /tb_system/starts
onfinish stop
run -all
if {[examine -radix unsigned /tb_system/passed] != 1} {quit -code 1 -f}
quit -code 0 -f
