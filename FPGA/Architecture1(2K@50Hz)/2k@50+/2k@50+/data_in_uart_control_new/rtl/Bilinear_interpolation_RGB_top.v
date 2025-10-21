module Bilinear_interpolation_RGB_top(
    input       sys_clk_96M,
    input       sys_clk_24M,
    input       biliner_clk_in,
    input       clk_out,
    input       sys_rst_n,
    
    
    input               pix_clk_i,
    input      [23:0]   RGB_data_i,
    input               pix_en_i,
    input               hsync_i,//输入行信号
    input               vsync_i,//输入场信号
    input               ADV7611_config_done,
    
    input      [11:0]   c_dst_img_width,
    input      [11:0]   c_dst_img_height,
    
    output wire                  post_img_vsync,
    output wire                  post_img_href,
    output wire      [31:0]      post_img_data // 32位输出  
);

parameter C_SRC_IMG_WIDTH  = 12'd640;
parameter C_SRC_IMG_HEIGHT = 12'd480;

wire [23:0]     RGB_data_o;
wire            hsync_o;
wire            vsync_o;


data_loader data_loader_u
(
    .sys_clk_96M        (sys_clk_96M),
    .biliner_clk_in     (biliner_clk_in),
    .sys_rst_n          (sys_rst_n),
    .pix_clk_i          (pix_clk_i),
    
    .RGB_data_i             (RGB_data_i),
    .pix_en_i               (pix_en_i),
    .hsync_i                (hsync_i),
    .vsync_i                (vsync_i),
    .ADV7611_config_done    (ADV7611_config_done),    

    .RGB_data_o             (RGB_data_o),
    .hsync_o                (hsync_o),
    .vsync_o                (vsync_o)
);



rgb_biliner
#(
    .C_SRC_IMG_WIDTH        (C_SRC_IMG_WIDTH),
    .C_SRC_IMG_HEIGHT       (C_SRC_IMG_HEIGHT)
) rgb_biliner_u (
    .clk_in1                (biliner_clk_in),
    .clk_in2                (clk_out),
    .rst_n                  (sys_rst_n),
    .per_img_vsync          (vsync_o),
    .per_img_href           (hsync_o),
    .per_img_red            (RGB_data_o[23:16]),
    .per_img_green          (RGB_data_o[15:8]),
    .per_img_blue           (RGB_data_o[7:0]),
    .c_dst_img_width        (c_dst_img_width),
    .c_dst_img_height       (c_dst_img_height),
    .post_img_vsync         (post_img_vsync),
    .post_img_href          (post_img_href),
    .post_img_data          (post_img_data)
);

endmodule 
