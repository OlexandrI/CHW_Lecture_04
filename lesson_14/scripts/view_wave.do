# view_wave.do
# Five probe groups, VIO and qualified samples in Questa
# OlexandrI.B

set widget [view -undock wave]
wm geometry [winfo toplevel $widget] 1800x850
delete wave *
add wave -label clk /tb_debug/clk
add wave -label reset /tb_debug/rst
add wave -radix unsigned -label probe0_digit_4bit /tb_debug/probe0
add wave -radix unsigned -label probe1_clean_4bit /tb_debug/probe1
add wave -radix unsigned -label probe2_state_2bit /tb_debug/probe2
add wave -radix unsigned -label probe3_next_2bit /tb_debug/probe3
add wave -label probe4_unlocked_1bit /tb_debug/probe4
add wave -radix hexadecimal -label VIO_source_7bit /tb_debug/sim_source
add wave -label capture_enable /tb_debug/capture_enable
foreach signal {unlock_events qualified_samples checks} {
    add wave -radix unsigned -label $signal /tb_debug/$signal
}
add wave -label ALL_TESTS_PASSED /tb_debug/passed
configure wave -namecolwidth 310
configure wave -valuecolwidth 130
configure wave -timelineunits us
update
wave zoom full
after 1500 {wave zoom full}
