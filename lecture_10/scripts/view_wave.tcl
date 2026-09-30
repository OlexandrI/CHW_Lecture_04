# view_wave.tcl
# Waveform signals and layout
# OlexandrI.B

set wave_widget [view -undock wave]
wm geometry [winfo toplevel $wave_widget] 1900x850
delete wave *
add wave -divider {ELF execution: Nios V/m on Cyclone V}
add wave -label scenario /tb_nios/scenario
add wave -label reset_n /tb_nios/reset_n
add wave -radix binary -label {buttons [resume stop slower faster]} /tb_nios/buttons
add wave -radix binary -label debounced_buttons /tb_nios/debounced_buttons
add wave -label direction_reverse /tb_nios/direction
add wave -divider {CPU-controlled outputs}
add wave -radix binary -label LED3_LED2_LED1_LED0 /tb_nios/leds
add wave -radix unsigned -label led_position /tb_nios/position
add wave -radix unsigned -label speed_index /tb_nios/speed
add wave -label running /tb_nios/running
add wave -divider {Real Avalon interval timer}
add wave -radix unsigned -label period_in_50MHz_clocks /tb_nios/timer_period
add wave -label timer_running /tb_nios/timer_running
add wave -label timeout_flag /tb_nios/timer_timeout
add wave -divider {Self-checking testbench}
add wave -radix unsigned -label assertions_passed /tb_nios/checks
add wave -label ALL_TESTS_PASSED /tb_nios/passed
configure wave -namecolwidth 345
configure wave -valuecolwidth 145
configure wave -timelineunits ms
configure wave -rowmargin 7
update
wave zoom full
after 1500 {wave zoom full}
