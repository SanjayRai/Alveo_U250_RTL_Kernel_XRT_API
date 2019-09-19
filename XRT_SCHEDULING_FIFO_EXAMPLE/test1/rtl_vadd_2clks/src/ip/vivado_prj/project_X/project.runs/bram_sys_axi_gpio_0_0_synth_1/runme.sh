#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/applications/SDK/2019.1/bin:/home/applications/Vivado/2019.1/ids_lite/ISE/bin/lin64:/home/applications/Vivado/2019.1/bin
else
  PATH=/home/applications/SDK/2019.1/bin:/home/applications/Vivado/2019.1/ids_lite/ISE/bin/lin64:/home/applications/Vivado/2019.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/sanjayr/projects/U250/RTL_KERNEL_STREAMING_MSFT/t4_RTL_KER_immedeate_DONE_AXIL_FIFO_SW_START_STOP_SYS_ILA/test1/rtl_vadd_2clks/src/ip/vivado_prj/project_X/project.runs/bram_sys_axi_gpio_0_0_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log bram_sys_axi_gpio_0_0.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source bram_sys_axi_gpio_0_0.tcl
