
foreach hw_prb [get_hw_probes pfm_top_i/dynamic_region/krnl_vadd_2clk_rtl_1/* -of_objects [get_hw_ilas -of_objects [get_hw_devices debug_bridge_0] -filter {CELL_NAME=~"pfm_top_i/dynamic_region/krnl_vadd_2clk_rtl_1/*"}]] {
    set_property NAME.SELECT short $hw_prb 
}

