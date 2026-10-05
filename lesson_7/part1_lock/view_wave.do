# view_wave.do
# Show saved testbench signals
# OlexandrI.B

set widget [view -undock wave]
wm geometry [winfo toplevel $widget] 1800x850
delete wave *
add wave -label scenario /tb_lock/scenario
add wave -label clk /tb_lock/clk
add wave -label rst /tb_lock/rst
add wave -radix unsigned -label digit_in /tb_lock/digit_in
add wave -radix unsigned -label digit_clean /tb_lock/dut/digit_clean
add wave -radix unsigned -label state /tb_lock/dut/state
add wave -radix unsigned -label next_state /tb_lock/dut/next_state
add wave -label unlocked_led /tb_lock/unlocked_led
add wave -radix unsigned -label checks /tb_lock/checks
add wave -label ALL_TESTS_PASSED /tb_lock/passed
configure wave -namecolwidth 330
configure wave -valuecolwidth 130
configure wave -timelineunits us
update
wave zoom full
after 1500 {wave zoom full}
