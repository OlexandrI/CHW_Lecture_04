# view_system.do
# CPU MMIO transactions and metronome response
# OlexandrI.B

view wave
delete wave *
configure wave -namecolwidth 210 -valuecolwidth 100 -timelineunits us
add wave /tb_system/clk /tb_system/reset_n
add wave -divider {Nios V register access}
add wave /tb_system/write_bpm /tb_system/write_enable /tb_system/read_ticks
add wave /tb_system/write /tb_system/read
add wave -radix hexadecimal /tb_system/byte_offset
add wave -radix unsigned /tb_system/writedata /tb_system/readdata
add wave -divider {Metronome}
add wave -radix unsigned /tb_system/bpm
add wave /tb_system/enabled /tb_system/tick
add wave -radix unsigned /tb_system/ticks
add wave -divider {Checks}
add wave -radix hexadecimal /tb_system/firmware_status
add wave -radix unsigned /tb_system/writes /tb_system/reads /tb_system/events /tb_system/checks
add wave /tb_system/passed
wave zoom full
