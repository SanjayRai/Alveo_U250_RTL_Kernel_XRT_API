-makelib ies_lib/xil_defaultlib -sv \
  "/home/applications/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/applications/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/applications/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/axi_bram_ctrl_v4_1_1 \
  "../../../../../../bd/bram_sys/ipshared/70bf/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/bram_sys/ip/bram_sys_axi_bram_ctrl_0_0/sim/bram_sys_axi_bram_ctrl_0_0.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_3 \
  "../../../../../../bd/bram_sys/ipshared/c001/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/bram_sys/ip/bram_sys_axi_bram_ctrl_0_bram_0/sim/bram_sys_axi_bram_ctrl_0_bram_0.v" \
-endlib
-makelib ies_lib/axi_lite_ipif_v3_0_4 \
  "../../../../../../bd/bram_sys/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib ies_lib/lib_cdc_v1_0_2 \
  "../../../../../../bd/bram_sys/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib ies_lib/interrupt_control_v3_1_4 \
  "../../../../../../bd/bram_sys/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib ies_lib/axi_gpio_v2_0_21 \
  "../../../../../../bd/bram_sys/ipshared/9c6e/hdl/axi_gpio_v2_0_vh_rfs.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/bram_sys/ip/bram_sys_axi_gpio_0_0/sim/bram_sys_axi_gpio_0_0.vhd" \
  "../../../bd/bram_sys/ip/bram_sys_axi_gpio_1_0/sim/bram_sys_axi_gpio_1_0.vhd" \
-endlib
-makelib ies_lib/generic_baseblocks_v2_1_0 \
  "../../../../../../bd/bram_sys/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_infrastructure_v1_1_0 \
  "../../../../../../bd/bram_sys/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_register_slice_v2_1_19 \
  "../../../../../../bd/bram_sys/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_4 \
  "../../../../../../bd/bram_sys/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_4 \
  "../../../../../../bd/bram_sys/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_4 \
  "../../../../../../bd/bram_sys/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib ies_lib/axi_data_fifo_v2_1_18 \
  "../../../../../../bd/bram_sys/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_crossbar_v2_1_20 \
  "../../../../../../bd/bram_sys/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/bram_sys/ip/bram_sys_xbar_0/sim/bram_sys_xbar_0.v" \
  "../../../bd/bram_sys/ip/bram_sys_m00_regslice_0/sim/bram_sys_m00_regslice_0.v" \
  "../../../bd/bram_sys/ip/bram_sys_fifo_generator_0_0/sim/bram_sys_fifo_generator_0_0.v" \
  "../../../bd/bram_sys/ip/bram_sys_krnl_wr_axi_lite_cmd_0/sim/bram_sys_krnl_wr_axi_lite_cmd_0.v" \
  "../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_0/sim/bd_9531_ila_lib_0.v" \
-endlib
-makelib ies_lib/gigantic_mux \
  "../../../../../../bd/bram_sys/ipshared/d322/hdl/gigantic_mux_v1_0_cntr.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_1/bd_9531_g_inst_0_gigantic_mux.v" \
  "../../../bd/bram_sys/ip/bram_sys_system_ila_0_0/bd_0/ip/ip_1/sim/bd_9531_g_inst_0.v" \
-endlib
-makelib ies_lib/xlconcat_v2_1_3 \
  "../../../../../../bd/bram_sys/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
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
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

