--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
--Date        : Thu Nov 13 20:25:43 2025
--Host        : wfort-Laptop-13-Intel-Core-Ultra-Series-1 running 64-bit Ubuntu 24.04.3 LTS
--Command     : generate_target P2_BD_pongIP_S2026.bd
--Design      : P2_BD_pongIP_S2026
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Debounce_imp_K0Q0PB is
  port (
    i_Clk : in STD_LOGIC;
    i_Switch_0 : in STD_LOGIC;
    i_Switch_1 : in STD_LOGIC;
    i_Switch_2 : in STD_LOGIC;
    i_Switch_3 : in STD_LOGIC;
    i_Switch_4 : in STD_LOGIC;
    o_Switch0 : out STD_LOGIC;
    o_Switch1 : out STD_LOGIC;
    o_Switch2 : out STD_LOGIC;
    o_Switch3 : out STD_LOGIC;
    o_Switch4 : out STD_LOGIC
  );
end Debounce_imp_K0Q0PB;

architecture STRUCTURE of Debounce_imp_K0Q0PB is
  component P2_BD_pongIP_S2026_Debounce_Switch_3_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_Switch : in STD_LOGIC;
    o_Switch : out STD_LOGIC
  );
  end component P2_BD_pongIP_S2026_Debounce_Switch_3_0;
  component P2_BD_pongIP_S2026_Debounce_Switch_4_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_Switch : in STD_LOGIC;
    o_Switch : out STD_LOGIC
  );
  end component P2_BD_pongIP_S2026_Debounce_Switch_4_0;
  component P2_BD_pongIP_S2026_Debounce_Switch_0_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_Switch : in STD_LOGIC;
    o_Switch : out STD_LOGIC
  );
  end component P2_BD_pongIP_S2026_Debounce_Switch_0_0;
  component P2_BD_pongIP_S2026_Debounce_Switch_2_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_Switch : in STD_LOGIC;
    o_Switch : out STD_LOGIC
  );
  end component P2_BD_pongIP_S2026_Debounce_Switch_2_0;
  component P2_BD_pongIP_S2026_Debounce_Switch_1_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_Switch : in STD_LOGIC;
    o_Switch : out STD_LOGIC
  );
  end component P2_BD_pongIP_S2026_Debounce_Switch_1_0;
begin
Debounce_Switch_0: component P2_BD_pongIP_S2026_Debounce_Switch_0_0
     port map (
      i_Clk => i_Clk,
      i_Switch => i_Switch_1,
      o_Switch => o_Switch1
    );
Debounce_Switch_1: component P2_BD_pongIP_S2026_Debounce_Switch_1_0
     port map (
      i_Clk => i_Clk,
      i_Switch => i_Switch_0,
      o_Switch => o_Switch0
    );
Debounce_Switch_2: component P2_BD_pongIP_S2026_Debounce_Switch_2_0
     port map (
      i_Clk => i_Clk,
      i_Switch => i_Switch_3,
      o_Switch => o_Switch3
    );
Debounce_Switch_3: component P2_BD_pongIP_S2026_Debounce_Switch_3_0
     port map (
      i_Clk => i_Clk,
      i_Switch => i_Switch_2,
      o_Switch => o_Switch2
    );
