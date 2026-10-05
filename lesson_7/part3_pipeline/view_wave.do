# view_wave.do
# Show saved testbench signals
# OlexandrI.B

set widget [view -undock wave]
wm geometry [winfo toplevel $widget] 1800x850
delete wave *
add wave -label clk_8_75ns /tb_expr/clk
add wave -radix unsigned -label a /tb_expr/a
add wave -radix unsigned -label b /tb_expr/b
add wave -radix unsigned -label c /tb_expr/c
add wave -radix unsigned -label d /tb_expr/d
add wave -radix hexadecimal -label plain_2_stages /tb_expr/result_plain
add wave -radix hexadecimal -label expected_plain /tb_expr/expected2
add wave -radix hexadecimal -label pipeline_3_stages /tb_expr/result_pipeline
add wave -radix hexadecimal -label expected_pipeline /tb_expr/expected3
add wave -radix unsigned -label checks /tb_expr/checks
add wave -label ALL_TESTS_PASSED /tb_expr/passed
configure wave -namecolwidth 330
configure wave -valuecolwidth 130
configure wave -timelineunits ns
update
wave zoom full
after 1500 {wave zoom full}
