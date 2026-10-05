create_clock -period 20.000 -name sys_clk [get_ports clk]
create_clock -period 40.000 -name pixel_clk [get_ports pixel_clk]
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks pixel_clk]
derive_clock_uncertainty
