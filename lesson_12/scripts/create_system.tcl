# create_system.tcl
# Nios V + PIO + frame receiver + mSGDMA + RAM
# OlexandrI.B

package require -exact qsys 25.1
create_system frame_system
set_project_property DEVICE_FAMILY "Cyclone V"
set_project_property DEVICE 5CEFA4F23C6
proc mm {master slave base} {
    add_connection $master $slave
    set_connection_parameter_value $master/$slave baseAddress $base
}
foreach {name frequency} {clk 50000000 pixel_clock 25000000} {
    add_instance $name clock_source
    set_instance_parameter_value $name clockFrequency $frequency
    set_instance_parameter_value $name resetSynchronousEdges DEASSERT
    add_interface $name clock sink
    set_interface_property $name EXPORT_OF $name.clk_in
    add_interface ${name}_reset reset sink
    set_interface_property ${name}_reset EXPORT_OF $name.clk_in_reset
}
add_instance cpu intel_niosv_m
set_instance_parameter_value cpu enableDebug false
set_instance_parameter_value cpu enableAvalonInterface true
set_instance_parameter_value cpu resetSlave program_ram.s1
set_instance_parameter_value cpu resetOffset 0
add_connection clk.clk cpu.clk
add_connection clk.clk_reset cpu.reset
foreach {name size init} {program_ram 32768 true frame_ram 65536 false} {
    add_instance $name altera_avalon_onchip_memory2
    set_instance_parameter_value $name memorySize $size
    set_instance_parameter_value $name dataWidth 32
    set_instance_parameter_value $name initMemContent $init
    if {$init} {
        set_instance_parameter_value $name useNonDefaultInitFile true
        set_instance_parameter_value $name initializationFileName firmware.hex
        set_instance_parameter_value $name simMemInitOnlyFilename 1
    }
    add_connection clk.clk $name.clk1
    add_connection clk.clk_reset $name.reset1
}
mm cpu.instruction_manager program_ram.s1 0x0000
mm cpu.data_manager program_ram.s1 0x0000
mm cpu.data_manager frame_ram.s1 0x20000
mm cpu.data_manager cpu.timer_sw_agent 0x11000
foreach {name width direction address} {button 1 Input 0x10000 debug 32 Output 0x10010} {
    add_instance $name altera_avalon_pio
    set_instance_parameter_value $name width $width
    set_instance_parameter_value $name direction $direction
    add_connection clk.clk $name.clk
    add_connection clk.clk_reset $name.reset
    mm cpu.data_manager $name.s1 $address
    add_interface $name conduit end
    set_interface_property $name EXPORT_OF $name.external_connection
}
add_instance receiver frame_rx_component 1.0
add_connection clk.clk receiver.clk
add_connection clk.clk_reset receiver.reset
add_connection pixel_clock.clk receiver.pixel_clk
add_connection pixel_clock.clk_reset receiver.pixel_reset
mm cpu.data_manager receiver.csr 0x10100
add_interface pixels conduit end
set_interface_property pixels EXPORT_OF receiver.pixels
add_instance dma altera_msgdma
set_instance_parameter_value dma MODE 2
set_instance_parameter_value dma DATA_WIDTH 32
set_instance_parameter_value dma MAX_BYTE 65536
set_instance_parameter_value dma DATA_FIFO_DEPTH 128
set_instance_parameter_value dma DESCRIPTOR_FIFO_DEPTH 8
set_instance_parameter_value dma PACKET_ENABLE 1
set_instance_parameter_value dma RESPONSE_PORT 0
set_instance_parameter_value dma BURST_ENABLE 0
add_connection clk.clk dma.clock
add_connection clk.clk_reset dma.reset_n
mm cpu.data_manager dma.csr 0x10020
mm cpu.data_manager dma.descriptor_slave 0x10040
mm cpu.data_manager dma.response 0x10060
mm dma.mm_write frame_ram.s1 0x20000
add_connection receiver.stream dma.st_sink
add_connection cpu.platform_irq_rx dma.csr_irq
set_connection_parameter_value cpu.platform_irq_rx/dma.csr_irq irqNumber 0
save_system frame_system.qsys
