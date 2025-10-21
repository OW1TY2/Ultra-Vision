// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   bilinear_interpolation.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   双线性插值图像缩放模块
//                  支持任意分辨率缩放,使用双线性插值算法实现平滑的图像缩放
//                  采用双时钟域设计,输入输出可使用不同时钟
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2021/03/27   CrazyBird   1.0             Original
// 
// *********************************************************************
module bilinear_interpolation
#(
    parameter C_SRC_IMG_WIDTH  = 12'd640    ,               // 源图像宽度(默认640像素)
    parameter C_SRC_IMG_HEIGHT = 12'd480                    // 源图像高度(默认480像素)
    // 目标图像尺寸和缩放比例通过动态输入实现,不再使用固定参数
    // parameter C_DST_IMG_WIDTH  = 11'd10   ,
    // parameter C_DST_IMG_HEIGHT = 11'd8    ,
    // parameter C_X_RATIO        = 16'd32768  ,           //  floor(C_SRC_IMG_WIDTH/C_DST_IMG_WIDTH*2^16)
    // parameter C_Y_RATIO        = 16'd32768              //  floor(C_SRC_IMG_HEIGHT/C_DST_IMG_HEIGHT*2^16)
)
(
    // 时钟和复位信号
    input  wire                 clk_in1         ,           // 输入图像时钟域
    input  wire                 clk_in2         ,           // 输出图像时钟域
    input  wire                 rst_n           ,           // 低电平复位信号
    input  wire                 out_model       ,           // 输出模式选择: 0=最近邻, 1=双线性插值
    
    // 输入图像数据接口
    input  wire                 per_img_vsync   ,           // 输入图像场同步信号
    input  wire                 per_img_href    ,           // 输入图像行有效信号
    input  wire     [7:0]       per_img_gray    ,           // 输入图像灰度数据
    
    // 输出图像数据接口
    output reg                  post_img_vsync  ,           // 输出图像场同步信号
    output reg                  post_img_href   ,           // 输出图像行有效信号
    output reg      [7:0]       post_img_gray   ,           // 输出图像灰度数据

    // 动态分辨率配置接口
    input  wire     [11:0]      c_dst_img_width ,           // 目标图像宽度(动态输入)
    input  wire     [11:0]      c_dst_img_height,           // 目标图像高度(动态输入)
    output reg      [11:0]      C_DST_IMG_WIDTH ,           // 当前使用的目标宽度
    output reg      [11:0]      C_DST_IMG_HEIGHT            // 当前使用的目标高度
);
//----------------------------------------------------------------------

//============================================================================
// 动态分辨率配置模块
// 功能: 在每帧结束时更新目标分辨率,并计算缩放比例
//============================================================================

// 检测输出场同步信号的下降沿(帧结束标志)
reg                             post_img_vsync_dly;
wire                            post_img_vsync_neg;
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        post_img_vsync_dly <= 1'b0;
    else
        post_img_vsync_dly <= post_img_vsync;      // 延迟一拍用于边沿检测
end
assign post_img_vsync_neg = post_img_vsync_dly & ~post_img_vsync;  // 下降沿检测


// c1阶段: 对帧结束信号进行第一级延迟
reg                             post_img_vsync_neg_c1;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        post_img_vsync_neg_c1 = 0;
    end
    else begin
        post_img_vsync_neg_c1 <= post_img_vsync_neg;
    end
end

// c1.5阶段: 对帧结束信号进行第二级延迟,用于同步时序
reg                             post_img_vsync_neg_c1_5;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        post_img_vsync_neg_c1_5 = 0;
    end
    else begin
        post_img_vsync_neg_c1_5 <= post_img_vsync_neg_c1;
    end
end


// c2阶段: 更新目标分辨率参数
reg                             post_img_vsync_neg_c2;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        C_DST_IMG_WIDTH  <= 640;               // 复位时设为默认值640x480
        C_DST_IMG_HEIGHT <= 480;
    end
    else begin
        if(post_img_vsync_neg_c1_5 == 1)       // 在帧结束时更新
        begin
            C_DST_IMG_WIDTH  <= c_dst_img_width;    // 锁存新的目标分辨率
            C_DST_IMG_HEIGHT <= c_dst_img_height;
            post_img_vsync_neg_c2 <= 1;
        end
        else
        begin
            C_DST_IMG_WIDTH  <= C_DST_IMG_WIDTH;    // 保持当前值
            C_DST_IMG_HEIGHT <= C_DST_IMG_HEIGHT;
            post_img_vsync_neg_c2 <= 0;
        end
    end
end


// c3阶段: 计算缩放比例的中间值(源尺寸左移16位,为定点数计算做准备)
reg             [26:0]          multi_tmp1_c2;
reg             [26:0]          multi_tmp2_c2;
reg                             post_img_vsync_neg_c3;

always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        multi_tmp1_c2  <= 0;
        multi_tmp2_c2  <= 0;
    end
    else begin
        if(post_img_vsync_neg_c2 == 1) begin
            multi_tmp1_c2 <= (C_SRC_IMG_WIDTH << 16);   // 源宽度 * 2^16 (Q16定点数)
            multi_tmp2_c2 <= (C_SRC_IMG_HEIGHT << 16);  // 源高度 * 2^16 (Q16定点数)
            post_img_vsync_neg_c3 <= 1;
        end
        else begin
            multi_tmp1_c2 <= multi_tmp1_c2;
            multi_tmp2_c2 <= multi_tmp2_c2;
            post_img_vsync_neg_c3 <= 0;
        end
    end
end

// c4阶段: 计算X和Y方向的缩放比例
// X_RATIO = (源宽度 / 目标宽度) * 2^16
// Y_RATIO = (源高度 / 目标高度) * 2^16
reg             [16:0]          C_X_RATIO;
reg             [16:0]          C_Y_RATIO;
reg                             divide_clken;          // 除法器使能信号
wire                            rfd;                   // Y方向除法完成标志
wire                            rfd1;                  // X方向除法完成标志
wire            [26:0]          c_x_ratio_divide;      // X方向缩放比例
wire            [26:0]          c_y_ratio_divide;      // Y方向缩放比例

