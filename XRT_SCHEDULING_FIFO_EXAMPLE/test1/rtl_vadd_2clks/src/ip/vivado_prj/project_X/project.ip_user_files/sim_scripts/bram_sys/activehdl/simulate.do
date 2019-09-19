onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+bram_sys -L xil_defaultlib -L xpm -L axi_bram_ctrl_v4_1_1 -L blk_mem_gen_v8_4_3 -L axi_lite_ipif_v3_0_4 -L lib_cdc_v1_0_2 -L interrupt_control_v3_1_4 -L axi_gpio_v2_0_21 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_19 -L fifo_generator_v13_2_4 -L axi_data_fifo_v2_1_18 -L axi_crossbar_v2_1_20 -L gigantic_mux -L xlconcat_v2_1_3 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.bram_sys xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {bram_sys.udo}

run -all

endsim

quit -force
