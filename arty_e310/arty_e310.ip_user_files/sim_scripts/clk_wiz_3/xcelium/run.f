-makelib xcelium_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_clk_wiz.v" \
  "../../../../arty_e310.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

