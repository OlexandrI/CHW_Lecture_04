# frame_rx_component_hw.tcl
# Custom receiver for Platform Designer
# OlexandrI.B

package require -exact qsys 16.1
set_module_property NAME frame_rx_component
set_module_property VERSION 1.0
set_module_property AUTHOR "OlexandrI.B"
set_module_property DESCRIPTION "Button-armed pixel capture with dual-clock FIFO"
set_module_property DISPLAY_NAME "Frame receiver (8-bit to 32-bit AXIS)"
set_module_property GROUP "Homework"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
foreach type {QUARTUS_SYNTH SIM_VERILOG} {
    add_fileset $type $type "" ""
    set_fileset_property $type TOP_LEVEL frame_rx_component
    add_fileset_file frame_rx_component.sv SYSTEM_VERILOG PATH frame_rx_component.sv TOP_LEVEL_FILE
    add_fileset_file frame_rx.sv SYSTEM_VERILOG PATH frame_rx.sv
}
foreach name {clk pixel_clk} {
    add_interface $name clock sink
    add_interface_port $name $name clk Input 1
}
foreach {name clock port} {reset clk reset_n pixel_reset pixel_clk pixel_reset_n} {
    add_interface $name reset sink
    set_interface_property $name associatedClock $clock
    set_interface_property $name synchronousEdges DEASSERT
    add_interface_port $name $port reset_n Input 1
}
add_interface csr avalon slave
set_interface_property csr associatedClock clk
set_interface_property csr associatedReset reset
set_interface_property csr addressUnits WORDS
set_interface_property csr readLatency 0
set_interface_property csr maximumPendingReadTransactions 0
foreach {port role direction width} {
    csr_address address Input 2 csr_read read Input 1 csr_write write Input 1
    csr_writedata writedata Input 32 csr_readdata readdata Output 32
} {add_interface_port csr $port $role $direction $width}
add_interface pixels conduit end
set_interface_property pixels associatedClock pixel_clk
set_interface_property pixels associatedReset pixel_reset
foreach {port direction width} {pixel_data Input 8 pixel_valid Input 1 pixel_ready Output 1} {
    add_interface_port pixels $port $port $direction $width
}
add_interface stream avalon_streaming source
set_interface_property stream associatedClock clk
set_interface_property stream associatedReset reset
set_interface_property stream dataBitsPerSymbol 8
set_interface_property stream symbolsPerBeat 4
set_interface_property stream firstSymbolInHighOrderBits true
set_interface_property stream readyLatency 0
foreach {port role direction width} {
    st_data data Output 32 st_valid valid Output 1 st_ready ready Input 1
    st_sop startofpacket Output 1 st_eop endofpacket Output 1 st_empty empty Output 2
} {add_interface_port stream $port $role $direction $width}
