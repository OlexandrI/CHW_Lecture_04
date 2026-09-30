# create_systems.tcl
# Create HPS and Nios V systems
# OlexandrI.B

package require -exact qsys 25.1
set root [pwd]
# Run from lecture_10. Both systems deliberately use the same peripheral map.
proc wire_mm {master slave base} {
    add_connection $master $slave
    set_connection_parameter_value $master/$slave baseAddress $base
}
proc peripherals {master} {
    foreach {name width direction address} {
        leds 4 Output 0x10000
        buttons 4 Input 0x10010
        switches 1 Input 0x10020
        debug 32 Output 0x10080
    } {
        add_instance $name altera_avalon_pio
        set_instance_parameter_value $name width $width
        set_instance_parameter_value $name direction $direction
        set_instance_parameter_value $name resetValue 0
        add_connection clk.clk $name.clk
        add_connection clk.clk_reset $name.reset
        wire_mm $master $name.s1 $address
        add_interface $name conduit end
        set_interface_property $name EXPORT_OF $name.external_connection
    }
    foreach {name address period} {move_timer 0x10040 25000000 scan_timer 0x10060 50000} {
        add_instance $name altera_avalon_timer
        set_instance_parameter_value $name periodUnits CLOCKS
        set_instance_parameter_value $name period $period
        set_instance_parameter_value $name fixedPeriod false
        set_instance_parameter_value $name alwaysRun false
        set_instance_parameter_value $name snapshot true
        add_connection clk.clk $name.clk
        add_connection clk.clk_reset $name.reset
        wire_mm $master $name.s1 $address
    }
}
proc base_system {name} {
    create_system $name
    set_project_property DEVICE_FAMILY "Cyclone V"
    set_project_property DEVICE 5CSEMA5F31C6
    add_instance clk clock_source
    set_instance_parameter_value clk clockFrequency 50000000
    set_instance_parameter_value clk resetSynchronousEdges DEASSERT
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk.clk_in
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF clk.clk_in_reset
}
base_system nios_system
add_instance cpu intel_niosv_m
set_instance_parameter_value cpu enableDebug false
set_instance_parameter_value cpu enableAvalonInterface true
set_instance_parameter_value cpu resetSlave ram.s1
set_instance_parameter_value cpu resetOffset 0
add_connection clk.clk cpu.clk
add_connection clk.clk_reset cpu.reset
add_instance ram altera_avalon_onchip_memory2
set_instance_parameter_value ram memorySize 32768
set_instance_parameter_value ram dataWidth 32
set_instance_parameter_value ram initMemContent true
set_instance_parameter_value ram useNonDefaultInitFile true
set_instance_parameter_value ram initializationFileName firmware.hex
set_instance_parameter_value ram simMemInitOnlyFilename 1
add_connection clk.clk ram.clk1
add_connection clk.clk_reset ram.reset1
wire_mm cpu.instruction_manager ram.s1 0x0000
wire_mm cpu.data_manager ram.s1 0x0000
wire_mm cpu.data_manager cpu.timer_sw_agent 0x11000
peripherals cpu.data_manager
add_connection cpu.platform_irq_rx move_timer.irq
set_connection_parameter_value cpu.platform_irq_rx/move_timer.irq irqNumber 0
add_connection cpu.platform_irq_rx scan_timer.irq
set_connection_parameter_value cpu.platform_irq_rx/scan_timer.irq irqNumber 1
save_system [file join $root task2_nios nios_system.qsys]

base_system hps_system
add_instance hps altera_hps
set_instance_parameter_value hps F2S_Width 0
set_instance_parameter_value hps S2F_Width 0
set_instance_parameter_value hps LWH2F_Enable true
set_instance_parameter_value hps F2SDRAM_Type {}
set_instance_parameter_value hps F2SDRAM_Width {}
set_instance_parameter_value hps MPU_EVENTS_Enable false
add_connection clk.clk hps.h2f_lw_axi_clock
peripherals hps.h2f_lw_axi_master
# DDR is exported for completeness; the application links into HPS on-chip RAM.
add_interface memory conduit end
set_interface_property memory EXPORT_OF hps.memory
save_system [file join $root task1_hps hps_system.qsys]
