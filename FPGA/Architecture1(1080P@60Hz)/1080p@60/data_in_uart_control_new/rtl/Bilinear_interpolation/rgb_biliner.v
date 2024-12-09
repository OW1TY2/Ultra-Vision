module rgb_biliner
#(
    parameter C_SRC_IMG_WIDTH  = 12'd640,
    parameter C_SRC_IMG_HEIGHT = 12'd480
)
(
    input  wire                 clk_in1,//数据输入时钟
    input  wire                 clk_in2,//数据输出时钟
    input  wire                 rst_n,
    
    //  输入图像数据
    input  wire                     per_img_vsync,
    input  wire                     per_img_href,
    input  wire     [ 7:0]          per_img_red,
    input  wire     [ 7:0]          per_img_green,
    input  wire     [ 7:0]          per_img_blue,
    input  wire     [11:0]          c_dst_img_width,     
    input  wire     [11:0]          c_dst_img_height,  
    
    //  输出图像数据
    output reg                  post_img_vsync,
    output reg                  post_img_href,
    output reg      [31:0]      post_img_data, // 32位输出
    output wire         [11:0]              C_DST_IMG_WIDTH,
    output wire         [11:0]              C_DST_IMG_HEIGHT
);

// 内部信号
wire [7:0] post_red, post_green, post_blue;
wire red_vsync, red_href, green_vsync, green_href, blue_vsync, blue_href;

// 实例化三个双线性插值模块
bilinear_interpolation #(
    .C_SRC_IMG_WIDTH(C_SRC_IMG_WIDTH),
    .C_SRC_IMG_HEIGHT(C_SRC_IMG_HEIGHT)
) red_interp (
    .clk_in1(clk_in1),
    .clk_in2(clk_in2),
    .rst_n(rst_n),
    .per_img_vsync(per_img_vsync),
    .per_img_href(per_img_href),
    .per_img_gray(per_img_red),
    .post_img_vsync(red_vsync),
    .post_img_href(red_href),
    .post_img_gray(post_red),
    .c_dst_img_width(c_dst_img_width),
    .c_dst_img_height(c_dst_img_height),
    .C_DST_IMG_WIDTH (C_DST_IMG_WIDTH),
    .C_DST_IMG_HEIGHT(C_DST_IMG_HEIGHT)
);


bilinear_interpolation #(
    .C_SRC_IMG_WIDTH(C_SRC_IMG_WIDTH),
    .C_SRC_IMG_HEIGHT(C_SRC_IMG_HEIGHT)
) green_interp (
    .clk_in1(clk_in1),
    .clk_in2(clk_in2),
    .rst_n(rst_n),
    .per_img_vsync(per_img_vsync),
    .per_img_href(per_img_href),
    .per_img_gray(per_img_green),
    .post_img_vsync(green_vsync),
    .post_img_href(green_href),
    .post_img_gray(post_green),
    .c_dst_img_width(c_dst_img_width),
    .c_dst_img_height(c_dst_img_height),
    .C_DST_IMG_WIDTH (),
    .C_DST_IMG_HEIGHT()
);

bilinear_interpolation #(
    .C_SRC_IMG_WIDTH(C_SRC_IMG_WIDTH),
    .C_SRC_IMG_HEIGHT(C_SRC_IMG_HEIGHT)
) blue_interp (
    .clk_in1(clk_in1),
    .clk_in2(clk_in2),
    .rst_n(rst_n),
    .per_img_vsync(per_img_vsync),
    .per_img_href(per_img_href),
    .per_img_gray(per_img_blue),
    .post_img_vsync(blue_vsync),
    .post_img_href(blue_href),
    .post_img_gray(post_blue),
    .c_dst_img_width(c_dst_img_width),
    .c_dst_img_height(c_dst_img_height),
    .C_DST_IMG_WIDTH (),
    .C_DST_IMG_HEIGHT()
);

// 合并输出
always @(posedge clk_in2 or negedge rst_n) begin
    if (rst_n==0) begin
        post_img_vsync <= 0;
        post_img_href <= 0;
        post_img_data <= 32'h0;
    end 
    else begin
        // 确保行场信号同步
        post_img_vsync <= red_vsync ;
        post_img_href <= red_href ;

        // 输出数据
        post_img_data <= {8'h0, post_red, post_green, post_blue};
    end
end

endmodule
