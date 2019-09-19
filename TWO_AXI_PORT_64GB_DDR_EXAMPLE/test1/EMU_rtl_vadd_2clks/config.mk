VIVADO := $(XILINX_VIVADO)/bin/vivado
$(XCLBIN)/vadd.$(TARGET).$(DSA).xo: src/kernel.xml scripts/package_kernel.tcl scripts/gen_xo.tcl ../rtl_vadd_2clks/src/hdl/*.sv ../rtl_vadd_2clks/src/hdl/*.v src/hdl/*.sv
	mkdir -p $(XCLBIN)
	$(VIVADO) -mode batch -source scripts/gen_xo.tcl -tclargs $(XCLBIN)/vadd.$(TARGET).$(DSA).xo vadd $(TARGET) $(DSA)
