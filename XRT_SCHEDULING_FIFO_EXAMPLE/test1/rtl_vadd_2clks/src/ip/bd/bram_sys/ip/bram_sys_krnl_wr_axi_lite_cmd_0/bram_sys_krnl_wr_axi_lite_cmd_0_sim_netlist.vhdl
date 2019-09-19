-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Fri Aug  2 14:18:51 2019
-- Host        : mcalveo running 64-bit CentOS Linux release 7.4.1708 (Core)
-- Command     : write_vhdl -force -mode funcsim
--               /home/sanjayr/projects/U250/RTL_KERNEL_STREAMING_MSFT/t4_RTL_KER_immedeate_DONE_AXIL_FIFO_SW_START_STOP_SYS_ILA/test1/rtl_vadd_2clks/src/ip/bd/bram_sys/ip/bram_sys_krnl_wr_axi_lite_cmd_0/bram_sys_krnl_wr_axi_lite_cmd_0_sim_netlist.vhdl
-- Design      : bram_sys_krnl_wr_axi_lite_cmd_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xcu250-figd2104-2L-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl is
  port (
    BVALID : out STD_LOGIC;
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC;
    WVALID : in STD_LOGIC;
    WREADY : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl : entity is "krnl_wr_axi_lite_cmd_fifo_ctrl";
end bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl;

architecture STRUCTURE of bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl is
  signal p_0_in : STD_LOGIC;
  signal r0_BVALID : STD_LOGIC;
  signal r0_BVALID0 : STD_LOGIC;
  signal r1_BVALID : STD_LOGIC;
  signal r2_BVALID : STD_LOGIC;
begin
BVALID_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => r1_BVALID,
      I1 => r2_BVALID,
      O => BVALID
    );
r0_BVALID_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ARESETN,
      O => p_0_in
    );
r0_BVALID_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => WVALID,
      I1 => WREADY,
      O => r0_BVALID0
    );
r0_BVALID_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ACLK,
      CE => '1',
      D => r0_BVALID0,
      Q => r0_BVALID,
      R => p_0_in
    );
r1_BVALID_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ACLK,
      CE => '1',
      D => r0_BVALID,
      Q => r1_BVALID,
      R => p_0_in
    );
r2_BVALID_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ACLK,
      CE => '1',
      D => r1_BVALID,
      Q => r2_BVALID,
      R => p_0_in
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bram_sys_krnl_wr_axi_lite_cmd_0 is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC;
    WVALID : in STD_LOGIC;
    WREADY : in STD_LOGIC;
    BREADY : out STD_LOGIC;
    BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    BVALID : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of bram_sys_krnl_wr_axi_lite_cmd_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of bram_sys_krnl_wr_axi_lite_cmd_0 : entity is "bram_sys_krnl_wr_axi_lite_cmd_0,krnl_wr_axi_lite_cmd_fifo_ctrl,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of bram_sys_krnl_wr_axi_lite_cmd_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of bram_sys_krnl_wr_axi_lite_cmd_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of bram_sys_krnl_wr_axi_lite_cmd_0 : entity is "krnl_wr_axi_lite_cmd_fifo_ctrl,Vivado 2019.1";
end bram_sys_krnl_wr_axi_lite_cmd_0;

architecture STRUCTURE of bram_sys_krnl_wr_axi_lite_cmd_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of ACLK : signal is "xilinx.com:signal:clock:1.0 ACLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of ACLK : signal is "XIL_INTERFACENAME ACLK, ASSOCIATED_RESET ARESETN, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN bram_sys_s_axi_aclk, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of ARESETN : signal is "xilinx.com:signal:reset:1.0 ARESETN RST";
  attribute X_INTERFACE_PARAMETER of ARESETN : signal is "XIL_INTERFACENAME ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
  BREADY <= \<const1>\;
  BRESP(1) <= \<const0>\;
  BRESP(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.bram_sys_krnl_wr_axi_lite_cmd_0_krnl_wr_axi_lite_cmd_fifo_ctrl
     port map (
      ACLK => ACLK,
      ARESETN => ARESETN,
      BVALID => BVALID,
      WREADY => WREADY,
      WVALID => WVALID
    );
end STRUCTURE;
