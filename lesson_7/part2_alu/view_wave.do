# view_wave.do
# Show saved testbench signals
# OlexandrI.B

set widget [view -undock wave]
wm geometry [winfo toplevel $widget] 1800x850
delete wave *
add wave -label clk /tb_alu/clk
add wave -label rst /tb_alu/rst
add wave -radix unsigned -label a /tb_alu/a
add wave -radix unsigned -label b /tb_alu/b
add wave -radix binary -label op_00_ADD_01_SUB_10_AND_11_OR /tb_alu/op
add wave -label oe /tb_alu/oe
add wave -radix unsigned -label a_reg /tb_alu/dut/a_reg
add wave -radix unsigned -label b_reg /tb_alu/dut/b_reg
add wave -radix binary -label op_reg /tb_alu/dut/op_reg
add wave -label oe_reg /tb_alu/dut/oe_reg
add wave -radix unsigned -label result /tb_alu/result
add wave -radix unsigned -label checks /tb_alu/checks
add wave -label ALL_TESTS_PASSED /tb_alu/passed
configure wave -namecolwidth 330
configure wave -valuecolwidth 130
configure wave -timelineunits ns
update
wave zoom full
after 1500 {wave zoom full}
