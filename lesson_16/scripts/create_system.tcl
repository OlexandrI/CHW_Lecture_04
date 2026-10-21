# create_system.tcl
# Nios V/m, program RAM and metronome registers
# OlexandrI.B

package require -exact qsys 25.1
create_system metronome_system
set_project_property DEVICE_FAMILY "Cyclone V"
set_project_property DEVICE 5CEFA4F23C6
proc mm {master slave base} {
    add_connection $master $slave
    set_connection_parameter_value $master/$slave baseAddress $base
}
add_instance clk clock_source
set_instance_parameter_value clk clockFrequency 50000000
set_instance_parameter_value clk resetSynchronousEdges DEASSERT
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk.clk_in
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk.clk_in_reset
add_instance cpu intel_niosv_m
set_instance_parameter_value cpu enableDebug false
set_instance_parameter_value cpu enableAvalonInterface true
set_instance_parameter_value cpu resetSlave program_ram.s1
set_instance_parameter_value cpu resetOffset 0
add_connection clk.clk cpu.clk
add_connection clk.clk_reset cpu.reset
add_instance program_ram altera_avalon_onchip_memory2
set_instance_parameter_value program_ram memorySize 32768
set_instance_parameter_value program_ram dataWidth 32
set_instance_parameter_value program_ram initMemContent true
set_instance_parameter_value program_ram useNonDefaultInitFile true
set_instance_parameter_value program_ram initializationFileName firmware.hex
set_instance_parameter_value program_ram simMemInitOnlyFilename 1
add_connection clk.clk program_ram.clk1
add_connection clk.clk_reset program_ram.reset1
mm cpu.instruction_manager program_ram.s1 0x0000
mm cpu.data_manager program_ram.s1 0x0000
mm cpu.data_manager cpu.timer_sw_agent 0x11000
add_instance metro metronome 1.0
set_instance_parameter_value metro CLK_HZ 50000000
add_connection clk.clk metro.clock
add_connection clk.clk_reset metro.reset
mm cpu.data_manager metro.csr 0x10000
add_interface tick conduit end
set_interface_property tick EXPORT_OF metro.tick_out
add_instance status altera_avalon_pio
set_instance_parameter_value status width 32
set_instance_parameter_value status direction Output
add_connection clk.clk status.clk
add_connection clk.clk_reset status.reset
mm cpu.data_manager status.s1 0x10010
add_interface status conduit end
set_interface_property status EXPORT_OF status.external_connection
save_system metronome_system.qsys
