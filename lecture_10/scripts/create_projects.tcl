# create_projects.tcl
# Create Quartus projects for Cyclone V
# OlexandrI.B

package require ::quartus::project
set root [file normalize [file join [file dirname [info script]] ..]]
foreach {directory project top} {task1_hps hps_chaser hps_top task2_nios nios_chaser nios_top} {
    cd [file join $root $directory]
    project_new $project -overwrite
    set_global_assignment -name FAMILY "Cyclone V"
    set_global_assignment -name DEVICE 5CSEMA5F31C6
    set_global_assignment -name TOP_LEVEL_ENTITY $top
    set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
    set_global_assignment -name NUM_PARALLEL_PROCESSORS 4
    set_global_assignment -name SYSTEMVERILOG_FILE ../shared/input_sync.sv
    set_global_assignment -name SYSTEMVERILOG_FILE $top.sv
    if {$directory eq "task1_hps"} {
        set_global_assignment -name QIP_FILE hps_system/synthesis/hps_system.qip
    } else {
        set_global_assignment -name QIP_FILE nios_system/synthesis/nios_system.qip
    }
    set_global_assignment -name SDC_FILE ../shared/timing.sdc
    set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
    # No board is attached. Do not pretend arbitrary pins describe a real board.
    foreach port {buttons[*] direction leds[*] debug_status[*]} {
        set_instance_assignment -name VIRTUAL_PIN ON -to $port
    }
    export_assignments
    project_close
}
