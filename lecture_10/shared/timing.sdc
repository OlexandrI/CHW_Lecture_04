# timing.sdc
# 50 MHz clock and external signals
# OlexandrI.B

create_clock -name fabric_clk -period 20.000 [get_ports clk]
derive_clock_uncertainty
# External controls are asynchronous and enter a two-flop synchronizer.
set_false_path -from [get_ports {buttons[*] direction reset_n}]
# Boardless compile: outputs are observation ports, not a timed external bus.
set_false_path -to [get_ports {leds[*] debug_status[*]}]
