# metronome_hw.tcl
# Metronome IP for Platform Designer
# OlexandrI.B

package require -exact qsys 16.1
set_module_property NAME metronome
set_module_property VERSION 1.0
set_module_property AUTHOR "OlexandrI.B"
set_module_property DISPLAY_NAME "Metronome (BPM)"
set_module_property GROUP "Course IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
add_parameter CLK_HZ INTEGER 50000000
set_parameter_property CLK_HZ HDL_PARAMETER true
set_parameter_property CLK_HZ DISPLAY_NAME "Clock frequency (Hz)"
set_parameter_property CLK_HZ ALLOWED_RANGES {1000:1000000000}
foreach type {QUARTUS_SYNTH SIM_VERILOG} {
    add_fileset $type $type "" ""
    set_fileset_property $type TOP_LEVEL metronome
    add_fileset_file metronome.v VERILOG PATH metronome.v TOP_LEVEL_FILE
}
add_interface clock clock sink
add_interface_port clock clk clk Input 1
add_interface reset reset sink
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset reset reset Input 1
add_interface csr avalon slave
set_interface_property csr associatedClock clock
set_interface_property csr associatedReset reset
set_interface_property csr addressUnits WORDS
set_interface_property csr readLatency 0
set_interface_property csr maximumPendingReadTransactions 0
foreach {port role direction width} {
    address address Input 2 read read Input 1 write write Input 1
    byteenable byteenable Input 4 writedata writedata Input 32
    readdata readdata Output 32 waitrequest waitrequest Output 1
} {add_interface_port csr $port $role $direction $width}
add_interface tick_out conduit end
set_interface_property tick_out associatedClock clock
set_interface_property tick_out associatedReset reset
add_interface_port tick_out tick export Output 1
