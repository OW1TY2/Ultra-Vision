module data_in_uart_control_top(
    input       sys_clk_96M,
    input       sys_clk_24M,
    input       biliner_clk_in,//20MHz
    input       biliner_clk_out,//168MHz
    input       sys_rst_n,
    
    //ͼ���ź�
    input               hdmi_pix_clk_i,
    input      [23:0]   hdmi_RGB_data_i,
    input               hdmi_pix_en_i,
    input               hdmi_hsync_i,//�������ź�
    input               hdmi_vsync_i,//���볡�ź�
    
    
    //���ڿ���
	output				fpga_txd_0,		//uart_1_input
    input				fpga_rxd_0,
    output				fpga_txd_1,
    input				fpga_rxd_1,
    
    //ADV7611
    input hdmi_sda_io_IN,
	output hdmi_sda_io_OUT,
    output hdmi_sda_io_OE,
    output hdmi_scl_o,
    output adv7611_rstn,
    
    output wire             post_img_vsync,//���ź����
    output wire             post_img_href,//���ź����
    output wire [31:0]      post_img_data, // 32λ���  

    output wire [11:0]      C_DST_IMG_WIDTH,
    output wire [11:0]      C_DST_IMG_HEIGHT,

    output wire ADV7611_config_done,//debug
    output wire hsync_o,
    output wire vsync_o,
    output wire wr_en_i,
    output wire rd_en_i,
    output wire [1:0]state_debug,

    output wire vid_format

    // input wire out_model

    //input wire frame_count//pingpong
);

// reg frame_count_r;

// always@(posedge biliner_clk_out or negedge sys_rst_n)begin
//     if(~sys_rst_n)
//         frame_count_r<=1'b0;
//     else 
//         frame_count_r<=frame_count;
// end
// wire frame_count_n;
// assign frame_count_n=(~frame_count)&frame_count_r;

// always @ (posedge biliner_clk_out)begin
//     if(frame_count_n)
// end

parameter C_SRC_IMG_WIDTH  = 12'd640;
parameter C_SRC_IMG_HEIGHT = 12'd480;

wire [23:0]     RGB_data_o;
// wire            hsync_o;
// wire            vsync_o;

wire [11:0]     uart_x_pix_len;
wire [11:0]     uart_y_pix_len;
wire            ADV7611_config_done;

reg [11:0]     uart_x_pix_len_=12'd1920;
reg [11:0]     uart_y_pix_len_=12'd1080;

data_loader data_loader_u
(
    .sys_clk_96M        (sys_clk_96M),
    .biliner_clk_in        (biliner_clk_in),
    .sys_rst_n          (sys_rst_n),
    .pix_clk_i          (hdmi_pix_clk_i),
    
    .RGB_data_i             (hdmi_RGB_data_i),
    .pix_en_i               (hdmi_pix_en_i),
    .hsync_i                (hdmi_hsync_i),
    .vsync_i                (hdmi_vsync_i),
    .ADV7611_config_done    (ADV7611_config_done),    

    .RGB_data_o             (RGB_data_o),
    .hsync_o                (hsync_o),
    .vsync_o                (vsync_o),

    .wr_en_i(wr_en_i),//debug
    .rd_en_i(rd_en_i),
    .state_debug(state_debug)
);


wire [1:0]out_model;
wire [8:0]bi_a;
reg [8:0]bi_a_;
reg [1:0]out_model_;

reg vs_delay;
wire vs_pos;
always @(posedge biliner_clk_out)begin
    if(!sys_rst_n)
        vs_delay <= 0;
    else
        vs_delay <= post_img_vsync;
end
assign vs_pos = ~post_img_vsync & vs_delay;

reg vs_pos2;
always @(posedge biliner_clk_out)begin
    if(!sys_rst_n)
        vs_pos2 <= 0;
    else
        vs_pos2 <= vs_pos;
end

reg vs_pos3;
always @(posedge biliner_clk_out)begin
    if(!sys_rst_n)
        vs_pos3 <= 0;
    else
        vs_pos3 <= vs_pos2;
end

always @(posedge biliner_clk_out)begin
    if(!sys_rst_n)begin
        bi_a_ <= 128;
        out_model_ <= 1;
    end
    else begin
        if(vs_pos3)begin
            bi_a_ <= bi_a;
            out_model_ <= out_model;
        end
        else begin
            bi_a_ <= bi_a_;    
            out_model_ <= out_model_;
        end
    end    
end

rgb_bicubic
#(
    .C_SRC_IMG_WIDTH        (C_SRC_IMG_WIDTH),
    .C_SRC_IMG_HEIGHT       (C_SRC_IMG_HEIGHT)
) rgb_bicubic_u (
    .clk_in1                (biliner_clk_in),
    .clk_in2                (biliner_clk_out),
    .out_model              (out_model_),//
    .rst_n                  (sys_rst_n),
    .per_img_vsync          (vsync_o),
    .per_img_href           (hsync_o),
    .per_img_red            (RGB_data_o[23:16]),
    .per_img_green          (RGB_data_o[15:8]),
    .per_img_blue           (RGB_data_o[7:0]),
    .c_dst_img_width        (uart_x_pix_len),
    .c_dst_img_height       (uart_y_pix_len),
    .bi_a                   (bi_a_),//
    .post_img_vsync         (post_img_vsync),
    .post_img_href          (post_img_href),
    .post_img_data          (post_img_data),
    .C_DST_IMG_WIDTH        (C_DST_IMG_WIDTH),
    .C_DST_IMG_HEIGHT       (C_DST_IMG_HEIGHT)
);


assign adv7611_rstn = 1'b1;
wire                   [   8:0]         i2c_config_index           ;
wire                   [  23:0]         i2c_config_data            ;
wire                   [   8:0]         i2c_config_size            ;


i2c_timing_ctrl #(
    .CLK_FREQ ( 24_000_000 ),
    .I2C_FREQ ( 50000 ))
 u_i2c_timing_ctrl (
    .clk                     ( sys_clk_24M                      ),
    .rst_n                   ( sys_rst_n                    ),
    .i2c_sdat_IN             ( hdmi_sda_io_IN              ),
    .i2c_config_size         ( i2c_config_size   [7:0]  ),
    .i2c_config_data         ( i2c_config_data   [23:0] ),

    .i2c_sclk                ( hdmi_scl_o                 ),
    .i2c_sdat_OUT            ( hdmi_sda_io_OUT             ),
    .i2c_sdat_OE             ( hdmi_sda_io_OE              ),
    .i2c_config_index        ( i2c_config_index  [7:0]  ),
    .i2c_config_done         ( ADV7611_config_done          )
);

I2C_ADV7611_Config u_I2C_ADV7611_Config
(
    .LUT_INDEX                         (i2c_config_index          ),
    .LUT_DATA                          (i2c_config_data           ),
    .LUT_SIZE                          (i2c_config_size           ) 
);


uart_control_top u_uart_control_top
(
    .clk_24M        (sys_clk_24M),
    .sys_clk_96M    (sys_clk_96M),
    .sys_rst_n      (sys_rst_n),
    .fpga_rxd_0     (fpga_rxd_0),
    .fpga_txd_0     (fpga_txd_0),
    .fpga_rxd_1     (fpga_rxd_1),
    .fpga_txd_1     (fpga_txd_1),
    .x_pix_len      (uart_x_pix_len),
    .y_pix_len      (uart_y_pix_len),

    .out_model(out_model),
    .vid_format(vid_format),
    .bi_a(bi_a)
);


endmodule 
