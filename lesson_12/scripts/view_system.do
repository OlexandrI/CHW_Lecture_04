# view_system.do
# Saved full-system waveform
# OlexandrI.B

set widget [view -undock wave]
wm geometry [winfo toplevel $widget] 1800x850
delete wave *
foreach signal {clk pixel_clk reset_n button pixel_valid pixel_ready} {
    add wave -label $signal /tb_system/$signal
}
foreach signal {pixel_data debug_status axis_data dma_address dma_data} {
    add wave -radix hexadecimal -label $signal /tb_system/$signal
}
foreach signal {axis_valid axis_ready axis_last dma_write dma_wait} {
    add wave -label $signal /tb_system/$signal
}
foreach signal {frame_id dma_words receiver_words last_count cpu_writes checks} {
    add wave -radix unsigned -label $signal /tb_system/$signal
}
add wave -label ALL_TESTS_PASSED /tb_system/passed
configure wave -namecolwidth 280
configure wave -valuecolwidth 130
configure wave -timelineunits ms
wave zoom full

update
after 1500 {wave zoom full}
