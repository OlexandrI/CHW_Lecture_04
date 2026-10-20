# moving_max_plain_hw.tcl
# Sliding maximum component for Platform Designer
# OlexandrI.B

package require -exact qsys 16.1
set_module_property NAME moving_max_plain
set_module_property VERSION 1.0
set_module_property AUTHOR "OlexandrI.B"
set_module_property DISPLAY_NAME "Moving maximum plain (64 x 32-bit)"
set_module_property GROUP "Homework"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
add_parameter PIPELINED BOOLEAN false
set_parameter_property PIPELINED HDL_PARAMETER true
set_parameter_property PIPELINED VISIBLE false
foreach type {QUARTUS_SYNTH SIM_VERILOG} {
    add_fileset $type $type "" ""
    set_fileset_property $type TOP_LEVEL moving_max_ip
    add_fileset_file moving_max_ip.sv SYSTEM_VERILOG PATH ../rtl/moving_max_ip.sv TOP_LEVEL_FILE
    add_fileset_file max8_plain.v VERILOG PATH ../hls_plain/max8.v
    add_fileset_file max8_pipeline.v VERILOG PATH ../hls_pipeline/max8.v
}
add_interface clock clock sink
add_interface_port clock clk clk Input 1
add_interface reset reset sink
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges NONE
add_interface_port reset rst reset Input 1
foreach {name direction} {input_stream sink output_stream source} {
    add_interface $name avalon_streaming $direction
    set_interface_property $name associatedClock clock
    set_interface_property $name associatedReset reset
    set_interface_property $name dataBitsPerSymbol 32
    set_interface_property $name symbolsPerBeat 1
    set_interface_property $name readyLatency 0
}
add_interface_port input_stream in_data data Input 32
add_interface_port input_stream in_valid valid Input 1
add_interface_port input_stream in_ready ready Output 1
add_interface_port output_stream out_data data Output 32
add_interface_port output_stream out_valid valid Output 1
add_interface control conduit end
set_interface_property control associatedClock clock
set_interface_property control associatedReset reset
foreach {port direction} {start Input busy Output done Output} {
    add_interface_port control $port $port $direction 1
}
