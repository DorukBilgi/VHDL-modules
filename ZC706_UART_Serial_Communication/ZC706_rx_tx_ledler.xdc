############## DSUB 1 - tx UART

set_property PACKAGE_PIN AE13 [get_ports iRx1_in]
set_property IOSTANDARD LVCMOS25 [get_ports iRx1_in]
set_property PACKAGE_PIN AF13 [get_ports orx1_e]
set_property IOSTANDARD LVCMOS25 [get_ports orx1_e]

set_property PACKAGE_PIN AE12 [get_ports otx1_e]
set_property IOSTANDARD LVCMOS25 [get_ports otx1_e]
set_property PACKAGE_PIN AF12 [get_ports oTx1_out]
set_property IOSTANDARD LVCMOS25 [get_ports oTx1_out]

############## DSUB 6 - rx UART

set_property PACKAGE_PIN AB29 [get_ports iRx2_in]
set_property IOSTANDARD LVCMOS25 [get_ports iRx2_in]
set_property PACKAGE_PIN AB30 [get_ports orx2_e]
set_property IOSTANDARD LVCMOS25 [get_ports orx2_e]

set_property PACKAGE_PIN Y26 [get_ports otx2_e]
set_property IOSTANDARD LVCMOS25 [get_ports otx2_e]
set_property PACKAGE_PIN Y27 [get_ports oTx2_out]
set_property IOSTANDARD LVCMOS25 [get_ports oTx2_out]

############## Differential system reference clock input ports for generating clk100, clk60

set_property PACKAGE_PIN AF14 [get_ports clk_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_p]

set_property PACKAGE_PIN AG14 [get_ports clk_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_n]

############ ETHERNET sfp_tx_p sfp_tx_n 




############## Debug ports

connect_debug_port u_ila_0/clk [get_nets [list clk156_BUFG]]
connect_debug_port dbg_hub/clk [get_nets clk156_BUFG]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_gen/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 29 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {error_counter_debug[0]} {error_counter_debug[1]} {error_counter_debug[2]} {error_counter_debug[3]} {error_counter_debug[4]} {error_counter_debug[5]} {error_counter_debug[6]} {error_counter_debug[7]} {error_counter_debug[8]} {error_counter_debug[9]} {error_counter_debug[10]} {error_counter_debug[11]} {error_counter_debug[12]} {error_counter_debug[13]} {error_counter_debug[14]} {error_counter_debug[15]} {error_counter_debug[16]} {error_counter_debug[17]} {error_counter_debug[18]} {error_counter_debug[19]} {error_counter_debug[20]} {error_counter_debug[21]} {error_counter_debug[22]} {error_counter_debug[23]} {error_counter_debug[24]} {error_counter_debug[25]} {error_counter_debug[26]} {error_counter_debug[27]} {error_counter_debug[28]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {oRx_Data_out_debug[0]} {oRx_Data_out_debug[1]} {oRx_Data_out_debug[2]} {oRx_Data_out_debug[3]} {oRx_Data_out_debug[4]} {oRx_Data_out_debug[5]} {oRx_Data_out_debug[6]} {oRx_Data_out_debug[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list iRx_in_debug]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list Rx_Busy_debug]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list Rx_Done_debug]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list clk_gen/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 8 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {Tx_Data_in_debug[0]} {Tx_Data_in_debug[1]} {Tx_Data_in_debug[2]} {Tx_Data_in_debug[3]} {Tx_Data_in_debug[4]} {Tx_Data_in_debug[5]} {Tx_Data_in_debug[6]} {Tx_Data_in_debug[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 3 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {next_state_debug[0]} {next_state_debug[1]} {next_state_debug[2]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 3 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {state_debug[0]} {state_debug[1]} {state_debug[2]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list oTx_out_debug]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list Tx_Busy_debug]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list Tx_Done_debug]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 1 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list tx_start_debug]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk100]
