# create_system.tcl
# Check both packaged IPs in Platform Designer
# OlexandrI.B

package require -exact qsys 16.1
create_system moving_max_system
set_project_property DEVICE_FAMILY {Cyclone V}
set_project_property DEVICE 5CSEMA5F31C6
add_instance clock_source clock_source
set_instance_parameter_value clock_source clockFrequency 100000000
foreach variant {plain pipeline} {
    add_instance $variant moving_max_$variant
    add_connection clock_source.clk $variant.clock
    add_connection clock_source.clk_reset $variant.reset
    foreach {iface type direction} {input_stream avalon_streaming sink output_stream avalon_streaming source control conduit end} {
        add_interface ${variant}_${iface} $type $direction
        set_interface_property ${variant}_${iface} EXPORT_OF $variant.$iface
    }
}
add_interface clock clock sink
set_interface_property clock EXPORT_OF clock_source.clk_in
add_interface reset reset sink
set_interface_property reset EXPORT_OF clock_source.clk_in_reset
save_system moving_max_system.qsys
