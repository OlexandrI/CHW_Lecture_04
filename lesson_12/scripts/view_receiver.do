# view_receiver.do
# Saved receiver waveform, FIFO full and AXIS backpressure
# OlexandrI.B

set widget [view -undock wave]
wm geometry [winfo toplevel $widget] 1800x850
delete wave *
foreach signal {scenario clk pixel_clk reset_n start pixel_valid pixel_ready busy} {
    add wave -label $signal /tb_frame_rx/$signal
}
add wave -radix hexadecimal -label pixel_data /tb_frame_rx/pixel_data
add wave -label FIFO_FULL /tb_frame_rx/dut/full
add wave -label AXIS_VALID /tb_frame_rx/m_axis_tvalid
add wave -label AXIS_READY /tb_frame_rx/m_axis_tready
add wave -radix hexadecimal -label AXIS_DATA /tb_frame_rx/m_axis_tdata
add wave -label TLAST /tb_frame_rx/m_axis_tlast
foreach signal {received stalls checks} {add wave -radix unsigned -label $signal /tb_frame_rx/$signal}
add wave -label ALL_TESTS_PASSED /tb_frame_rx/passed
configure wave -namecolwidth 280
configure wave -valuecolwidth 130
configure wave -timelineunits us
wave zoom range 0ns 6500ns

update
after 1500 {wave zoom range 0ns 6500ns}
