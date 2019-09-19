vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/axi_bram_ctrl_v4_1_1
vlib modelsim_lib/msim/blk_mem_gen_v8_4_3
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/interrupt_control_v3_1_4
vlib modelsim_lib/msim/axi_gpio_v2_0_21
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_19
vlib modelsim_lib/msim/fifo_generator_v13_2_4
vlib modelsim_lib/msim/axi_data_fifo_v2_1_18
vlib modelsim_lib/msim/axi_crossbar_v2_1_20
vlib modelsim_lib/msim/gigantic_mux
vlib modelsim_lib/msim/xlconcat_v2_1_3

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap axi_bram_ctrl_v4_1_1 modelsim_lib/msim/axi_bram_ctrl_v4_1_1
vmap blk_mem_gen_v8_4_3 modelsim_lib/msim/blk_mem_gen_v8_4_3
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap interrupt_control_v3_1_4 modelsim_lib/msim/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_21 modelsim_lib/msim/axi_gpio_v2_0_21
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_19 modelsim_lib/msim/axi_register_slice_v2_1_19
vmap fifo_generator_v13_2_4 modelsim_lib/msim/fifo_generator_v13_2_4
vmap axi_data_fifo_v2_1_18 modelsim_lib/msim/axi_data_fifo_v2_1_18
vmap axi_crossbar_v2_1_20 modelsim_lib/msim/axi_crossbar_v2_1_20
vmap gigantic_mux modelsim_lib/msim/gigantic_mux
vmap xlconcat_v2_1_3 modelsim_lib/msim/xlconcat_v2_1_3

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"/home/applications/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/applications/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/applications/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work axi_bram_ctrl_v4_1_1 -64 -93 \
"../../../../../../bd/bram_sys/ipshared/70bf/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/bram_sys/ip/bram_sys_axi_bram_ctrl_0_0/sim/bram_sys_axi_bram_ctrl_0_0.vhd" \

vlog -work blk_mem_gen_v8_4_3 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/c001/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../bd/bram_sys/ip/bram_sys_axi_bram_ctrl_0_bram_0/sim/bram_sys_axi_bram_ctrl_0_bram_0.v" \

vcom -work axi_lite_ipif_v3_0_4 -64 -93 \
"../../../../../../bd/bram_sys/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../../../bd/bram_sys/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_4 -64 -93 \
"../../../../../../bd/bram_sys/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_21 -64 -93 \
"../../../../../../bd/bram_sys/ipshared/9c6e/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/bram_sys/ip/bram_sys_axi_gpio_0_0/sim/bram_sys_axi_gpio_0_0.vhd" \
"../../../bd/bram_sys/ip/bram_sys_axi_gpio_1_0/sim/bram_sys_axi_gpio_1_0.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_19 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -64 -93 \
"../../../../../../bd/bram_sys/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_18 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_20 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../bd/bram_sys/ip/bram_sys_xbar_0/sim/bram_sys_xbar_0.v" \
"../../../bd/bram_sys/ip/bram_sys_m00_regslice_0/sim/bram_sys_m00_regslice_0.v" \
"../../../bd/bram_sys/ip/bram_sys_fifo_generator_0_0/sim/bram_sys_fifo_generator_0_0.v" \
"../../../bd/bram_sys/ip/bram_sys_krnl_wr_axi_lite_cmd_0/sim/bram_sys_krnl_wr_axi_lite_cmd_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_0/sim/bd_9531_ila_lib_0.v" \

vlog -work gigantic_mux -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/d322/hdl/gigantic_mux_v1_0_cntr.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_1/bd_9531_g_inst_0_gigantic_mux.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_1/sim/bd_9531_g_inst_0.v" \

vlog -work xlconcat_v2_1_3 -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../../../../bd/bram_sys/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../../../bd/bram_sys/ipshared/ec67/hdl" "+incdir+../../../../../../bd/bram_sys/ipshared/1b7e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/122e/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/6887/hdl/verilog" "+incdir+../../../../../../bd/bram_sys/ipshared/9623/hdl/verilog" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_2/sim/bd_9531_slot_0_aw_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_3/sim/bd_9531_slot_0_w_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_4/sim/bd_9531_slot_0_b_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_5/sim/bd_9531_slot_0_ar_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_6/sim/bd_9531_slot_0_r_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/sim/bd_9531.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/sim/bram_sys_system_ila_0_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_0/sim/bd_5560_ila_lib_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_1/bd_5560_g_inst_0_gigantic_mux.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_1/sim/bd_5560_g_inst_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_2/sim/bd_5560_slot_0_aw_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_3/sim/bd_5560_slot_0_w_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_4/sim/bd_5560_slot_0_b_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_5/sim/bd_5560_slot_0_ar_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/ip/ip_6/sim/bd_5560_slot_0_r_0.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/bd_0/sim/bd_5560.v" \
"../../../bd/bram_sys/ip/bram_sys_system_ila_1_0/sim/bram_sys_system_ila_1_0.v" \
"../../../bd/bram_sys/sim/bram_sys.v" \

vlog -work xil_defaultlib \
"glbl.v"