Debounce_Switch_4: component P2_BD_pongIP_S2026_Debounce_Switch_4_0
     port map (
      i_Clk => i_Clk,
      i_Switch => i_Switch_4,
      o_Switch => o_Switch4
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity VGA_imp_33E8YF is
  port (
    i_Blu_Video : in STD_LOGIC_VECTOR ( 2 downto 0 );
    i_Clk : in STD_LOGIC;
    i_Grn_Video : in STD_LOGIC_VECTOR ( 2 downto 0 );
    i_Red_Video : in STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Blu_Video_0 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Col_Count : out STD_LOGIC_VECTOR ( 9 downto 0 );
    o_Grn_Video_0 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_HSync_0 : out STD_LOGIC;
    o_Red_Video_0 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Row_Count : out STD_LOGIC_VECTOR ( 9 downto 0 );
    o_VSync_0 : out STD_LOGIC;
    o_vde : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
end VGA_imp_33E8YF;

architecture STRUCTURE of VGA_imp_33E8YF is
  component P2_BD_pongIP_S2026_Sync_To_Count2_0_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_HSync : in STD_LOGIC;
    i_VSync : in STD_LOGIC;
    o_HSync : out STD_LOGIC;
    o_VSync : out STD_LOGIC;
    o_Col_Count : out STD_LOGIC_VECTOR ( 9 downto 0 );
    o_Row_Count : out STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  end component P2_BD_pongIP_S2026_Sync_To_Count2_0_0;
  component P2_BD_pongIP_S2026_VGA_Sync_Porch_0_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_HSync : in STD_LOGIC;
    i_VSync : in STD_LOGIC;
    i_Red_Video : in STD_LOGIC_VECTOR ( 2 downto 0 );
    i_Grn_Video : in STD_LOGIC_VECTOR ( 2 downto 0 );
    i_Blu_Video : in STD_LOGIC_VECTOR ( 2 downto 0 );
    o_HSync : out STD_LOGIC;
    o_VSync : out STD_LOGIC;
    o_Red_Video : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Grn_Video : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Blu_Video : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component P2_BD_pongIP_S2026_VGA_Sync_Porch_0_0;
  component P2_BD_pongIP_S2026_VGA_Sync_Pulses_0_0 is
  port (
    i_Clk : in STD_LOGIC;
    o_HSync : out STD_LOGIC;
    o_VSync : out STD_LOGIC;
    o_Col_Count : out STD_LOGIC_VECTOR ( 9 downto 0 );
    o_Row_Count : out STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  end component P2_BD_pongIP_S2026_VGA_Sync_Pulses_0_0;
  signal Sync_To_Count2_0_o_HSync : STD_LOGIC;
  signal Sync_To_Count2_0_o_VSync : STD_LOGIC;
  signal VGA_Sync_Pulses_0_o_HSync : STD_LOGIC;
  signal VGA_Sync_Pulses_0_o_VSync : STD_LOGIC;
  signal NLW_VGA_Sync_Pulses_0_o_Col_Count_UNCONNECTED : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal NLW_VGA_Sync_Pulses_0_o_Row_Count_UNCONNECTED : STD_LOGIC_VECTOR ( 9 downto 0 );
begin
Sync_To_Count2_0: component P2_BD_pongIP_S2026_Sync_To_Count2_0_0
     port map (
      i_Clk => i_Clk,
      i_HSync => VGA_Sync_Pulses_0_o_HSync,
      i_VSync => VGA_Sync_Pulses_0_o_VSync,
      o_Col_Count(9 downto 0) => o_Col_Count(9 downto 0),
      o_HSync => Sync_To_Count2_0_o_HSync,
      o_Row_Count(9 downto 0) => o_Row_Count(9 downto 0),
      o_VSync => Sync_To_Count2_0_o_VSync
    );
VGA_Sync_Porch_0: component P2_BD_pongIP_S2026_VGA_Sync_Porch_0_0
     port map (
      i_Blu_Video(2 downto 0) => i_Blu_Video(2 downto 0),
      i_Clk => i_Clk,
      i_Grn_Video(2 downto 0) => i_Grn_Video(2 downto 0),
      i_HSync => Sync_To_Count2_0_o_HSync,
      i_Red_Video(2 downto 0) => i_Red_Video(2 downto 0),
      i_VSync => Sync_To_Count2_0_o_VSync,
      o_Blu_Video(2 downto 0) => o_Blu_Video_0(2 downto 0),
      o_Grn_Video(2 downto 0) => o_Grn_Video_0(2 downto 0),
      o_HSync => o_HSync_0,
      o_Red_Video(2 downto 0) => o_Red_Video_0(2 downto 0),
      o_VSync => o_VSync_0
    );
VGA_Sync_Pulses_0: component P2_BD_pongIP_S2026_VGA_Sync_Pulses_0_0
     port map (
      i_Clk => i_Clk,
      o_Col_Count(9 downto 0) => NLW_VGA_Sync_Pulses_0_o_Col_Count_UNCONNECTED(9 downto 0),
      o_HSync => VGA_Sync_Pulses_0_o_HSync,
      o_Row_Count(9 downto 0) => NLW_VGA_Sync_Pulses_0_o_Row_Count_UNCONNECTED(9 downto 0),
      o_VSync => VGA_Sync_Pulses_0_o_VSync
    );
  o_vde <= (0 to 0 => VGA_Sync_Pulses_0_o_HSync) and (0 to 0 => VGA_Sync_Pulses_0_o_VSync);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity P2_BD_pongIP_S2026 is
  port (
    clk_125MHz : in STD_LOGIC;
    clk_25MHz : in STD_LOGIC;
    hdmi_tx_0_tmds_clk_n : out STD_LOGIC;
    hdmi_tx_0_tmds_clk_p : out STD_LOGIC;
    hdmi_tx_0_tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    hdmi_tx_0_tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    i_Switch_0 : in STD_LOGIC;
    i_Switch_1 : in STD_LOGIC;
    i_Switch_2 : in STD_LOGIC;
    i_Switch_3 : in STD_LOGIC;
    i_Switch_4 : in STD_LOGIC;
    locked : in STD_LOGIC;
    rst_0 : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of P2_BD_pongIP_S2026 : entity is "P2_BD_pongIP_S2026,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=P2_BD_pongIP_S2026,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=13,numReposBlks=11,numNonXlnxBlks=1,numHierBlks=2,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=9,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of P2_BD_pongIP_S2026 : entity is "P2_BD_pongIP_S2026.hwdef";
end P2_BD_pongIP_S2026;

architecture STRUCTURE of P2_BD_pongIP_S2026 is
  component P2_BD_pongIP_S2026_hdmi_tx_0_0 is
  port (
    pix_clk : in STD_LOGIC;
    pix_clkx5 : in STD_LOGIC;
    pix_clk_locked : in STD_LOGIC;
    rst : in STD_LOGIC;
    red : in STD_LOGIC_VECTOR ( 2 downto 0 );
    green : in STD_LOGIC_VECTOR ( 2 downto 0 );
    blue : in STD_LOGIC_VECTOR ( 2 downto 0 );
    hsync : in STD_LOGIC;
    vsync : in STD_LOGIC;
    vde : in STD_LOGIC;
    TMDS_CLK_P : out STD_LOGIC;
    TMDS_CLK_N : out STD_LOGIC;
    TMDS_DATA_P : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TMDS_DATA_N : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component P2_BD_pongIP_S2026_hdmi_tx_0_0;
  component P2_BD_pongIP_S2026_Pong_Top2_0_0 is
  port (
    i_Clk : in STD_LOGIC;
    i_Col_Count : in STD_LOGIC_VECTOR ( 9 downto 0 );
    i_Row_Count : in STD_LOGIC_VECTOR ( 9 downto 0 );
    i_Game_Start : in STD_LOGIC;
    i_Paddle_Up_P1 : in STD_LOGIC;
    i_Paddle_Dn_P1 : in STD_LOGIC;
    i_Paddle_Up_P2 : in STD_LOGIC;
    i_Paddle_Dn_P2 : in STD_LOGIC;
    o_Red_Video : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Blu_Video : out STD_LOGIC_VECTOR ( 2 downto 0 );
    o_Grn_Video : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component P2_BD_pongIP_S2026_Pong_Top2_0_0;
  signal Debounce_o_Switch1 : STD_LOGIC;
  signal Debounce_o_Switch2 : STD_LOGIC;
  signal Debounce_o_Switch3 : STD_LOGIC;
  signal Debounce_o_Switch4 : STD_LOGIC;
  signal Debounce_o_Switch5 : STD_LOGIC;
  signal Pong_Top2_0_o_Blu_Video : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal Pong_Top2_0_o_Grn_Video : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal Pong_Top2_0_o_Red_Video : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal VGA_o_Blu_Video_0 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal VGA_o_Col_Count : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal VGA_o_Grn_Video_0 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal VGA_o_HSync_0 : STD_LOGIC;
  signal VGA_o_Red_Video_0 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal VGA_o_Row_Count : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal VGA_o_VSync_0 : STD_LOGIC;
  signal VGA_o_vde : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_125MHz : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_125MHZ CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_125MHz : signal is "XIL_INTERFACENAME CLK.CLK_125MHZ, CLK_DOMAIN P2_BD_pongIP_S2026_clk_25MHz1, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of clk_25MHz : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_25MHZ CLK";
  attribute X_INTERFACE_PARAMETER of clk_25MHz : signal is "XIL_INTERFACENAME CLK.CLK_25MHZ, CLK_DOMAIN P2_BD_pongIP_S2026_clk_25MHz, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of hdmi_tx_0_tmds_clk_n : signal is "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_CLK_N";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of hdmi_tx_0_tmds_clk_n : signal is "Master";
  attribute X_INTERFACE_INFO of hdmi_tx_0_tmds_clk_p : signal is "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_CLK_P";
  attribute X_INTERFACE_INFO of locked : signal is "xilinx.com:signal:reset:1.0 RST.LOCKED RST";
  attribute X_INTERFACE_PARAMETER of locked : signal is "XIL_INTERFACENAME RST.LOCKED, INSERT_VIP 0, POLARITY ACTIVE_HIGH";
  attribute X_INTERFACE_INFO of rst_0 : signal is "xilinx.com:signal:reset:1.0 RST.RST_0 RST";
  attribute X_INTERFACE_PARAMETER of rst_0 : signal is "XIL_INTERFACENAME RST.RST_0, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of hdmi_tx_0_tmds_data_n : signal is "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_DATA_N";
  attribute X_INTERFACE_INFO of hdmi_tx_0_tmds_data_p : signal is "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_DATA_P";
begin
Debounce: entity work.Debounce_imp_K0Q0PB
     port map (
      i_Clk => clk_25MHz,
      i_Switch_0 => i_Switch_0,
      i_Switch_1 => i_Switch_1,
      i_Switch_2 => i_Switch_2,
      i_Switch_3 => i_Switch_3,
      i_Switch_4 => i_Switch_4,
      o_Switch0 => Debounce_o_Switch1,
      o_Switch1 => Debounce_o_Switch2,
      o_Switch2 => Debounce_o_Switch5,
      o_Switch3 => Debounce_o_Switch3,
      o_Switch4 => Debounce_o_Switch4
    );
Pong_Top2_0: component P2_BD_pongIP_S2026_Pong_Top2_0_0
     port map (
      i_Clk => clk_25MHz,
      i_Col_Count(9 downto 0) => VGA_o_Col_Count(9 downto 0),
      i_Game_Start => Debounce_o_Switch4,
      i_Paddle_Dn_P1 => Debounce_o_Switch1,
      i_Paddle_Dn_P2 => Debounce_o_Switch5,
      i_Paddle_Up_P1 => Debounce_o_Switch2,
      i_Paddle_Up_P2 => Debounce_o_Switch3,
      i_Row_Count(9 downto 0) => VGA_o_Row_Count(9 downto 0),
      o_Blu_Video(2 downto 0) => Pong_Top2_0_o_Blu_Video(2 downto 0),
      o_Grn_Video(2 downto 0) => Pong_Top2_0_o_Grn_Video(2 downto 0),
      o_Red_Video(2 downto 0) => Pong_Top2_0_o_Red_Video(2 downto 0)
    );
VGA: entity work.VGA_imp_33E8YF
     port map (
      i_Blu_Video(2 downto 0) => Pong_Top2_0_o_Blu_Video(2 downto 0),
      i_Clk => clk_25MHz,
      i_Grn_Video(2 downto 0) => Pong_Top2_0_o_Grn_Video(2 downto 0),
      i_Red_Video(2 downto 0) => Pong_Top2_0_o_Red_Video(2 downto 0),
      o_Blu_Video_0(2 downto 0) => VGA_o_Blu_Video_0(2 downto 0),
      o_Col_Count(9 downto 0) => VGA_o_Col_Count(9 downto 0),
      o_Grn_Video_0(2 downto 0) => VGA_o_Grn_Video_0(2 downto 0),
      o_HSync_0 => VGA_o_HSync_0,
      o_Red_Video_0(2 downto 0) => VGA_o_Red_Video_0(2 downto 0),
      o_Row_Count(9 downto 0) => VGA_o_Row_Count(9 downto 0),
      o_VSync_0 => VGA_o_VSync_0,
      o_vde(0) => VGA_o_vde(0)
    );
hdmi_tx_0: component P2_BD_pongIP_S2026_hdmi_tx_0_0
     port map (
      TMDS_CLK_N => hdmi_tx_0_tmds_clk_n,
      TMDS_CLK_P => hdmi_tx_0_tmds_clk_p,
      TMDS_DATA_N(2 downto 0) => hdmi_tx_0_tmds_data_n(2 downto 0),
      TMDS_DATA_P(2 downto 0) => hdmi_tx_0_tmds_data_p(2 downto 0),
      blue(2 downto 0) => VGA_o_Blu_Video_0(2 downto 0),
      green(2 downto 0) => VGA_o_Grn_Video_0(2 downto 0),
      hsync => VGA_o_HSync_0,
      pix_clk => clk_25MHz,
      pix_clk_locked => locked,
      pix_clkx5 => clk_125MHz,
      red(2 downto 0) => VGA_o_Red_Video_0(2 downto 0),
      rst => rst_0,
      vde => VGA_o_vde(0),
      vsync => VGA_o_VSync_0
    );
end STRUCTURE;