// 除法器使能控制逻辑
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        divide_clken  <= 0; 
    end
    else begin
        if(post_img_vsync_neg_c3 == 1 && rfd == 0) begin
            divide_clken <= 1;                     // 启动除法运算
        end
        else if(post_img_vsync_neg_c3 == 0 && rfd == 1) begin
            divide_clken <= 0;                     // 除法完成后关闭
        end else
            divide_clken <= divide_clken;
    end
end

// X方向缩放比例除法器: (源宽度*2^16) / 目标宽度
divider_ip ux_divider_ip(  
    .numer(multi_tmp1_c2),                         // 被除数
    .denom(C_DST_IMG_WIDTH),                       // 除数
    .clken(divide_clken),
    .clk(clk_in2),
    .reset(1'b0),
    .quotient(c_x_ratio_divide),                   // 商(缩放比例)
    .remain(),
    .rfd(rfd1)
);

// Y方向缩放比例除法器: (源高度*2^16) / 目标高度
divider_ip uy_divider_ip(
    .numer(multi_tmp2_c2),                         // 被除数
    .denom(C_DST_IMG_HEIGHT),                      // 除数
    .clken(divide_clken),
    .clk(clk_in2),
    .reset(1'b0),
    .quotient(c_y_ratio_divide),                   // 商(缩放比例)
    .remain(),
    .rfd(rfd)
);

// 锁存计算得到的缩放比例
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        C_X_RATIO  <= 65536;                       // 默认1:1(65536 = 2^16)
        C_Y_RATIO  <= 65536; 
    end
    else begin
        if (rfd == 1) begin                        // 除法完成
            C_X_RATIO  <= c_x_ratio_divide; 
            C_Y_RATIO  <= c_y_ratio_divide; 
        end else begin
            C_X_RATIO  <= C_X_RATIO; 
            C_Y_RATIO  <= C_Y_RATIO; 
        end
    end
end


//============================================================================
// 输入图像处理模块 - clk_in1时钟域
// 功能: 接收输入图像,计算行列计数器,将数据写入BRAM和FIFO
//============================================================================

// 检测行有效信号的下降沿(行结束标志)
reg                             per_img_href_dly;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        per_img_href_dly <= 1'b0;
    else
        per_img_href_dly <= per_img_href;
end

wire                            per_img_href_neg;
assign per_img_href_neg = per_img_href_dly & ~per_img_href;

// 垂直行计数器: 从0计数到C_SRC_IMG_HEIGHT-1
reg             [10:0]          img_vs_cnt;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        img_vs_cnt <= 11'b0;
    else
    begin
        if(per_img_vsync == 1'b0)
            img_vs_cnt <= 11'b0;                   // 场同步无效时清零
        else
        begin
            if(per_img_href_neg == 1'b1)           // 每行结束时递增
                img_vs_cnt <= img_vs_cnt + 1'b1;
            else
                img_vs_cnt <= img_vs_cnt;
        end
    end
end

// 水平像素计数器: 从0计数到C_SRC_IMG_WIDTH-1
reg             [10:0]          img_hs_cnt;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        img_hs_cnt <= 11'b0;
    else
    begin
        if((per_img_vsync == 1'b1) && (per_img_href == 1'b1))
            img_hs_cnt <= img_hs_cnt + 1'b1;       // 有效数据时递增
        else
            img_hs_cnt <= 11'b0;                   // 行结束时清零
    end
end

//----------------------------------------------------------------------
// BRAM写入数据准备
reg             [7:0]           bram_a_wdata;

always @(posedge clk_in1)
begin
    bram_a_wdata <= per_img_gray;                  // 锁存输入灰度数据
end

// BRAM写入地址计算
// 地址格式: {行号[2:1], 列号[9:0]}
// 这样可以同时存储4行数据(行号[2:1]选择4个1K地址块之一)
reg             [11:0]          bram_a_waddr;

always @(posedge clk_in1)
begin
    bram_a_waddr <= {img_vs_cnt[2:1], 10'b0} + img_hs_cnt;
end

// BRAM1写使能: 存储偶数行(行号最低位为0)
reg                             bram1_a_wenb;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        bram1_a_wenb <= 1'b0;
    else
        bram1_a_wenb <= per_img_vsync & per_img_href & ~img_vs_cnt[0];
end

// BRAM2写使能: 存储奇数行(行号最低位为1)
reg                             bram2_a_wenb;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        bram2_a_wenb <= 1'b0;
    else
        bram2_a_wenb <= per_img_vsync & per_img_href & img_vs_cnt[0];
end

// FIFO写入数据: 存储行号,用于跨时钟域同步
reg             [10:0]          fifo_wdata;

always @(posedge clk_in1)
begin
    fifo_wdata <= img_vs_cnt;
end

// FIFO写使能: 每行结束时写入一次
reg                             fifo_wenb;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        fifo_wenb <= 1'b0;
    else
    begin
        if((per_img_vsync == 1'b1) && (per_img_href == 1'b1) && (img_hs_cnt == C_SRC_IMG_WIDTH - 1'b1))
            fifo_wenb <= 1'b1;                     // 行结束时触发
        else
            fifo_wenb <= 1'b0;
    end
end

//----------------------------------------------------------------------
//============================================================================
// BRAM和FIFO实例化 - 双端口存储器
// 功能: 存储输入图像的多行数据,支持双时钟域读写
// BRAM组织: 使用4个BRAM,分别存储奇偶行和不同地址段的数据
//============================================================================

// BRAM读地址和读数据信号定义
reg             [11:0]          even_bram1_b_raddr;    // BRAM1偶数地址段读地址
reg             [11:0]          odd_bram1_b_raddr;     // BRAM1奇数地址段读地址
reg             [11:0]          even_bram2_b_raddr;    // BRAM2偶数地址段读地址
reg             [11:0]          odd_bram2_b_raddr;     // BRAM2奇数地址段读地址
wire            [ 7:0]          even_bram1_b_rdata;    // BRAM1偶数地址段读数据
wire            [ 7:0]          odd_bram1_b_rdata;     // BRAM1奇数地址段读数据
wire            [ 7:0]          even_bram2_b_rdata;    // BRAM2偶数地址段读数据
wire            [ 7:0]          odd_bram2_b_rdata;     // BRAM2奇数地址段读数据


// BRAM实例1: 存储偶数行的偶数地址段数据
my_bram_ip  u1_my_bram_ip(
    .clk_a                             (    clk_in1                        ),  // 写时钟
    .we_a                              (    bram1_a_wenb                   ),  // 写使能
    .addr_a                            (    bram_a_waddr                   ),  // 写地址
    .wdata_a                           (    bram_a_wdata                   ),  // 写数据
    .rdata_a                           (                                   ),  // 端口A读数据(未使用)
    .clk_b                             (    clk_in2                        ),  // 读时钟
    .we_b                              (    1'b0                           ),  // 读端口不写
    .addr_b                            (    even_bram1_b_raddr             ),  // 读地址
    .wdata_b                           (    8'b0                           ),  
    .rdata_b                           (    even_bram1_b_rdata             )   // 读数据
);

// BRAM实例2: 存储偶数行的奇数地址段数据
my_bram_ip  u2_my_bram_ip(
    .clk_a                             (    clk_in1                     ),
    .we_a                              (    bram1_a_wenb                ),
    .addr_a                            (    bram_a_waddr                ),
    .wdata_a                           (    bram_a_wdata                ),
    .rdata_a                           (                                ),
    .clk_b                             (    clk_in2                     ), 
    .we_b                              (    1'b0                        ),
    .addr_b                            (    odd_bram1_b_raddr           ),
    .wdata_b                           (    8'b0                        ),
    .rdata_b                           (    odd_bram1_b_rdata           )
);

// BRAM实例3: 存储奇数行的偶数地址段数据
my_bram_ip  u3_my_bram_ip(
    .clk_a                             (      clk_in1                   ),
    .we_a                              (      bram2_a_wenb              ),
    .addr_a                            (      bram_a_waddr              ),
    .wdata_a                           (      bram_a_wdata              ),
    .rdata_a                           (                                ),
    .clk_b                             (      clk_in2                   ), 
    .we_b                              (      1'b0                      ),
    .addr_b                            (      even_bram2_b_raddr        ),
    .wdata_b                           (      8'b0                      ),
    .rdata_b                           (      even_bram2_b_rdata        )
);

// BRAM实例4: 存储奇数行的奇数地址段数据
my_bram_ip  u4_my_bram_ip(
    .clk_a                             (      clk_in1                     ),
    .we_a                              (      bram2_a_wenb                ),
    .addr_a                            (      bram_a_waddr                ),
    .wdata_a                           (      bram_a_wdata                ),
    .rdata_a                           (                                  ),
    .clk_b                             (      clk_in2                     ), 
    .we_b                              (      1'b0                        ),
    .addr_b                            (      odd_bram2_b_raddr           ),
    .wdata_b                           (      8'b0                        ),
    .rdata_b                           (      odd_bram2_b_rdata           )
);

// 以下是备用的BRAM实例化代码(已注释),可能用于不同厂商的FPGA平台
// 例如: Altera/Intel的BRAM IP核接口
    // my_bram_ip    my_bram_ip_inst1 (
    // .clock_a                           (   clk_in1                  ),
    // .wren_a                            (   bram1_a_wenb             ),
    // .address_a                         (   bram_a_waddr             ),
    // .data_a                            (   bram_a_wdata             ),
    // .q_a                               (                            ),
    // .clock_b                           (   clk_in2                  ),
    // .wren_b                            (   1'b0                     ),
    // .address_b                         (   even_bram1_b_raddr       ),
    // .data_b                            (   8'b0                     ),
    // .q_b                               (   even_bram1_b_rdata       ) 
    //     );
    // my_bram_ip    my_bram_ip_inst2 (
    // .clock_a                           (  clk_in1                   ),
    // .wren_a                            (  bram1_a_wenb              ),
    // .address_a                         (  bram_a_waddr              ),
    // .data_a                            (  bram_a_wdata              ),
    // .q_a                               (                            ),
    // .clock_b                           (  clk_in2                   ),
    // .wren_b                            (  1'b0                      ),
    // .address_b                         (  odd_bram1_b_raddr         ),
    // .data_b                            (  8'b0                      ),
    // .q_b                               (  odd_bram1_b_rdata         ) 
    //     );
    // my_bram_ip    my_bram_ip_inst3 (
    // .clock_a                           (   clk_in1                  ),
    // .wren_a                            (   bram2_a_wenb             ),
    // .address_a                         (   bram_a_waddr             ),
    // .data_a                            (   bram_a_wdata             ),
    // .q_a                               (                            ),
    // .clock_b                           (   clk_in2                  ),
    // .wren_b                            (   1'b0                     ),
    // .address_b                         (   even_bram2_b_raddr       ),
    // .data_b                            (   8'b0                     ),
    // .q_b                               (   even_bram2_b_rdata       ) 
    //     );
    // my_bram_ip    my_bram_ip_inst4 (
    // .clock_a                           ( clk_in1                   ),
    // .wren_a                            ( bram2_a_wenb              ),
    // .address_a                         ( bram_a_waddr              ),
    // .data_a                            ( bram_a_wdata              ),
    // .q_a                               (                           ),
    // .clock_b                           ( clk_in2                   ),
    // .wren_b                            ( 1'b0                      ),
    // .address_b                         ( odd_bram2_b_raddr         ),
    // .data_b                            ( 8'b0                      ),
    // .q_b                               ( odd_bram2_b_rdata         ) 
    //     );
    

//     my_bram_ip    my_bram_ip_inst2 (
//     .wren_a                            (bram1_a_wenb                ),
//     .wren_b                            (1'b0                        ),
//     .address_a                         (bram_a_waddr                ),
//     .data_a                            (bram_a_wdata                ),
//     .q_a                               (                            ),
//     .q_b                               (odd_bram1_b_rdata           ),
//     .address_b                         (odd_bram1_b_raddr           ),
//     .data_b                            (8'b0                        ),
//     .clock_a                           (clk_in1                     ),
//     .clock_b                           (clk_in2                     )
//         );

// my_bram_ip    my_bram_ip_inst3 (
//     .wren_a                            (bram2_a_wenb               ),
//     .wren_b                            (1'b0                       ),
//     .address_a                         (bram_a_waddr               ),
//     .data_a                            (bram_a_wdata               ),
//     .q_a                               (                           ),
//     .q_b                               (even_bram2_b_rdata         ),
//     .address_b                         (even_bram2_b_raddr         ),
//     .data_b                            (8'b0                       ),
//     .clock_a                           (clk_in1                    ),
//     .clock_b                           (clk_in2                    )
//         );


// my_bram_ip    my_bram_ip_inst4 (
//     .wren_a                            (bram2_a_wenb               ),
//     .wren_b                            (1'b0                       ),
//     .address_a                         (bram_a_waddr               ),
//     .data_a                            (bram_a_wdata               ),
//     .q_a                               (                           ),
//     .q_b                               (odd_bram2_b_rdata          ),
//     .address_b                         (odd_bram2_b_raddr          ),
//     .data_b                            (8'b0                       ),
//     .clock_a                           (clk_in1                    ),
//     .clock_b                           (clk_in2                    )
//         );

// FIFO信号定义
wire                            fifo_renb;             // FIFO读使能
wire            [10:0]          fifo_rdata;            // FIFO读数据(行号)
wire                            fifo_empty;            // FIFO空标志
wire                            fifo_full;             // FIFO满标志

// 异步FIFO实例: 跨时钟域传输行号信息
asyn_fifo  u_asyn_fifo(
    .a_rst_i                           (   ~rst_n                       ), 
    .wdata                             (    fifo_wdata                  ), // 写数据(行号)
    .rd_clk_i                          (     clk_in2                    ), // 读时钟
    .rd_en_i                           (      fifo_renb                 ), // 读使能
    .wr_clk_i                          (       clk_in1                  ), // 写时钟
    .wr_en_i                           (       fifo_wenb                ), // 写使能
    .rdata                             (       fifo_rdata               ), // 读数据
    .full_o                            (      fifo_empty                ), // 空标志
    .empty_o                           (       fifo_full                ), // 满标志
    .almost_full_o                     (        ),
    .prog_full_o                       (        ),
    .overflow_o                        (        ),
    .wr_ack_o                          (        ),
    .almost_empty_o                    (        ),
    .underflow_o                       (        ),
    .rd_valid_o                        (        ),
    .wr_datacount_o                    (        ),
    .rst_busy                          (        ),
    .rd_datacount_o                    (        )
);

//============================================================================
// 输出控制状态机 - clk_in2时钟域
// 功能: 根据缩放比例,控制BRAM读取和插值计算流程
//============================================================================

// 状态机状态定义
localparam S_IDLE      = 3'd0;             // 空闲状态: 等待FIFO非空
localparam S_Y_LOAD    = 3'd1;             // Y加载状态: 判断是否需要读取新行
localparam S_BRAM_ADDR = 3'd2;             // BRAM寻址状态: 计算并输出一行数据
localparam S_Y_INC     = 3'd3;             // Y递增状态: 更新Y坐标
localparam S_RD_FIFO   = 3'd4;             // 读FIFO状态: 从FIFO读取行号

// 状态机相关信号
reg             [ 2:0]          state;                 // 当前状态
reg             [26:0]          y_dec;                 // Y坐标定点数(含整数和小数部分)
reg             [26:0]          x_dec;                 // X坐标定点数(含整数和小数部分)
reg             [11:0]          y_cnt;                 // 输出图像Y计数器(行号)
reg             [11:0]          x_cnt;                 // 输出图像X计数器(列号)

// 状态机主逻辑
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        state <= S_IDLE;
    else
    begin
        case(state)
            S_IDLE :                                   // 空闲状态
            begin
                if(fifo_empty == 1'b0)                 // FIFO不为空
                begin
                    if((fifo_rdata != 11'b0) && (y_cnt == C_DST_IMG_HEIGHT))  // 已完成一帧
                        state <= S_RD_FIFO;
                    else
                        state <= S_Y_LOAD;
                end
                else
                    state <= S_IDLE;
            end
            S_Y_LOAD :                                 // Y加载判断状态
            begin
                // 检查是否可以处理下一行:
                // 1. 源图像行号足够(y_dec[26:16] + 1 <= fifo_rdata)
                // 2. 或已到达最后一行
                // 3. 或针对大倍率放大的特殊处理
                if((y_dec[26:16] + 1'b1 <= fifo_rdata) || (y_cnt == C_DST_IMG_HEIGHT - 1'b1) || 
                   ((y_cnt == C_DST_IMG_HEIGHT - 2'd2) && (C_DST_IMG_HEIGHT >= 2*C_SRC_IMG_HEIGHT)) ||
                   ((y_cnt == C_DST_IMG_HEIGHT - 2'd3) && (C_DST_IMG_HEIGHT >= 3*C_SRC_IMG_HEIGHT)) ||
                   ((y_cnt == C_DST_IMG_HEIGHT - 3'd4) && (C_DST_IMG_HEIGHT >= 4*C_SRC_IMG_HEIGHT)))
                    state <= S_BRAM_ADDR;
                else
                    state <= S_RD_FIFO;                // 需要等待更多源数据
            end
            S_BRAM_ADDR :                              // BRAM寻址和输出状态
            begin
                if(x_cnt == C_DST_IMG_WIDTH - 1'b1)    // 一行输出完成
                    state <= S_Y_INC;
                else
                    state <= S_BRAM_ADDR;              // 继续输出当前行
            end
            S_Y_INC :                                  // Y递增状态
            begin
                if(y_cnt == C_DST_IMG_HEIGHT - 1'b1)   // 一帧输出完成
                    state <= S_RD_FIFO;
                else
                    state <= S_Y_LOAD;                 // 继续下一行
            end
            S_RD_FIFO :                                // 读FIFO状态
            begin
                state <= S_IDLE;
            end
            default : 
            begin
                state <= S_IDLE;
            end
        endcase
    end
end

// FIFO读使能信号: 仅在RD_FIFO状态时读取
assign fifo_renb = (state == S_RD_FIFO) ? 1'b1 : 1'b0;

// Y方向定点坐标更新逻辑
// y_dec格式: [26:16]整数部分, [15:0]小数部分
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        y_dec <= 27'b0;
    else
    begin
        if((state == S_IDLE) && (fifo_empty == 1'b0) && (fifo_rdata == 11'b0))  // 新帧开始
            y_dec <= 27'b0;
        else if(state == S_Y_INC)                      // 每输出一行,Y坐标递增
            y_dec <= y_dec + C_Y_RATIO;                // 加上Y方向缩放步长
        else
            y_dec <= y_dec;
    end
end

// 输出图像Y计数器(行号)
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        y_cnt <= 11'b0;
    else
    begin
        if((state == S_IDLE) && (fifo_empty == 1'b0) && (fifo_rdata == 11'b0))  // 新帧开始
            y_cnt <= 11'b0;
        else if(state == S_Y_INC)                      // 每输出一行递增
            y_cnt <= y_cnt + 1'b1;
        else
            y_cnt <= y_cnt;
    end
end

// X方向定点坐标更新逻辑
// x_dec格式: [26:16]整数部分, [15:0]小数部分
always @(posedge clk_in2)
begin
    if(state == S_BRAM_ADDR)                           // 在输出行数据时
        x_dec <= x_dec + C_X_RATIO;                    // 每像素递增X缩放步长
    else
        x_dec <= 27'b0;                                // 行结束时清零
end

// 输出图像X计数器(列号)
always @(posedge clk_in2)
begin
    if(state == S_BRAM_ADDR)                           // 在输出行数据时递增
        x_cnt <= x_cnt + 1'b1;
    else
        x_cnt <= 11'b0;                                // 行结束时清零
end

//============================================================================
// 双线性插值流水线 - 共10级流水线
// c1: 提取坐标整数和小数部分,生成场同步和行同步信号
//============================================================================
reg                             img_vs_c1;             // 场同步信号c1
reg                             debug_flag;            // 调试标志(未使用)

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c1 <= 1'b0;
        debug_flag <= 0;
    end
    else
    begin
        if((state == S_BRAM_ADDR) && (x_cnt == 11'b0) && (y_cnt == 11'b0))  // 帧起始
            img_vs_c1 <= 1'b1;
        else if((state == S_Y_INC) && (y_cnt == C_DST_IMG_HEIGHT - 1'b1))   // 帧结束
        begin
            img_vs_c1 <= 1'b0;
        end
        else
            img_vs_c1 <= img_vs_c1;
    end
end

reg                             img_hs_c1;             // 行同步信号c1

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        img_hs_c1 <= 1'b0;
    else
    begin
        if(state == S_BRAM_ADDR)                       // 在输出行数据时有效
            img_hs_c1 <= 1'b1;
        else
            img_hs_c1 <= 1'b0;
    end
end

// 提取坐标的整数和小数部分
reg             [10:0]          x_int_c1;              // X整数部分
reg             [10:0]          y_int_c1;              // Y整数部分
reg             [16:0]          x_fra_c1;              // X小数部分
reg             [16:0]          inv_x_fra_c1;          // 1 - X小数部分
reg             [16:0]          y_fra_c1;              // Y小数部分
reg             [16:0]          inv_y_fra_c1;          // 1 - Y小数部分

always @(posedge clk_in2)
begin
    x_int_c1     <= x_dec[25:16];                      // 取整数部分[25:16]
    y_int_c1     <= y_dec[25:16];
    x_fra_c1     <= {1'b0, x_dec[15:0]};              // 取小数部分[15:0]
    inv_x_fra_c1 <= 17'h10000 - {1'b0, x_dec[15:0]};  // 计算补数(1-小数部分)
    y_fra_c1     <= {1'b0, y_dec[15:0]};
    inv_y_fra_c1 <= 17'h10000 - {1'b0, y_dec[15:0]};
end

//----------------------------------------------------------------------
//============================================================================
// c2: 计算BRAM地址和双线性插值权重系数
//============================================================================
reg                             img_vs_c2;
reg                             img_hs_c2;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c2 <= 1'b0;
        img_hs_c2 <= 1'b0;
    end
    else
    begin
        img_vs_c2 <= img_vs_c1;                        // 延迟一拍
        img_hs_c2 <= img_hs_c1;
    end
end

// BRAM地址和插值系数计算
reg             [11:0]          bram_addr_c2;          // BRAM读地址
reg             [33:0]          frac_00_c2;            // 左上角权重: (1-dx)*(1-dy)
reg             [33:0]          frac_01_c2;            // 右上角权重: dx*(1-dy)
reg             [33:0]          frac_10_c2;            // 左下角权重: (1-dx)*dy
reg             [33:0]          frac_11_c2;            // 右下角权重: dx*dy
reg                             bram_mode_c2;          // BRAM选择模式(奇偶行)

always @(posedge clk_in2)
begin
    bram_addr_c2 <= {y_int_c1[2:1], 10'b0} + x_int_c1; // 计算BRAM基地址
    frac_00_c2   <= inv_x_fra_c1 * inv_y_fra_c1;       // 左上角权重
    frac_01_c2   <= x_fra_c1 * inv_y_fra_c1;           // 右上角权重
    frac_10_c2   <= inv_x_fra_c1 * y_fra_c1;           // 左下角权重
    frac_11_c2   <= x_fra_c1 * y_fra_c1;               // 右下角权重
    bram_mode_c2 <= y_int_c1[0];                       // 根据Y坐标奇偶选择BRAM
end

// 边界像素扩展标志
reg                             right_pixel_extand_flag_c2;   // 右边界标志
reg                             bottom_pixel_extand_flag_c2;  // 下边界标志

always @(posedge clk_in2)
begin
    if(x_int_c1 == C_SRC_IMG_WIDTH - 1'b1)             // 到达图像右边界
        right_pixel_extand_flag_c2 <= 1'b1;
    else
        right_pixel_extand_flag_c2 <= 1'b0;
    if(y_int_c1 == C_SRC_IMG_HEIGHT - 1'b1)            // 到达图像下边界
        bottom_pixel_extand_flag_c2 <= 1'b1;
    else
        bottom_pixel_extand_flag_c2 <= 1'b0;
end

// 最近邻插值模式: 判断使用哪个像素
reg                             xmax_c2;               // X方向最近邻选择
reg                             ymax_c2;               // Y方向最近邻选择

always @(posedge clk_in2)
begin
    if(x_fra_c1 < inv_x_fra_c1)                        // 小数部分<0.5,选左侧
        xmax_c2 <= 1'b0;
    else
        xmax_c2 <= 1'b1;                               // 否则选右侧
    if(y_fra_c1 < inv_y_fra_c1)                        // 小数部分<0.5,选上方
        ymax_c2 <= 1'b0;
    else
        ymax_c2 <= 1'b1;                               // 否则选下方
end

//----------------------------------------------------------------------
//============================================================================
// c3: 根据模式设置BRAM读地址,传递权重和标志
//============================================================================
reg                             img_vs_c3;
reg                             img_hs_c3;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c3 <= 1'b0;
        img_hs_c3 <= 1'b0;
    end
    else
    begin
        img_vs_c3 <= img_vs_c2;
        img_hs_c3 <= img_hs_c2;
    end
end

// 根据bram_mode选择不同的BRAM读地址
// mode=0: 读取偶数行对(行0-1, 行2-3...)
// mode=1: 读取奇数行对(行1-2, 行3-4...)
always @(posedge clk_in2)
begin
    if(bram_mode_c2 == 1'b0)                           // 偶数模式
    begin
        even_bram1_b_raddr <= bram_addr_c2;            // 左上
        odd_bram1_b_raddr  <= bram_addr_c2 + 1'b1;     // 右上
        even_bram2_b_raddr <= bram_addr_c2;            // 左下
        odd_bram2_b_raddr  <= bram_addr_c2 + 1'b1;     // 右下
    end
    else                                               // 奇数模式
    begin
        even_bram1_b_raddr <= bram_addr_c2 + 11'd1024; // 左上(跨行)
        odd_bram1_b_raddr  <= bram_addr_c2 + 11'd1025; // 右上(跨行)
        even_bram2_b_raddr <= bram_addr_c2;            // 左下
        odd_bram2_b_raddr  <= bram_addr_c2 + 1'b1;     // 右下
    end
end

// 传递权重系数和标志到下一级
reg             [33:0]          frac_00_c3;
reg             [33:0]          frac_01_c3;
reg             [33:0]          frac_10_c3;
reg             [33:0]          frac_11_c3;
reg                             bram_mode_c3;
reg                             right_pixel_extand_flag_c3;
reg                             bottom_pixel_extand_flag_c3;

always @(posedge clk_in2)
begin
    frac_00_c3                  <= frac_00_c2;
    frac_01_c3                  <= frac_01_c2;
    frac_10_c3                  <= frac_10_c2;
    frac_11_c3                  <= frac_11_c2;
    bram_mode_c3                <= bram_mode_c2;
    right_pixel_extand_flag_c3  <= right_pixel_extand_flag_c2;
    bottom_pixel_extand_flag_c3 <= bottom_pixel_extand_flag_c2;   
end

reg                             xmax_c3;
reg                             ymax_c3;
always @(posedge clk_in2)
begin
    xmax_c3     <= xmax_c2;
    ymax_c3     <= ymax_c2;
end

//----------------------------------------------------------------------
//============================================================================
// c4: 继续传递权重和标志(流水线延迟级)
//============================================================================
reg                             img_vs_c4;
reg                             img_hs_c4;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c4 <= 1'b0;
        img_hs_c4 <= 1'b0;
    end
    else
    begin
        img_vs_c4 <= img_vs_c3;
        img_hs_c4 <= img_hs_c3;
    end
end

reg             [33:0]          frac_00_c4;
reg             [33:0]          frac_01_c4;
reg             [33:0]          frac_10_c4;
reg             [33:0]          frac_11_c4;
reg                             bram_mode_c4;
reg                             right_pixel_extand_flag_c4;
reg                             bottom_pixel_extand_flag_c4;
reg                             xmax_c4;
reg                             ymax_c4;

always @(posedge clk_in2)
begin
    frac_00_c4                  <= frac_00_c3;
    frac_01_c4                  <= frac_01_c3;
    frac_10_c4                  <= frac_10_c3;
    frac_11_c4                  <= frac_11_c3;
    bram_mode_c4                <= bram_mode_c3;
    right_pixel_extand_flag_c4  <= right_pixel_extand_flag_c3;
    bottom_pixel_extand_flag_c4 <= bottom_pixel_extand_flag_c3;
    xmax_c4                     <= xmax_c3;
    ymax_c4                     <= ymax_c3;
end

//----------------------------------------------------------------------
//============================================================================
// c5: 从BRAM读取4个相邻像素数据,根据模式重排
//============================================================================
reg                             img_vs_c5;
reg                             img_hs_c5;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c5 <= 1'b0;
        img_hs_c5 <= 1'b0;
    end
    else
    begin
        img_vs_c5 <= img_vs_c4;
        img_hs_c5 <= img_hs_c4;
    end
end

// 根据BRAM模式重新排列读取的4个像素
// pixel_data00: 左上, pixel_data01: 右上
// pixel_data10: 左下, pixel_data11: 右下
reg             [7:0]           pixel_data00_c5;
reg             [7:0]           pixel_data01_c5;
reg             [7:0]           pixel_data10_c5;
reg             [7:0]           pixel_data11_c5;

always @(posedge clk_in2)
begin
    if(bram_mode_c4 == 1'b0)                           // 偶数模式
    begin
        pixel_data00_c5 <= even_bram1_b_rdata;         // 左上
        pixel_data01_c5 <= odd_bram1_b_rdata;          // 右上
        pixel_data10_c5 <= even_bram2_b_rdata;         // 左下
        pixel_data11_c5 <= odd_bram2_b_rdata;          // 右下
    end
    else                                               // 奇数模式
    begin
        pixel_data00_c5 <= even_bram2_b_rdata;         // 左上(行交换)
        pixel_data01_c5 <= odd_bram2_b_rdata;          // 右上
        pixel_data10_c5 <= even_bram1_b_rdata;         // 左下
        pixel_data11_c5 <= odd_bram1_b_rdata;          // 右下
    end
end

reg             [33:0]          frac_00_c5;
reg             [33:0]          frac_01_c5;
reg             [33:0]          frac_10_c5;
reg             [33:0]          frac_11_c5;
reg                             right_pixel_extand_flag_c5;
reg                             bottom_pixel_extand_flag_c5;
reg                             xmax_c5;
reg                             ymax_c5;

always @(posedge clk_in2)
begin
    frac_00_c5                  <= frac_00_c4;
    frac_01_c5                  <= frac_01_c4;
    frac_10_c5                  <= frac_10_c4;
    frac_11_c5                  <= frac_11_c4;
    right_pixel_extand_flag_c5  <= right_pixel_extand_flag_c4;
    bottom_pixel_extand_flag_c5 <= bottom_pixel_extand_flag_c4;
    xmax_c5                     <= xmax_c4;
    ymax_c5                     <= ymax_c4;
end

//----------------------------------------------------------------------
//============================================================================
// c6: 边界像素扩展处理
//============================================================================
reg                             img_vs_c6;
reg                             img_hs_c6;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c6 <= 1'b0;
        img_hs_c6 <= 1'b0;
    end
    else
    begin
        img_vs_c6 <= img_vs_c5;
        img_hs_c6 <= img_hs_c5;
    end
end

// 边界像素扩展逻辑
// 当到达图像边界时,复制边界像素以避免读取越界
reg             [7:0]           pixel_data00_c6;
reg             [7:0]           pixel_data01_c6;
reg             [7:0]           pixel_data10_c6;
reg             [7:0]           pixel_data11_c6;

always @(posedge clk_in2)
begin
    case({right_pixel_extand_flag_c5, bottom_pixel_extand_flag_c5})
        2'b00 :                                        // 非边界区域,直接传递
        begin
            pixel_data00_c6 <= pixel_data00_c5;
            pixel_data01_c6 <= pixel_data01_c5;
            pixel_data10_c6 <= pixel_data10_c5;
            pixel_data11_c6 <= pixel_data11_c5;
        end
        2'b01 :                                        // 下边界,复制上方像素
        begin
            pixel_data00_c6 <= pixel_data00_c5;
            pixel_data01_c6 <= pixel_data01_c5;
            pixel_data10_c6 <= pixel_data00_c5;        // 左下=左上
            pixel_data11_c6 <= pixel_data01_c5;        // 右下=右上
        end
        2'b10 :                                        // 右边界,复制左侧像素
        begin
            pixel_data00_c6 <= pixel_data00_c5;
            pixel_data01_c6 <= pixel_data00_c5;        // 右上=左上
            pixel_data10_c6 <= pixel_data10_c5;
            pixel_data11_c6 <= pixel_data10_c5;        // 右下=左下
        end
        2'b11 :                                        // 右下角,全部使用左上像素
        begin
            pixel_data00_c6 <= pixel_data00_c5;
            pixel_data01_c6 <= pixel_data00_c5;
            pixel_data10_c6 <= pixel_data00_c5;
            pixel_data11_c6 <= pixel_data00_c5;
        end
    endcase
end

reg             [33:0]          frac_00_c6;
reg             [33:0]          frac_01_c6;
reg             [33:0]          frac_10_c6;
reg             [33:0]          frac_11_c6;
reg                             xmax_c6;
reg                             ymax_c6;

always @(posedge clk_in2)
begin
    frac_00_c6 <= frac_00_c5;
    frac_01_c6 <= frac_01_c5;
    frac_10_c6 <= frac_10_c5;
    frac_11_c6 <= frac_11_c5;
    xmax_c6    <= xmax_c5;
    ymax_c6    <= ymax_c5;
end

//----------------------------------------------------------------------
//============================================================================
// c7: 加权乘法运算(双线性插值第一步)
//============================================================================
reg                             img_vs_c7;
reg                             img_hs_c7;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c7 <= 1'b0;
        img_hs_c7 <= 1'b0;
    end
    else
    begin
        img_vs_c7 <= img_vs_c6;
        img_hs_c7 <= img_hs_c6;
    end
end

// 计算加权像素值: 权重 × 像素值
// 双线性插值公式: f(x,y) = f00*(1-dx)*(1-dy) + f01*dx*(1-dy) + f10*(1-dx)*dy + f11*dx*dy
reg             [41:0]          gray_data00_c7;        // 左上角加权值
reg             [41:0]          gray_data01_c7;        // 右上角加权值
reg             [41:0]          gray_data10_c7;        // 左下角加权值
reg             [41:0]          gray_data11_c7;        // 右下角加权值

always @(posedge clk_in2)
begin
    gray_data00_c7 <= frac_00_c6 * pixel_data00_c6;
    gray_data01_c7 <= frac_01_c6 * pixel_data01_c6;
    gray_data10_c7 <= frac_10_c6 * pixel_data10_c6;
    gray_data11_c7 <= frac_11_c6 * pixel_data11_c6;
end

// 最近邻插值模式: 直接选择最接近的像素
reg             [7:0]          gray_data_max_c7;

always @(posedge clk_in2)
begin
    case({ymax_c6, xmax_c6})
        2'b00 :  gray_data_max_c7 <= pixel_data00_c6; // 左上
        2'b01 :  gray_data_max_c7 <= pixel_data01_c6; // 右上
        2'b10 :  gray_data_max_c7 <= pixel_data10_c6; // 左下
        2'b11 :  gray_data_max_c7 <= pixel_data11_c6; // 右下
    endcase
end

//----------------------------------------------------------------------
//============================================================================
// c8: 两两相加(双线性插值第二步)
//============================================================================
reg                             img_vs_c8;
reg                             img_hs_c8;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c8 <= 1'b0;
        img_hs_c8 <= 1'b0;
    end
    else
    begin
        img_vs_c8 <= img_vs_c7;
        img_hs_c8 <= img_hs_c7;
    end
end

// 将4个加权值两两相加
reg             [42:0]          gray_data_tmp1_c8;     // 上方两像素和
reg             [42:0]          gray_data_tmp2_c8;     // 下方两像素和

always @(posedge clk_in2)
begin
    gray_data_tmp1_c8 <= gray_data00_c7 + gray_data01_c7;
    gray_data_tmp2_c8 <= gray_data10_c7 + gray_data11_c7;
end

reg             [7:0]          gray_data_max_c8;
always @(posedge clk_in2)
begin
    gray_data_max_c8 <= gray_data_max_c7;
end

//----------------------------------------------------------------------
//============================================================================
// c9: 最终求和(双线性插值第三步)
//============================================================================
reg                             img_vs_c9;
reg                             img_hs_c9;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c9 <= 1'b0;
        img_hs_c9 <= 1'b0;
    end
    else
    begin
        img_vs_c9 <= img_vs_c8;
        img_hs_c9 <= img_hs_c8;
    end
end

// 将两个中间结果相加,得到最终插值结果(仍为定点数)
reg             [43:0]          gray_data_c9;

always @(posedge clk_in2)
begin
    gray_data_c9 <= gray_data_tmp1_c8 + gray_data_tmp2_c8;
end

reg             [7:0]          gray_data_max_c9;
always @(posedge clk_in2)
begin
    gray_data_max_c9 <= gray_data_max_c8;
end

//----------------------------------------------------------------------
//============================================================================
// c10: 定点数转整数,饱和处理
//============================================================================
reg                             img_vs_c10;
reg                             img_hs_c10;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c10 <= 1'b0;
        img_hs_c10 <= 1'b0;
    end
    else
    begin
        img_vs_c10 <= img_vs_c9;
        img_hs_c10 <= img_hs_c9;
    end
end

// 定点数转整数: 取高位并进行四舍五入
reg             [11:0]          gray_data_c10;

always @(posedge clk_in2)
begin
    gray_data_c10 <= gray_data_c9[43:32] + gray_data_c9[31]; // [43:32]取整数部分,[31]用于四舍五入
end

reg             [7:0]          gray_data_max_c10;
always @(posedge clk_in2)
begin
    gray_data_max_c10 <= gray_data_max_c9;
end

//============================================================================
// 场同步信号扩展逻辑
// 功能: 在帧结束后延长场同步信号20个时钟周期
//       这是为了确保下游模块有足够的时间处理帧结束事件
//============================================================================

// 检测img_vs_c10的下降沿(帧结束标志)
reg img_vs_c10_r;
wire img_vs_c10_nagedge;
always @(posedge clk_in2)begin
    if(rst_n == 1'b0)begin
        img_vs_c10_r <= 1'b0;
    end
    else begin
        img_vs_c10_r <= img_vs_c10;
    end
end
assign img_vs_c10_nagedge = img_vs_c10_r & (~img_vs_c10) ? 1'b1 : 1'b0;

// 场同步延长20+2个周期
reg [4:0] img_vs_c11_cnt;
reg img_vs_c11;
reg img_vs_c10_flag;

parameter img_vs_c11_cnt_max = 5'd20;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c11 <= 1'b0;
        img_vs_c10_flag <= 1'b0;        
        img_vs_c11_cnt <= 5'd0;
    end
    
    else if(img_vs_c10)begin                         // 正常帧期间保持高电平
        img_vs_c11 <= 1'b1;
    end
    
    else if (img_vs_c10_nagedge)                     // 检测到帧结束
    begin 
        img_vs_c10_flag <= 1'b1;                     // 启动延长计数
        img_vs_c11 <= 1'b1;
    end
    
    else if (img_vs_c10_flag && img_vs_c11_cnt < img_vs_c11_cnt_max)
    begin
        img_vs_c11 <= 1'b1;                          // 延长期间保持高电平
        img_vs_c11_cnt <= img_vs_c11_cnt + 5'd1;
    end
    
    else if (img_vs_c10_flag && img_vs_c11_cnt == img_vs_c11_cnt_max)
    begin
        img_vs_c11 <= 1'b0;                          // 延长结束
        img_vs_c11_cnt <= 5'd0;
        img_vs_c10_flag <= 1'b0;
    end
    
    else 
    begin
        img_vs_c11 <= 1'b0;
        img_vs_c11_cnt <= 5'd0;
        img_vs_c10_flag <= 1'b0;
    end
end

//----------------------------------------------------------------------
//============================================================================
// 输出信号生成
// 功能: 生成最终的输出图像数据流
//============================================================================
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        post_img_vsync <= 1'b0;
        post_img_href  <= 1'b0;
    end
    else
    begin
        // 场同步信号: 包含c10, c9和延长后的c11阶段
        // 这样可以确保场同步信号覆盖整个帧传输过程
        post_img_vsync <= (img_vs_c10 || img_vs_c9 || img_vs_c11);
        post_img_href  <= img_hs_c10;                // 行同步信号
    end
end

// 输出灰度数据选择
always @(posedge clk_in2)
begin
    if(gray_data_c10 > 12'd255)                      // 饱和处理
        post_img_gray <= 8'd255;
    else
    begin
        if(out_model == 0)                           // 模式0: 最近邻插值
            post_img_gray <= gray_data_max_c10;
        else                                         // 模式1: 双线性插值
            post_img_gray <= gray_data_c10[7:0];
    end
end

endmodule