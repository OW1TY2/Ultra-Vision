
// Efinity Top-level template
// Version: 2023.2.307
// Date: 2024-10-07 15:25

// Copyright (C) 2013 - 2023 Efinix Inc. All rights reserved.

// This file may be used as a starting point for Efinity synthesis top-level target.
// The port list here matches what is expected by Efinity constraint files generated
// by the Efinity Interface Designer.

// To use this:
//     #1)  Save this file with a different name to a different directory, where source files are kept.
//              Example: you may wish to save as D:\FPGA_Competition\FPGAprojects\data_in_uart_control_new\Bilinear_interpolation_prj\Bilinear_interpolation_prj.v
//     #2)  Add the newly saved file into Efinity project as design file
//     #3)  Edit the top level entity in Efinity project to:  Bilinear_interpolation_prj
//     #4)  Insert design content.


module Bilinear_interpolation_prj
(
  input fpga_rxd_1,
  input sys_clk_24M,
  input sys_rst_n,
  input biliner_clk_out,
  input sys_clk_96M,
  input biliner_clk_in,
  input fpga_rxd_0,
  input [23:0] hdmi_RGB_data_i,
  input hdmi_hsync_i,
  input hdmi_pix_clk_i,
  input hdmi_pix_en_i,
  input hdmi_sda_io_IN,
  input hdmi_vsync_i,
  output fpga_txd_1,
  output adv7611_rstn,
  output fpga_txd_0,
  output hdmi_scl_o,
  output hdmi_sda_io_OUT,
  output hdmi_sda_io_OE
);


endmodule

