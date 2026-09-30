# sim_nios.tcl
# Compile IP and run simulation
# OlexandrI.B

onerror {quit -f -code 1}
set QSYS_SIMDIR ../nios_system/simulation
source $QSYS_SIMDIR/mentor/msim_setup.tcl
dev_com
com
vlog -sv ../../shared/input_sync.sv ../nios_top.sv ../../tests/tb_nios.sv
set TOP_LEVEL_NAME tb_nios
set USER_DEFINED_ELAB_OPTIONS "-voptargs=+acc=npr+tb_nios+nios_system -wlf ../../evidence/nios_simulation.wlf"
elab
log /tb_nios/clk /tb_nios/reset_n /tb_nios/buttons /tb_nios/direction
log /tb_nios/leds /tb_nios/debug_status /tb_nios/running /tb_nios/speed
log /tb_nios/position /tb_nios/debounced_buttons /tb_nios/timer_period
log /tb_nios/timer_running /tb_nios/timer_timeout /tb_nios/scenario
log /tb_nios/passed /tb_nios/checks /tb_nios/led_transitions
log /tb_nios/dut/soc/cpu_data_manager_address /tb_nios/dut/soc/cpu_data_manager_write
log /tb_nios/dut/soc/cpu_data_manager_read /tb_nios/dut/soc/cpu_data_manager_writedata
run -all
if {[examine -radix unsigned /tb_nios/passed] != 1} {quit -f -code 1}
quit -f -code 0
