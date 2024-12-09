
// Efinity Top-level template
// Version: 2023.2.307.5.10
// Date: 2024-11-28 16:28

// Copyright (C) 2013 - 2023 Efinix Inc. All rights reserved.

// This file may be used as a starting point for Efinity synthesis top-level target.
// The port list here matches what is expected by Efinity constraint files generated
// by the Efinity Interface Designer.

// To use this:
//     #1)  Save this file with a different name to a different directory, where source files are kept.
//              Example: you may wish to save as C:\Users\32954\Desktop\fpga2\1080norst_bicubic32ok (2)\1051\Ti60_Demo.v
//     #2)  Add the newly saved file into Efinity project as design file
//     #3)  Edit the top level entity in Efinity project to:  Ti60_Demo
//     #4)  Insert design content.


module Ti60_Demo
(
  input clk_24m,
  input clk_25m,
  input fpga_rxd_1,
  input sys_pll_lock,
  input ddr_pll_CLKOUT4,
  input ddr_pll_lock,
  input input_pll_lock,
  input twd_clk,
  input tac_clk,
  input tdqss_clk,
  input clk_sys,
  input clk_pixel,
  input core_clk,
  input clk_6m,
  input clk_96m,
  input clk_75m,
  input clk_100m,
  input clk_pixel_10x,
  input clk_pixel_2x,
  input [15:0] i_dq_hi,
  input [15:0] i_dq_lo,
  input [1:0] i_dqs_hi,
  input [1:0] i_dqs_lo,
  input [1:0] i_dqs_n_hi,
  input [1:0] i_dqs_n_lo,
  input fpga_rxd_0,
  input [23:0] hdmi_data_i,
  input hdmi_de_i,
  input hdmi_hs_i,
  input hdmi_pclk_i,
  input hdmi_sda_io_IN,
  input hdmi_vs_i,
  output fpga_txd_1,
  output [7:0] led_o,
  output sys_pll_rstn_o,
  output ddr_pll_rstn_o,
  output [2:0] shift,
  output shift_ena,
  output [4:0] shift_sel,
  output input_pll_rstn_o,
  output hdmi_txc_oe,
  output [9:0] hdmi_txc_o,
  output hdmi_txc_rst_o,
  output hdmi_txd0_oe,
  output [9:0] hdmi_txd0_o,
  output hdmi_txd0_rst_o,
  output hdmi_txd1_oe,
  output [9:0] hdmi_txd1_o,
  output hdmi_txd1_rst_o,
  output hdmi_txd2_oe,
  output [9:0] hdmi_txd2_o,
  output hdmi_txd2_rst_o,
  output [15:0] addr,
  output adv7611_rstn,
  output [2:0] ba,
  output cas,
  output cke,
  output clk_n_hi,
  output clk_n_lo,
  output clk_p_hi,
  output clk_p_lo,
  output cs,
  output [1:0] o_dm_hi,
  output [1:0] o_dm_lo,
  output [15:0] o_dq_hi,
  output [15:0] o_dq_lo,
  output [15:0] o_dq_oe,
  output [1:0] o_dqs_hi,
  output [1:0] o_dqs_lo,
  output [1:0] o_dqs_oe,
  output [1:0] o_dqs_n_hi,
  output [1:0] o_dqs_n_lo,
  output [1:0] o_dqs_n_oe,
  output fpga_txd_0,
  output hdmi_scl_io,
  output hdmi_sda_io_OUT,
  output hdmi_sda_io_OE,
  output odt,
  output ras,
  output reset,
  output we
);


endmodule

