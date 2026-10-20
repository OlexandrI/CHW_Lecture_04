# view_stream.do
# Inputs, outputs and test result
# OlexandrI.B

view wave
delete wave *
configure wave -namecolwidth 180 -valuecolwidth 100 -timelineunits ns
add wave -divider {Frame control}
add wave /tb_moving_max/clk /tb_moving_max/rst /tb_moving_max/start
add wave /tb_moving_max/in_valid /tb_moving_max/in_ready /tb_moving_max/out_valid
add wave /tb_moving_max/busy /tb_moving_max/done
add wave -divider {Signed samples}
add wave -radix decimal /tb_moving_max/in_data /tb_moving_max/out_data
add wave -divider {Checks}
add wave -radix unsigned /tb_moving_max/frame /tb_moving_max/sent /tb_moving_max/received
add wave -radix unsigned /tb_moving_max/checks /tb_moving_max/min_ii /tb_moving_max/max_ii
add wave /tb_moving_max/passed
wave zoom full
