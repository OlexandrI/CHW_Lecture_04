# view_array.do
# RAM accesses and results of the full array function
# OlexandrI.B

view wave
delete wave *
configure wave -namecolwidth 180 -valuecolwidth 100 -timelineunits ns
add wave /tb_array/clock /tb_array/reset /tb_array/start_port /tb_array/done_port
add wave -radix unsigned /tb_array/in_address0 /tb_array/out_address0
add wave /tb_array/in_ce0 /tb_array/out_we0
add wave -radix decimal /tb_array/in_q0 /tb_array/out_d0
add wave -radix unsigned /tb_array/frame /tb_array/reads /tb_array/writes /tb_array/checks
add wave /tb_array/passed
wave zoom full
