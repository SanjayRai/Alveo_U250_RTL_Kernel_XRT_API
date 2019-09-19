-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Fri Aug  2 14:18:51 2019
-- Host        : mcalveo running 64-bit CentOS Linux release 7.4.1708 (Core)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/sanjayr/projects/U250/RTL_KERNEL_STREAMING_MSFT/t4_RTL_KER_immedeate_DONE_AXIL_FIFO_SW_START_STOP_SYS_ILA/test1/rtl_vadd_2clks/src/ip/bd/bram_sys/ip/bram_sys_krnl_wr_axi_lite_cmd_0/bram_sys_krnl_wr_axi_lite_cmd_0_stub.vhdl
-- Design      : bram_sys_krnl_wr_axi_lite_cmd_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcu250-figd2104-2L-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bram_sys_krnl_wr_axi_lite_cmd_0 is
  Port ( 
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC;
    WVALID : in STD_LOGIC;
    WREADY : in STD_LOGIC;
    BREADY : out STD_LOGIC;
    BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    BVALID : out STD_LOGIC
  );

end bram_sys_krnl_wr_axi_lite_cmd_0;

architecture stub of bram_sys_krnl_wr_axi_lite_cmd_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ACLK,ARESETN,WVALID,WREADY,BREADY,BRESP[1:0],BVALID";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "krnl_wr_axi_lite_cmd_fifo_ctrl,Vivado 2019.1";
begin
end;
