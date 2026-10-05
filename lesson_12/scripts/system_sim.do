# system_sim.do
# Compile real generated IP and execute the ELF memory image
# OlexandrI.B

onerror {quit -f -code 1}
set QSYS_SIMDIR ../frame_system/simulation
source $QSYS_SIMDIR/mentor/msim_setup.tcl
dev_com
com
vlog -sv ../rtl/frame_top.sv ../tests/tb_system.sv
set TOP_LEVEL_NAME tb_system
set USER_DEFINED_ELAB_OPTIONS "-voptargs=+acc=npr+tb_system+frame_system+frame_rx_component+frame_rx -wlf ../evidence/system.wlf"
elab
log /tb_system/clk /tb_system/pixel_clk /tb_system/reset_n /tb_system/button
log /tb_system/pixel_data /tb_system/pixel_valid /tb_system/pixel_ready /tb_system/debug_status
log /tb_system/axis_data /tb_system/axis_valid /tb_system/axis_ready /tb_system/axis_last
log /tb_system/dma_write /tb_system/dma_wait /tb_system/dma_address /tb_system/dma_data
log /tb_system/dma_words /tb_system/receiver_words /tb_system/last_count /tb_system/cpu_writes
log /tb_system/checks /tb_system/passed /tb_system/scenario /tb_system/frame_id
run -all
if {[examine -radix unsigned /tb_system/passed] != 1} {quit -f -code 1}
quit -f -code 0
