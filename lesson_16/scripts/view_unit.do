# view_unit.do
# Register access and tick pulses
# OlexandrI.B

view wave
delete wave *
configure wave -namecolwidth 210 -valuecolwidth 100 -timelineunits ms
add wave /tb_metronome/clk /tb_metronome/reset
add wave -radix unsigned /tb_metronome/scenario
add wave /tb_metronome/write /tb_metronome/read
add wave -radix hexadecimal /tb_metronome/address
add wave -radix unsigned /tb_metronome/writedata /tb_metronome/readdata
add wave /tb_metronome/tick
add wave -radix unsigned /tb_metronome/dut/bpm /tb_metronome/dut/counter /tb_metronome/dut/ticks
add wave -radix unsigned /tb_metronome/checks
add wave /tb_metronome/passed
wave zoom full
