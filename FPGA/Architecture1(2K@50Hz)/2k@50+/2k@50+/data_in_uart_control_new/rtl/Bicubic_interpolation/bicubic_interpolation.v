// *********************************************************************
// this is gray pixel bilinear interpolation
// *********************************************************************
module bicubic_interpolation
#(
    parameter C_SRC_IMG_WIDTH  = 12'd640    ,
    parameter C_SRC_IMG_HEIGHT = 12'd480   
    // parameter C_DST_IMG_WIDTH  = 11'd10   ,
    // parameter C_DST_IMG_HEIGHT = 11'd8    ,
    // parameter C_X_RATIO        = 16'd32768  ,           //  floor(C_SRC_IMG_WIDTH/C_DST_IMG_WIDTH*2^16)
    // parameter C_Y_RATIO        = 16'd32768              //  floor(C_SRC_IMG_HEIGHT/C_DST_IMG_HEIGHT*2^16)
)
(
    input  wire                 clk_in1         ,
    input  wire                 clk_in2         ,
    input  wire                 rst_n           ,
    input  wire     [1:0]       out_model       ,
    
    //  Image data prepared to be processed
    input  wire                 per_img_vsync   ,       //  Prepared Image data vsync valid signal
    input  wire                 per_img_href    ,       //  Prepared Image data href vaild  signal
    input  wire     [7:0]       per_img_gray    ,       //  Prepared Image brightness input
    
    //  Image data has been processed
    output reg                  post_img_vsync  ,       //  processed Image data vsync valid signal
    output reg                  post_img_href   ,       //  processed Image data href vaild  signal
    output reg      [7:0]       post_img_gray  ,         //  processed Image brightness output

    input  wire  [11:0] c_dst_img_width,
    input  wire  [11:0] c_dst_img_height,

    input    wire            [33:0] coeff00_c11, coeff01_c11, coeff02_c11, coeff03_c11,
    input    wire            [33:0] coeff10_c11, coeff11_c11, coeff12_c11, coeff13_c11,
    input    wire            [33:0] coeff20_c11, coeff21_c11, coeff22_c11, coeff23_c11,
    input    wire            [33:0] coeff30_c11, coeff31_c11, coeff32_c11, coeff33_c11,

    input    wire            [33:0] frac_00_c2, frac_01_c2, frac_10_c2, frac_11_c2,

    output   reg             [16:0]          x_fra_c1,
    output   reg             [16:0]          y_fra_c1,
    output   reg             [16:0]          inv_x_fra_c1,
    output   reg             [16:0]          inv_y_fra_c1,
    output reg         [11:0]              C_DST_IMG_WIDTH,
    output reg         [11:0]              C_DST_IMG_HEIGHT
);
//----------------------------------------------------------------------

//--------------------------------my own--------------------------------------

reg                             post_img_vsync_dly;
wire                            post_img_vsync_neg;
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        post_img_vsync_dly <= 1'b0;
    else
        post_img_vsync_dly <= post_img_vsync;
end
assign post_img_vsync_neg = post_img_vsync_dly & ~post_img_vsync;


reg         [11:0]              C_DST_IMG_WIDTH;
reg         [11:0]              C_DST_IMG_HEIGHT;

// c1-----

reg                             post_img_vsync_neg_c1;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        post_img_vsync_neg_c1 =0;
    end
    else begin
        post_img_vsync_neg_c1 <=post_img_vsync_neg;
    end
end

//c1.5
reg                             post_img_vsync_neg_c1_5;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        post_img_vsync_neg_c1_5 =0;
    end
    else begin
        post_img_vsync_neg_c1_5 <=post_img_vsync_neg_c1;
    end
end


// c2-----

reg                             post_img_vsync_neg_c2;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        C_DST_IMG_WIDTH  <= 640;
        C_DST_IMG_HEIGHT <= 480;
    end
    else begin
        if(post_img_vsync_neg_c1_5 == 1) 
        begin
            C_DST_IMG_WIDTH  <= c_dst_img_width;
            C_DST_IMG_HEIGHT <= c_dst_img_height;
            post_img_vsync_neg_c2 <= 1;
        end
        else
        begin
            C_DST_IMG_WIDTH  <= C_DST_IMG_WIDTH;
            C_DST_IMG_HEIGHT <= C_DST_IMG_HEIGHT;
            post_img_vsync_neg_c2 <= 0;
        end
    end
end


//c3-----
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
        if(post_img_vsync_neg_c2 ==1) begin
            multi_tmp1_c2 <=(C_SRC_IMG_WIDTH <<16) ;// C_DST_IMG_WIDTH ;//  floor(C_SRC_IMG_WIDTH/C_DST_IMG_WIDTH*2^16)
            multi_tmp2_c2 <=(C_SRC_IMG_HEIGHT <<16) ;// C_DST_IMG_HEIGHT ;//  floor(C_SRC_IMG_HEIGHT/C_DST_IMG_HEIGHT*2^16)
            post_img_vsync_neg_c3 <=1;
        end
        else begin
            multi_tmp1_c2 <=multi_tmp1_c2;
            multi_tmp2_c2 <=multi_tmp2_c2;
            post_img_vsync_neg_c3 <=0;
        end
    end
end

//c4-------
reg         [16:0]              C_X_RATIO;
reg         [16:0]              C_Y_RATIO;
reg    divide_clken;
wire    rfd;
wire    rfd1;
wire   [26:0]   c_x_ratio_divide;
wire   [26:0]   c_y_ratio_divide;
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        divide_clken  <= 0; 
    end
    else begin
        if(post_img_vsync_neg_c3 ==1 && rfd ==0) begin
            divide_clken <= 1;
        end
        else if(post_img_vsync_neg_c3 ==0 && rfd ==1) begin
            divide_clken <= 0;
        end else
            divide_clken <= divide_clken;
    end
end

divider_ip ux_divider_ip(  
    .numer(multi_tmp1_c2), //  floor(C_SRC_IMG_WIDTH/C_DST_IMG_WIDTH*2^16)
    .denom(C_DST_IMG_WIDTH),
    .clken(divide_clken),
    .clk(clk_in2),
    .reset(1'b0),
    .quotient(c_x_ratio_divide),
    .remain(),
    .rfd(rfd1)

);
divider_ip uy_divider_ip(
    .numer(multi_tmp2_c2),
    .denom(C_DST_IMG_HEIGHT),
    .clken(divide_clken),
    .clk(clk_in2),
    .reset(1'b0),
    .quotient(c_y_ratio_divide),
    .remain(),
    .rfd(rfd)

);
always@(posedge clk_in2)
begin
    if(rst_n == 1'b0)begin
        C_X_RATIO  <= 65536; 
        C_Y_RATIO  <= 65536; 
    end
    else begin
        if (rfd ==1) begin
            C_X_RATIO  <= c_x_ratio_divide; 
            C_Y_RATIO  <= c_y_ratio_divide; 
        end else begin
            C_X_RATIO  <= C_X_RATIO; 
            C_Y_RATIO  <= C_Y_RATIO; 
        end
    end
end


//---------------------------end my own---------------------------------------------------


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

reg             [10:0]          img_vs_cnt;                             //  from 0 to C_SRC_IMG_HEIGHT - 1

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        img_vs_cnt <= 11'b0;
    else
    begin
        if(per_img_vsync == 1'b0)
            img_vs_cnt <= 11'b0;
        else
        begin
            if(per_img_href_neg == 1'b1)
                img_vs_cnt <= img_vs_cnt + 1'b1;
            else
                img_vs_cnt <= img_vs_cnt;
        end
    end
end

reg             [10:0]          img_hs_cnt;                             //  from 0 to C_SRC_IMG_WIDTH - 1

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        img_hs_cnt <= 11'b0;
    else
    begin
        if((per_img_vsync == 1'b1)&&(per_img_href == 1'b1))
            img_hs_cnt <= img_hs_cnt + 1'b1;
        else
            img_hs_cnt <= 11'b0;
    end
end

//----------------------------------------------------------------------
reg             [7:0]           bram_wdata;

always @(posedge clk_in1)
begin
    bram_wdata <= per_img_gray;
end

reg             [10:0]          bram_waddr;

always @(posedge clk_in1)
begin
    bram_waddr <= {img_vs_cnt[2],10'b0} + img_hs_cnt;
end

//-------------------------------bram wirte control begin --------------------
reg                             bram0_wenb;
always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        bram0_wenb <= 1'b0;
    else
        bram0_wenb <= per_img_vsync & per_img_href & ~img_vs_cnt[1]& ~img_vs_cnt[0];
end


reg                             bram1_wenb;
always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        bram1_wenb <= 1'b0;
    else
        bram1_wenb <= per_img_vsync & per_img_href & ~img_vs_cnt[1]& img_vs_cnt[0];
end


reg                             bram2_wenb;
always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        bram2_wenb <= 1'b0;
    else
        bram2_wenb <= per_img_vsync & per_img_href & img_vs_cnt[1]& ~img_vs_cnt[0];
end


reg                             bram3_wenb;
always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        bram3_wenb <= 1'b0;
    else
        bram3_wenb <= per_img_vsync & per_img_href & img_vs_cnt[1]& img_vs_cnt[0];
end

//-------------------------------bram wirte control end -----------------------

reg             [10:0]          fifo_wdata;

always @(posedge clk_in1)
begin
    fifo_wdata <= img_vs_cnt;
end

reg                             fifo_wenb;

always @(posedge clk_in1)
begin
    if(rst_n == 1'b0)
        fifo_wenb <= 1'b0;
    else
    begin
        if((per_img_vsync == 1'b1)&&(per_img_href == 1'b1)&&(img_hs_cnt == C_SRC_IMG_WIDTH - 1'b1))
            fifo_wenb <= 1'b1;
        else
            fifo_wenb <= 1'b0;
    end
end

//----------------------------------------------------------------------
//  bram & fifo rw
reg             [10:0]          bram11_raddr,bram12_raddr,bram13_raddr,bram14_raddr;
reg             [10:0]          bram21_raddr,bram22_raddr,bram23_raddr,bram24_raddr;
reg             [10:0]          bram31_raddr,bram32_raddr,bram33_raddr,bram34_raddr;
reg             [10:0]          bram41_raddr,bram42_raddr,bram43_raddr,bram44_raddr;

wire            [ 7:0]          bram11_rdata,bram12_rdata,bram13_rdata,bram14_rdata;
wire            [ 7:0]          bram21_rdata,bram22_rdata,bram23_rdata,bram24_rdata;
wire            [ 7:0]          bram31_rdata,bram32_rdata,bram33_rdata,bram34_rdata;
wire            [ 7:0]          bram41_rdata,bram42_rdata,bram43_rdata,bram44_rdata;





my16bram u_my16bram (
    .clk_in1(clk_in1),
    .clk_in2(clk_in2), 

    .bram0_wenb(bram0_wenb),
    .bram1_wenb(bram1_wenb), 
    .bram2_wenb(bram2_wenb),
    .bram3_wenb(bram3_wenb), 
    .bram_waddr(bram_waddr),
    .bram_wdata(bram_wdata),

    .bram11_raddr(bram11_raddr),
    .bram12_raddr(bram12_raddr),
    .bram13_raddr(bram13_raddr),
    .bram14_raddr(bram14_raddr),

    .bram21_raddr(bram21_raddr),
    .bram22_raddr(bram22_raddr),
    .bram23_raddr(bram23_raddr),
    .bram24_raddr(bram24_raddr),

    .bram31_raddr(bram31_raddr),
    .bram32_raddr(bram32_raddr),
    .bram33_raddr(bram33_raddr),
    .bram34_raddr(bram34_raddr),

    .bram41_raddr(bram41_raddr),
    .bram42_raddr(bram42_raddr),
    .bram43_raddr(bram43_raddr),
    .bram44_raddr(bram44_raddr),
    
    .bram11_rdata(bram11_rdata),
    .bram12_rdata(bram12_rdata),
    .bram13_rdata(bram13_rdata),
    .bram14_rdata(bram14_rdata),

    .bram21_rdata(bram21_rdata),
    .bram22_rdata(bram22_rdata),
    .bram23_rdata(bram23_rdata),
    .bram24_rdata(bram24_rdata),

    .bram31_rdata(bram31_rdata),
    .bram32_rdata(bram32_rdata),
    .bram33_rdata(bram33_rdata),
    .bram34_rdata(bram34_rdata),

    .bram41_rdata(bram41_rdata),
    .bram42_rdata(bram42_rdata),
    .bram43_rdata(bram43_rdata),
    .bram44_rdata(bram44_rdata)
);

wire                            fifo_renb;
wire            [10:0]          fifo_rdata;
wire                            fifo_empty;
wire                            fifo_full;




asyn_fifo  u_asyn_fifo(
        .a_rst_i                           (   ~rst_n                       ), 
        .wdata                             (    fifo_wdata                  ),
        .rd_clk_i                          (     clk_in2                    ),
        .rd_en_i                           (      fifo_renb                 ),
        .wr_clk_i                          (       clk_in1                  ),
        .wr_en_i                           (       fifo_wenb                ),
        .rdata                             (       fifo_rdata               ),
        .full_o                            (      fifo_full                ),
        .empty_o                           (       fifo_empty                ),
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


localparam S_IDLE      = 3'd0;
localparam S_Y_LOAD    = 3'd1;
localparam S_BRAM_ADDR = 3'd2;
localparam S_Y_INC     = 3'd3;
localparam S_RD_FIFO   = 3'd4;

reg             [ 2:0]          state;
reg             [26:0]          y_dec;
reg             [26:0]          x_dec;
reg             [11:0]          y_cnt;
reg             [11:0]          x_cnt;




always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        state <= S_IDLE;
    else
    begin
        case(state)
            S_IDLE : 
            begin
                if(fifo_empty == 1'b0)
                begin
                    if((fifo_rdata != 11'b0)&&(y_cnt == C_DST_IMG_HEIGHT))
                        state <= S_RD_FIFO;
                    else
                        state <= S_Y_LOAD;
                end
                else
                    state <= S_IDLE;
            end
            S_Y_LOAD : 
            begin
                if((y_dec[26:16] + 2'd2 <= fifo_rdata)||
                   (y_cnt == C_DST_IMG_HEIGHT - 2'd2)||
                   (y_cnt == C_DST_IMG_HEIGHT - 1'b1)||
                   ((y_cnt == C_DST_IMG_HEIGHT - 3'd3)&&(C_DST_IMG_HEIGHT>=1.5*C_SRC_IMG_HEIGHT))||
                   ((y_cnt == C_DST_IMG_HEIGHT - 3'd4)&&(C_DST_IMG_HEIGHT>=2*C_SRC_IMG_HEIGHT))||
                   ((y_cnt == C_DST_IMG_HEIGHT - 3'd5)&&(C_DST_IMG_HEIGHT>=2.5*C_SRC_IMG_HEIGHT)))
                    state <= S_BRAM_ADDR;
                else
                    state <= S_RD_FIFO;
            end
            S_BRAM_ADDR : 
            begin
                if(x_cnt == C_DST_IMG_WIDTH - 1'b1)
                    state <= S_Y_INC;
                else
                    state <= S_BRAM_ADDR;
            end
            S_Y_INC : 
            begin
                if(y_cnt == C_DST_IMG_HEIGHT - 1'b1)
                    state <= S_RD_FIFO;
                else
                    state <= S_Y_LOAD;
            end
            S_RD_FIFO : 
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

assign fifo_renb = (state == S_RD_FIFO) ? 1'b1 : 1'b0;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        y_dec <= 27'b0;
    else
    begin
        if((state == S_IDLE)&&(fifo_empty == 1'b0)&&(fifo_rdata == 11'b0))
            y_dec <= 27'b0;
        else if(state == S_Y_INC)
            y_dec <= y_dec + C_Y_RATIO;
        else
            y_dec <= y_dec;
    end
end

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        y_cnt <= 11'b0;
    else
    begin
        if((state == S_IDLE)&&(fifo_empty == 1'b0)&&(fifo_rdata == 11'b0))
            y_cnt <= 11'b0;
        else if(state == S_Y_INC)
            y_cnt <= y_cnt + 1'b1;
        else
            y_cnt <= y_cnt;
    end
end

always @(posedge clk_in2)
begin
    if(state == S_BRAM_ADDR)
        x_dec <= x_dec + C_X_RATIO;
    else
        x_dec <= 27'b0;
end

always @(posedge clk_in2)
begin
    if(state == S_BRAM_ADDR)
        x_cnt <= x_cnt + 1'b1;
    else
        x_cnt <= 11'b0;
end

//----------------------------------------------------------------------
//  c1
reg                             img_vs_c1;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c1 <= 1'b0;
    end
    else
    begin
        if((state == S_BRAM_ADDR)&&(x_cnt == 11'b0)&&(y_cnt == 11'b0))
            img_vs_c1 <= 1'b1;
        else if((state == S_Y_INC)&&(y_cnt == C_DST_IMG_HEIGHT - 1'b1))
        begin
            img_vs_c1 <= 1'b0;
        end
        else
            img_vs_c1 <= img_vs_c1;
    end
end

reg                             img_hs_c1;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
        img_hs_c1 <= 1'b0;
    else
    begin
        if(state == S_BRAM_ADDR)
            img_hs_c1 <= 1'b1;
        else
            img_hs_c1 <= 1'b0;
    end
end

reg             [10:0]          x_int_c1;
reg             [10:0]          y_int_c1;




always @(posedge clk_in2)
begin
    x_int_c1     <= x_dec[25:16];
    y_int_c1     <= y_dec[25:16];
    x_fra_c1     <= {1'b0,x_dec[15:0]};
    inv_x_fra_c1 <= 17'h10000 - {1'b0,x_dec[15:0]};
    y_fra_c1     <= {1'b0,y_dec[15:0]};
    inv_y_fra_c1 <= 17'h10000 - {1'b0,y_dec[15:0]};

end

//----------------------------------------------------------------------
//  c2
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
        img_vs_c2 <= img_vs_c1;
        img_hs_c2 <= img_hs_c1;
    end
end

reg             [10:0]          bram_addr_c2;
reg             [ 1:0]          bram_mode_c2;

always @(posedge clk_in2)
begin
    bram_addr_c2 <= {y_int_c1[2],10'b0} + x_int_c1;
    bram_mode_c2 <= y_int_c1[1:0];
end

reg                             left_pixel_extand_flag_c2;
reg                             right_pixel_extand_flag_1_c2;
reg                             right_pixel_extand_flag_2_c2;
reg                             top_pixel_extand_flag_c2;
reg                             bottom_pixel_extand_flag_1_c2;
reg                             bottom_pixel_extand_flag_2_c2;

always @(posedge clk_in2)
begin
    if(x_int_c1 == 0)
        left_pixel_extand_flag_c2 <= 1'b1;
    else
        left_pixel_extand_flag_c2 <= 1'b0;

    if(x_int_c1 == C_SRC_IMG_WIDTH - 2'd2)
        right_pixel_extand_flag_1_c2 <= 1'b1;
    else
        right_pixel_extand_flag_1_c2 <= 1'b0;
    if(x_int_c1 == C_SRC_IMG_WIDTH - 2'd1)
        right_pixel_extand_flag_2_c2 <= 1'b1;
    else
        right_pixel_extand_flag_2_c2 <= 1'b0;


    if(y_int_c1 == 0)
        top_pixel_extand_flag_c2 <= 1'b1;
    else
        top_pixel_extand_flag_c2 <= 1'b0;
    if(y_int_c1 == C_SRC_IMG_HEIGHT - 2'd2)
        bottom_pixel_extand_flag_1_c2 <= 1'b1;
    else
        bottom_pixel_extand_flag_1_c2 <= 1'b0;
    if(y_int_c1 == C_SRC_IMG_HEIGHT - 2'd1)
        bottom_pixel_extand_flag_2_c2 <= 1'b1;
    else
        bottom_pixel_extand_flag_2_c2 <= 1'b0;
end

reg                             xmax_c2;
reg                             ymax_c2;

always @(posedge clk_in2)
begin
    if(x_fra_c1<inv_x_fra_c1)
        xmax_c2 <= 1'b0;
    else
        xmax_c2 <= 1'b1;
    if(y_fra_c1<inv_y_fra_c1)
        ymax_c2 <= 1'b0;
    else
        ymax_c2 <= 1'b1;
end



//----------------------------------------------------------------------
//  c3
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

always @(posedge clk_in2)
begin
    case(bram_mode_c2)
        2'b00 : 
        begin
            bram41_raddr <= bram_addr_c2+12'd1023;
            bram42_raddr <= bram_addr_c2+12'd1024;
            bram43_raddr <= bram_addr_c2+12'd1025;
            bram44_raddr <= bram_addr_c2+12'd1026;

            bram11_raddr <= bram_addr_c2- 1'd1;
            bram12_raddr <= bram_addr_c2;
            bram13_raddr <= bram_addr_c2+ 2'd1;
            bram14_raddr <= bram_addr_c2+ 2'd2;

            bram21_raddr <= bram_addr_c2- 1'd1;
            bram22_raddr <= bram_addr_c2;
            bram23_raddr <= bram_addr_c2+ 2'd1;
            bram24_raddr <= bram_addr_c2+ 2'd2;

            bram31_raddr <= bram_addr_c2- 1'd1;
            bram32_raddr <= bram_addr_c2;
            bram33_raddr <= bram_addr_c2+ 2'd1;
            bram34_raddr <= bram_addr_c2+ 2'd2;
        end
        2'b01 : 
        begin
            bram11_raddr <= bram_addr_c2- 1'd1;
            bram12_raddr <= bram_addr_c2;
            bram13_raddr <= bram_addr_c2+ 2'd1;
            bram14_raddr <= bram_addr_c2+ 2'd2;

            bram21_raddr <= bram_addr_c2- 1'd1;
            bram22_raddr <= bram_addr_c2;
            bram23_raddr <= bram_addr_c2+ 2'd1;
            bram24_raddr <= bram_addr_c2+ 2'd2;

            bram31_raddr <= bram_addr_c2- 1'd1;
            bram32_raddr <= bram_addr_c2;
            bram33_raddr <= bram_addr_c2+ 2'd1;
            bram34_raddr <= bram_addr_c2+ 2'd2;

            bram41_raddr <= bram_addr_c2- 1'd1;
            bram42_raddr <= bram_addr_c2;
            bram43_raddr <= bram_addr_c2+ 2'd1;
            bram44_raddr <= bram_addr_c2+ 2'd2;

        end
        2'b10 : 
        begin
            bram21_raddr <= bram_addr_c2- 1'd1;
            bram22_raddr <= bram_addr_c2;
            bram23_raddr <= bram_addr_c2+ 2'd1;
            bram24_raddr <= bram_addr_c2+ 2'd2;

            bram31_raddr <= bram_addr_c2- 1'd1;
            bram32_raddr <= bram_addr_c2;
            bram33_raddr <= bram_addr_c2+ 2'd1;
            bram34_raddr <= bram_addr_c2+ 2'd2;

            bram41_raddr <= bram_addr_c2- 1'd1;
            bram42_raddr <= bram_addr_c2;
            bram43_raddr <= bram_addr_c2+ 2'd1;
            bram44_raddr <= bram_addr_c2+ 2'd2;

            bram11_raddr <= bram_addr_c2+ 11'd1023;
            bram12_raddr <= bram_addr_c2+ 11'd1024;
            bram13_raddr <= bram_addr_c2+ 11'd1025;
            bram14_raddr <= bram_addr_c2+ 11'd1026;

        end
        2'b11 : 
        begin
            bram31_raddr <= bram_addr_c2- 1'd1;
            bram32_raddr <= bram_addr_c2;
            bram33_raddr <= bram_addr_c2+ 2'd1;
            bram34_raddr <= bram_addr_c2+ 2'd2;

            bram41_raddr <= bram_addr_c2- 1'd1;
            bram42_raddr <= bram_addr_c2;
            bram43_raddr <= bram_addr_c2+ 2'd1;
            bram44_raddr <= bram_addr_c2+ 2'd2;

            bram11_raddr <= bram_addr_c2+ 11'd1023;
            bram12_raddr <= bram_addr_c2+ 11'd1024;
            bram13_raddr <= bram_addr_c2+ 11'd1025;
            bram14_raddr <= bram_addr_c2+ 11'd1026;

            bram21_raddr <= bram_addr_c2+ 11'd1023;
            bram22_raddr <= bram_addr_c2+ 11'd1024;
            bram23_raddr <= bram_addr_c2+ 11'd1025;
            bram24_raddr <= bram_addr_c2+ 11'd1026;

            
        end
    endcase
end

reg             [33:0]          frac_00_c3;
reg             [33:0]          frac_01_c3;
reg             [33:0]          frac_10_c3;
reg             [33:0]          frac_11_c3;
reg             [ 1:0]          bram_mode_c3;
reg                             left_pixel_extand_flag_c3;
reg                             right_pixel_extand_flag_1_c3;
reg                             right_pixel_extand_flag_2_c3;
reg                             top_pixel_extand_flag_c3;
reg                             bottom_pixel_extand_flag_1_c3;
reg                             bottom_pixel_extand_flag_2_c3;


always @(posedge clk_in2)
begin
    frac_00_c3                  <= frac_00_c2;
    frac_01_c3                  <= frac_01_c2;
    frac_10_c3                  <= frac_10_c2;
    frac_11_c3                  <= frac_11_c2;
    bram_mode_c3                <= bram_mode_c2;
    left_pixel_extand_flag_c3      <=left_pixel_extand_flag_c2;
    right_pixel_extand_flag_1_c3   <=right_pixel_extand_flag_1_c2;
    right_pixel_extand_flag_2_c3   <=right_pixel_extand_flag_2_c2;
    top_pixel_extand_flag_c3       <=top_pixel_extand_flag_c2;
    bottom_pixel_extand_flag_1_c3  <=bottom_pixel_extand_flag_1_c2;
    bottom_pixel_extand_flag_2_c3  <=bottom_pixel_extand_flag_2_c2;   
end

reg                             xmax_c3;
reg                             ymax_c3;
always @(posedge clk_in2)
begin
    xmax_c3     <=xmax_c2;
    ymax_c3     <=ymax_c2;
end

//----------------------------------------------------------------------
//  c4
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
reg             [ 1:0]          bram_mode_c4;
reg                             left_extand_flag_c4    ;
reg                             right_extand_flag_1_c4 ;
reg                             right_extand_flag_2_c4 ;
reg                             top_extand_flag_c4     ;
reg                             bottom_extand_flag_1_c4;
reg                             bottom_extand_flag_2_c4;
reg                             xmax_c4;
reg                             ymax_c4;

always @(posedge clk_in2)
begin
    frac_00_c4                  <= frac_00_c3;
    frac_01_c4                  <= frac_01_c3;
    frac_10_c4                  <= frac_10_c3;
    frac_11_c4                  <= frac_11_c3;
    bram_mode_c4                <= bram_mode_c3;
    left_extand_flag_c4         <=left_pixel_extand_flag_c3   ;
    right_extand_flag_1_c4      <=right_pixel_extand_flag_1_c3;
    right_extand_flag_2_c4      <=right_pixel_extand_flag_2_c3;
    top_extand_flag_c4          <=top_pixel_extand_flag_c3    ;
    bottom_extand_flag_1_c4     <=bottom_pixel_extand_flag_1_c3;
    bottom_extand_flag_2_c4     <=bottom_pixel_extand_flag_2_c3;
    xmax_c4                     <=xmax_c3;
    ymax_c4                     <=ymax_c3;
end

//----------------------------------------------------------------------
//  c5
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

reg             [7:0]           pixel_data11_c5;
reg             [7:0]           pixel_data12_c5;
reg             [7:0]           pixel_data13_c5;
reg             [7:0]           pixel_data14_c5;

reg             [7:0]           pixel_data21_c5;
reg             [7:0]           pixel_data22_c5;
reg             [7:0]           pixel_data23_c5;
reg             [7:0]           pixel_data24_c5;

reg             [7:0]           pixel_data31_c5;
reg             [7:0]           pixel_data32_c5;
reg             [7:0]           pixel_data33_c5;
reg             [7:0]           pixel_data34_c5;

reg             [7:0]           pixel_data41_c5;
reg             [7:0]           pixel_data42_c5;
reg             [7:0]           pixel_data43_c5;
reg             [7:0]           pixel_data44_c5;

always @(posedge clk_in2)
begin
    case(bram_mode_c4)
        2'b00 : 
        begin
            pixel_data11_c5 <= bram41_rdata;
            pixel_data12_c5 <= bram42_rdata;
            pixel_data13_c5 <= bram43_rdata;
            pixel_data14_c5 <= bram44_rdata;

            pixel_data21_c5 <= bram11_rdata;
            pixel_data22_c5 <= bram12_rdata;
            pixel_data23_c5 <= bram13_rdata;
            pixel_data24_c5 <= bram14_rdata;

            pixel_data31_c5 <= bram21_rdata;
            pixel_data32_c5 <= bram22_rdata;
            pixel_data33_c5 <= bram23_rdata;
            pixel_data34_c5 <= bram24_rdata;

            pixel_data41_c5 <= bram31_rdata;
            pixel_data42_c5 <= bram32_rdata;
            pixel_data43_c5 <= bram33_rdata;
            pixel_data44_c5 <= bram34_rdata;
        end
        2'b01 : 
        begin
            pixel_data11_c5 <= bram11_rdata;
            pixel_data12_c5 <= bram12_rdata;
            pixel_data13_c5 <= bram13_rdata;
            pixel_data14_c5 <= bram14_rdata;

            pixel_data21_c5 <= bram21_rdata;
            pixel_data22_c5 <= bram22_rdata;
            pixel_data23_c5 <= bram23_rdata;
            pixel_data24_c5 <= bram24_rdata;

            pixel_data31_c5 <= bram31_rdata;
            pixel_data32_c5 <= bram32_rdata;
            pixel_data33_c5 <= bram33_rdata;
            pixel_data34_c5 <= bram34_rdata;

            pixel_data41_c5 <= bram41_rdata;
            pixel_data42_c5 <= bram42_rdata;
            pixel_data43_c5 <= bram43_rdata;
            pixel_data44_c5 <= bram44_rdata;
        end
        2'b10 : 
        begin
            pixel_data11_c5 <= bram21_rdata;
            pixel_data12_c5 <= bram22_rdata;
            pixel_data13_c5 <= bram23_rdata;
            pixel_data14_c5 <= bram24_rdata;

            pixel_data21_c5 <= bram31_rdata;
            pixel_data22_c5 <= bram32_rdata;
            pixel_data23_c5 <= bram33_rdata;
            pixel_data24_c5 <= bram34_rdata;

            pixel_data31_c5 <= bram41_rdata;
            pixel_data32_c5 <= bram42_rdata;
            pixel_data33_c5 <= bram43_rdata;
            pixel_data34_c5 <= bram44_rdata;

            pixel_data41_c5 <= bram11_rdata;
            pixel_data42_c5 <= bram12_rdata;
            pixel_data43_c5 <= bram13_rdata;
            pixel_data44_c5 <= bram14_rdata;
        end
        2'b11 : 
        begin
            pixel_data11_c5 <= bram31_rdata;
            pixel_data12_c5 <= bram32_rdata;
            pixel_data13_c5 <= bram33_rdata;
            pixel_data14_c5 <= bram34_rdata;

            pixel_data21_c5 <= bram41_rdata;
            pixel_data22_c5 <= bram42_rdata;
            pixel_data23_c5 <= bram43_rdata;
            pixel_data24_c5 <= bram44_rdata;

            pixel_data31_c5 <= bram11_rdata;
            pixel_data32_c5 <= bram12_rdata;
            pixel_data33_c5 <= bram13_rdata;
            pixel_data34_c5 <= bram14_rdata;

            pixel_data41_c5 <= bram21_rdata;
            pixel_data42_c5 <= bram22_rdata;
            pixel_data43_c5 <= bram23_rdata;
            pixel_data44_c5 <= bram24_rdata; 
        end
    endcase
end

reg             [33:0]          frac_00_c5;
reg             [33:0]          frac_01_c5;
reg             [33:0]          frac_10_c5;
reg             [33:0]          frac_11_c5;
reg                             left_extand_flag_c5;
reg                             right_extand_flag_1_c5;
reg                             right_extand_flag_2_c5;
reg                             top_extand_flag_c5;
reg                             bottom_extand_flag_1_c5;
reg                             bottom_extand_flag_2_c5;
reg                             xmax_c5;
reg                             ymax_c5;

always @(posedge clk_in2)
begin
    frac_00_c5                  <= frac_00_c4;
    frac_01_c5                  <= frac_01_c4;
    frac_10_c5                  <= frac_10_c4;
    frac_11_c5                  <= frac_11_c4;
    left_extand_flag_c5           <=left_extand_flag_c4   ;
    right_extand_flag_1_c5        <=right_extand_flag_1_c4;
    right_extand_flag_2_c5        <=right_extand_flag_2_c4;
    top_extand_flag_c5            <=top_extand_flag_c4    ;
    bottom_extand_flag_1_c5       <=bottom_extand_flag_1_c4;
    bottom_extand_flag_2_c5       <=bottom_extand_flag_2_c4;
    xmax_c5                     <=xmax_c4;
    ymax_c5                     <=ymax_c4;
end

//----------------------------------------------------------------------
//  c6
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

reg             [7:0]           pixel_data11_c6, pixel_data12_c6, pixel_data13_c6, pixel_data14_c6; 
reg             [7:0]           pixel_data21_c6, pixel_data22_c6, pixel_data23_c6, pixel_data24_c6;
reg             [7:0]           pixel_data31_c6, pixel_data32_c6, pixel_data33_c6, pixel_data34_c6;
reg             [7:0]           pixel_data41_c6, pixel_data42_c6, pixel_data43_c6, pixel_data44_c6;

always @(posedge clk_in2)
begin
    case({left_extand_flag_c5,right_extand_flag_1_c5,right_extand_flag_2_c5,top_extand_flag_c5,bottom_extand_flag_1_c5,bottom_extand_flag_2_c5})
        6'b000000 : //01
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data14_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data34_c5;

            pixel_data41_c6 <= pixel_data41_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data43_c5;
            pixel_data44_c6 <= pixel_data44_c5;
        end
        6'b000001 ://02
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data14_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data21_c5;
            pixel_data32_c6 <= pixel_data22_c5;
            pixel_data33_c6 <= pixel_data23_c5;
            pixel_data34_c6 <= pixel_data24_c5;

            pixel_data41_c6 <= pixel_data21_c5;
            pixel_data42_c6 <= pixel_data22_c5;
            pixel_data43_c6 <= pixel_data23_c5;
            pixel_data44_c6 <= pixel_data24_c5;
        end
        6'b000010 ://03
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data14_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data34_c5;

            pixel_data41_c6 <= pixel_data31_c5;
            pixel_data42_c6 <= pixel_data32_c5;
            pixel_data43_c6 <= pixel_data33_c5;
            pixel_data44_c6 <= pixel_data34_c5;
        end
        6'b000100 ://04
        begin
            pixel_data11_c6 <= pixel_data21_c5;
            pixel_data12_c6 <= pixel_data22_c5;
            pixel_data13_c6 <= pixel_data23_c5;
            pixel_data14_c6 <= pixel_data24_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data34_c5;

            pixel_data41_c6 <= pixel_data41_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data43_c5;
            pixel_data44_c6 <= pixel_data44_c5;
        end


        6'b001000 : //11
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data12_c5;
            pixel_data14_c6 <= pixel_data12_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data22_c5;
            pixel_data24_c6 <= pixel_data22_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data32_c5;
            pixel_data34_c6 <= pixel_data32_c5;

            pixel_data41_c6 <= pixel_data41_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data42_c5;
            pixel_data44_c6 <= pixel_data42_c5;
        end
        6'b001001 ://12
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data12_c5;
            pixel_data14_c6 <= pixel_data12_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data22_c5;
            pixel_data24_c6 <= pixel_data22_c5;

            pixel_data31_c6 <= pixel_data21_c5;
            pixel_data32_c6 <= pixel_data22_c5;
            pixel_data33_c6 <= pixel_data22_c5;
            pixel_data34_c6 <= pixel_data22_c5;

            pixel_data41_c6 <= pixel_data21_c5;
            pixel_data42_c6 <= pixel_data22_c5;
            pixel_data43_c6 <= pixel_data22_c5;
            pixel_data44_c6 <= pixel_data22_c5;
        end
        6'b001010 ://13
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data12_c5;
            pixel_data14_c6 <= pixel_data12_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data22_c5;
            pixel_data24_c6 <= pixel_data22_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data32_c5;
            pixel_data34_c6 <= pixel_data32_c5;

            pixel_data41_c6 <= pixel_data31_c5;
            pixel_data42_c6 <= pixel_data32_c5;
            pixel_data43_c6 <= pixel_data32_c5;
            pixel_data44_c6 <= pixel_data32_c5;
        end
        6'b001100 ://14
        begin
            pixel_data11_c6 <= pixel_data21_c5;
            pixel_data12_c6 <= pixel_data22_c5;
            pixel_data13_c6 <= pixel_data22_c5;
            pixel_data14_c6 <= pixel_data22_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data22_c5;
            pixel_data24_c6 <= pixel_data22_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data32_c5;
            pixel_data34_c6 <= pixel_data32_c5;

            pixel_data41_c6 <= pixel_data41_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data42_c5;
            pixel_data44_c6 <= pixel_data42_c5;
        end

        6'b010000 : //21
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data13_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data23_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data33_c5;

            pixel_data41_c6 <= pixel_data41_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data43_c5;
            pixel_data44_c6 <= pixel_data43_c5;
        end
        6'b010001 ://22
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data13_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data23_c5;

            pixel_data31_c6 <= pixel_data21_c5;
            pixel_data32_c6 <= pixel_data22_c5;
            pixel_data33_c6 <= pixel_data23_c5;
            pixel_data34_c6 <= pixel_data23_c5;

            pixel_data41_c6 <= pixel_data21_c5;
            pixel_data42_c6 <= pixel_data22_c5;
            pixel_data43_c6 <= pixel_data23_c5;
            pixel_data44_c6 <= pixel_data23_c5;
        end
        6'b010010 ://23
        begin
            pixel_data11_c6 <= pixel_data11_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data13_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data23_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data33_c5;

            pixel_data41_c6 <= pixel_data31_c5;
            pixel_data42_c6 <= pixel_data32_c5;
            pixel_data43_c6 <= pixel_data33_c5;
            pixel_data44_c6 <= pixel_data33_c5;
        end
        6'b010100 ://24
        begin
            pixel_data11_c6 <= pixel_data21_c5;
            pixel_data12_c6 <= pixel_data22_c5;
            pixel_data13_c6 <= pixel_data23_c5;
            pixel_data14_c6 <= pixel_data23_c5;

            pixel_data21_c6 <= pixel_data21_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data23_c5;

            pixel_data31_c6 <= pixel_data31_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data33_c5;

            pixel_data41_c6 <= pixel_data41_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data43_c5;
            pixel_data44_c6 <= pixel_data43_c5;
        end

        6'b100000 : //31
        begin
            pixel_data11_c6 <= pixel_data12_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data14_c5;

            pixel_data21_c6 <= pixel_data22_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data32_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data34_c5;

            pixel_data41_c6 <= pixel_data42_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data43_c5;
            pixel_data44_c6 <= pixel_data44_c5;
        end
        6'b100001 ://32
        begin
            pixel_data11_c6 <= pixel_data12_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data14_c5;

            pixel_data21_c6 <= pixel_data22_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data22_c5;
            pixel_data32_c6 <= pixel_data22_c5;
            pixel_data33_c6 <= pixel_data23_c5;
            pixel_data34_c6 <= pixel_data24_c5;

            pixel_data41_c6 <= pixel_data22_c5;
            pixel_data42_c6 <= pixel_data22_c5;
            pixel_data43_c6 <= pixel_data23_c5;
            pixel_data44_c6 <= pixel_data24_c5;
        end
        6'b100010 ://33
        begin
            pixel_data11_c6 <= pixel_data12_c5;
            pixel_data12_c6 <= pixel_data12_c5;
            pixel_data13_c6 <= pixel_data13_c5;
            pixel_data14_c6 <= pixel_data14_c5;

            pixel_data21_c6 <= pixel_data22_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data32_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data34_c5;

            pixel_data41_c6 <= pixel_data32_c5;
            pixel_data42_c6 <= pixel_data32_c5;
            pixel_data43_c6 <= pixel_data33_c5;
            pixel_data44_c6 <= pixel_data34_c5;
        end
        6'b100100 ://34
        begin
            pixel_data11_c6 <= pixel_data22_c5;
            pixel_data12_c6 <= pixel_data22_c5;
            pixel_data13_c6 <= pixel_data23_c5;
            pixel_data14_c6 <= pixel_data24_c5;

            pixel_data21_c6 <= pixel_data22_c5;
            pixel_data22_c6 <= pixel_data22_c5;
            pixel_data23_c6 <= pixel_data23_c5;
            pixel_data24_c6 <= pixel_data24_c5;

            pixel_data31_c6 <= pixel_data32_c5;
            pixel_data32_c6 <= pixel_data32_c5;
            pixel_data33_c6 <= pixel_data33_c5;
            pixel_data34_c6 <= pixel_data34_c5;

            pixel_data41_c6 <= pixel_data42_c5;
            pixel_data42_c6 <= pixel_data42_c5;
            pixel_data43_c6 <= pixel_data43_c5;
            pixel_data44_c6 <= pixel_data44_c5;
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
    xmax_c6                     <=xmax_c5;
    ymax_c6                     <=ymax_c5;
end

//----------------------------------------------------------------------
//  c7
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

reg             [41:0]          gray_data00_c7;
reg             [41:0]          gray_data01_c7;
reg             [41:0]          gray_data10_c7;
reg             [41:0]          gray_data11_c7;

always @(posedge clk_in2)
begin
    gray_data00_c7 <= frac_00_c6 * pixel_data22_c6;
    gray_data01_c7 <= frac_01_c6 * pixel_data23_c6;
    gray_data10_c7 <= frac_10_c6 * pixel_data32_c6;
    gray_data11_c7 <= frac_11_c6 * pixel_data33_c6;
end

reg             [7:0]          gray_data_max_c7;        

always @(posedge clk_in2)
begin
    case({ymax_c6,xmax_c6})
        2'b00 : 
        begin
            gray_data_max_c7 <= pixel_data22_c6;
        end
        2'b01 : 
        begin
            gray_data_max_c7 <= pixel_data23_c6;
        end
        2'b10 : 
        begin
            gray_data_max_c7 <= pixel_data32_c6;
        end
        2'b11 : 
        begin
            gray_data_max_c7 <= pixel_data33_c6;
        end
    endcase
end

reg             [7:0]           pixel_data11_c7, pixel_data12_c7, pixel_data13_c7, pixel_data14_c7;
reg             [7:0]           pixel_data21_c7, pixel_data22_c7, pixel_data23_c7, pixel_data24_c7;
reg             [7:0]           pixel_data31_c7, pixel_data32_c7, pixel_data33_c7, pixel_data34_c7;
reg             [7:0]           pixel_data41_c7, pixel_data42_c7, pixel_data43_c7, pixel_data44_c7;
always @(posedge clk_in2)
begin
    pixel_data11_c7 <= pixel_data11_c6;
    pixel_data12_c7 <= pixel_data12_c6;
    pixel_data13_c7 <= pixel_data13_c6;
    pixel_data14_c7 <= pixel_data14_c6;
    pixel_data21_c7 <= pixel_data21_c6;
    pixel_data22_c7 <= pixel_data22_c6;
    pixel_data23_c7 <= pixel_data23_c6;
    pixel_data24_c7 <= pixel_data24_c6;
    pixel_data31_c7 <= pixel_data31_c6;
    pixel_data32_c7 <= pixel_data32_c6;
    pixel_data33_c7 <= pixel_data33_c6;
    pixel_data34_c7 <= pixel_data34_c6;
    pixel_data41_c7 <= pixel_data41_c6;
    pixel_data42_c7 <= pixel_data42_c6;
    pixel_data43_c7 <= pixel_data43_c6;
    pixel_data44_c7 <= pixel_data44_c6;
end

//----------------------------------------------------------------------
//  c8
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

reg             [42:0]          gray_data_tmp1_c8;
reg             [42:0]          gray_data_tmp2_c8;

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




reg             [7:0]           pixel_data11_c8, pixel_data12_c8, pixel_data13_c8, pixel_data14_c8;
reg             [7:0]           pixel_data21_c8, pixel_data22_c8, pixel_data23_c8, pixel_data24_c8;
reg             [7:0]           pixel_data31_c8, pixel_data32_c8, pixel_data33_c8, pixel_data34_c8;
reg             [7:0]           pixel_data41_c8, pixel_data42_c8, pixel_data43_c8, pixel_data44_c8;
always @(posedge clk_in2)
begin
    pixel_data11_c8 <= pixel_data11_c7;
    pixel_data12_c8 <= pixel_data12_c7;
    pixel_data13_c8 <= pixel_data13_c7;
    pixel_data14_c8 <= pixel_data14_c7;
    pixel_data21_c8 <= pixel_data21_c7;
    pixel_data22_c8 <= pixel_data22_c7;
    pixel_data23_c8 <= pixel_data23_c7;
    pixel_data24_c8 <= pixel_data24_c7;
    pixel_data31_c8 <= pixel_data31_c7;
    pixel_data32_c8 <= pixel_data32_c7;
    pixel_data33_c8 <= pixel_data33_c7;
    pixel_data34_c8 <= pixel_data34_c7;
    pixel_data41_c8 <= pixel_data41_c7;
    pixel_data42_c8 <= pixel_data42_c7;
    pixel_data43_c8 <= pixel_data43_c7;
    pixel_data44_c8 <= pixel_data44_c7;
end

//----------------------------------------------------------------------
//  c9
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

reg             [7:0]           pixel_data11_c9, pixel_data12_c9, pixel_data13_c9, pixel_data14_c9;
reg             [7:0]           pixel_data21_c9, pixel_data22_c9, pixel_data23_c9, pixel_data24_c9;
reg             [7:0]           pixel_data31_c9, pixel_data32_c9, pixel_data33_c9, pixel_data34_c9;
reg             [7:0]           pixel_data41_c9, pixel_data42_c9, pixel_data43_c9, pixel_data44_c9;
always @(posedge clk_in2)
begin
    pixel_data11_c9 <= pixel_data11_c8;
    pixel_data12_c9 <= pixel_data12_c8;
    pixel_data13_c9 <= pixel_data13_c8;
    pixel_data14_c9 <= pixel_data14_c8;
    pixel_data21_c9 <= pixel_data21_c8;
    pixel_data22_c9 <= pixel_data22_c8;
    pixel_data23_c9 <= pixel_data23_c8;
    pixel_data24_c9 <= pixel_data24_c8;
    pixel_data31_c9 <= pixel_data31_c8;
    pixel_data32_c9 <= pixel_data32_c8;
    pixel_data33_c9 <= pixel_data33_c8;
    pixel_data34_c9 <= pixel_data34_c8;
    pixel_data41_c9 <= pixel_data41_c8;
    pixel_data42_c9 <= pixel_data42_c8;
    pixel_data43_c9 <= pixel_data43_c8;
    pixel_data44_c9 <= pixel_data44_c8;
end

//----------------------------------------------------------------------
//  c10
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

reg             [11:0]          gray_data_c10;

always @(posedge clk_in2)
begin
    gray_data_c10 <= gray_data_c9[43:32] + gray_data_c9[31];
end

reg             [7:0]          gray_data_max_c10;
always @(posedge clk_in2)
begin
    gray_data_max_c10 <= gray_data_max_c9;
end

reg             [7:0]           pixel_data11_c10, pixel_data12_c10, pixel_data13_c10, pixel_data14_c10;
reg             [7:0]           pixel_data21_c10, pixel_data22_c10, pixel_data23_c10, pixel_data24_c10;
reg             [7:0]           pixel_data31_c10, pixel_data32_c10, pixel_data33_c10, pixel_data34_c10;
reg             [7:0]           pixel_data41_c10, pixel_data42_c10, pixel_data43_c10, pixel_data44_c10;
always @(posedge clk_in2)
begin
    pixel_data11_c10 <= pixel_data11_c9;
    pixel_data12_c10 <= pixel_data12_c9;
    pixel_data13_c10 <= pixel_data13_c9;
    pixel_data14_c10 <= pixel_data14_c9;
    pixel_data21_c10 <= pixel_data21_c9;
    pixel_data22_c10 <= pixel_data22_c9;
    pixel_data23_c10 <= pixel_data23_c9;
    pixel_data24_c10 <= pixel_data24_c9;
    pixel_data31_c10 <= pixel_data31_c9;
    pixel_data32_c10 <= pixel_data32_c9;
    pixel_data33_c10 <= pixel_data33_c9;
    pixel_data34_c10 <= pixel_data34_c9;
    pixel_data41_c10 <= pixel_data41_c9;
    pixel_data42_c10 <= pixel_data42_c9;
    pixel_data43_c10 <= pixel_data43_c9;
    pixel_data44_c10 <= pixel_data44_c9;
end

//----------------------------------------------------------------------
//  c11
reg                             img_vs_c11;
reg                             img_hs_c11;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c11 <= 1'b0;
        img_hs_c11 <= 1'b0;
    end
    else
    begin
        img_vs_c11 <= img_vs_c10;
        img_hs_c11 <= img_hs_c10;
    end
end

reg             [7:0]          gray_data_c11;

always @(posedge clk_in2)
begin
    gray_data_c11 <= gray_data_c10[7:0];
end

reg             [7:0]          gray_data_max_c11;
always @(posedge clk_in2)
begin
    gray_data_max_c11 <= gray_data_max_c10;
end

reg             [7:0]           pixel_data11_c11, pixel_data12_c11, pixel_data13_c11, pixel_data14_c11;
reg             [7:0]           pixel_data21_c11, pixel_data22_c11, pixel_data23_c11, pixel_data24_c11;
reg             [7:0]           pixel_data31_c11, pixel_data32_c11, pixel_data33_c11, pixel_data34_c11;
reg             [7:0]           pixel_data41_c11, pixel_data42_c11, pixel_data43_c11, pixel_data44_c11;
always @(posedge clk_in2)
begin
    pixel_data11_c11 <= pixel_data11_c10;
    pixel_data12_c11 <= pixel_data12_c10;
    pixel_data13_c11 <= pixel_data13_c10;
    pixel_data14_c11 <= pixel_data14_c10;
    pixel_data21_c11 <= pixel_data21_c10;
    pixel_data22_c11 <= pixel_data22_c10;
    pixel_data23_c11 <= pixel_data23_c10;
    pixel_data24_c11 <= pixel_data24_c10;
    pixel_data31_c11 <= pixel_data31_c10;
    pixel_data32_c11 <= pixel_data32_c10;
    pixel_data33_c11 <= pixel_data33_c10;
    pixel_data34_c11 <= pixel_data34_c10;
    pixel_data41_c11 <= pixel_data41_c10;
    pixel_data42_c11 <= pixel_data42_c10;
    pixel_data43_c11 <= pixel_data43_c10;
    pixel_data44_c11 <= pixel_data44_c10;
end


//----------------------------------------------------------------------
//  c12
reg                             img_vs_c12;
reg                             img_hs_c12;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c12 <= 1'b0;
        img_hs_c12 <= 1'b0;
    end
    else
    begin
        img_vs_c12 <= img_vs_c11;
        img_hs_c12 <= img_hs_c11;
    end
end

reg             [7:0]          gray_data_c12;

always @(posedge clk_in2)
begin
    gray_data_c12 <= gray_data_c11;
end

reg             [7:0]          gray_data_max_c12;
always @(posedge clk_in2)
begin
    gray_data_max_c12 <= gray_data_max_c11;
end


localparam NUM_FLT = 16;
reg [(NUM_FLT+8+1):0] weight_data00_c12, weight_data01_c12, weight_data02_c12, weight_data03_c12;// (33,24)
reg [(NUM_FLT+8+1):0] weight_data10_c12, weight_data11_c12, weight_data12_c12, weight_data13_c12;
reg [(NUM_FLT+8+1):0] weight_data20_c12, weight_data21_c12, weight_data22_c12, weight_data23_c12;
reg [(NUM_FLT+8+1):0] weight_data30_c12, weight_data31_c12, weight_data32_c12, weight_data33_c12;
always @(posedge clk_in2)
begin
    weight_data00_c12 <=coeff00_c11[33:(32-NUM_FLT)] *pixel_data11_c11;
    weight_data01_c12 <=coeff01_c11[33:(32-NUM_FLT)] *pixel_data12_c11;
    weight_data02_c12 <=coeff02_c11[33:(32-NUM_FLT)] *pixel_data13_c11;
    weight_data03_c12 <=coeff03_c11[33:(32-NUM_FLT)] *pixel_data14_c11;

    weight_data10_c12 <=coeff10_c11[33:(32-NUM_FLT)] *pixel_data21_c11;
    weight_data11_c12 <=coeff11_c11[33:(32-NUM_FLT)] *pixel_data22_c11;
    weight_data12_c12 <=coeff12_c11[33:(32-NUM_FLT)] *pixel_data23_c11;
    weight_data13_c12 <=coeff13_c11[33:(32-NUM_FLT)] *pixel_data24_c11;

    weight_data20_c12 <=coeff20_c11[33:(32-NUM_FLT)] *pixel_data31_c11;
    weight_data21_c12 <=coeff21_c11[33:(32-NUM_FLT)] *pixel_data32_c11;
    weight_data22_c12 <=coeff22_c11[33:(32-NUM_FLT)] *pixel_data33_c11;
    weight_data23_c12 <=coeff23_c11[33:(32-NUM_FLT)] *pixel_data34_c11;

    weight_data30_c12 <=coeff30_c11[33:(32-NUM_FLT)] *pixel_data41_c11;
    weight_data31_c12 <=coeff31_c11[33:(32-NUM_FLT)] *pixel_data42_c11;
    weight_data32_c12 <=coeff32_c11[33:(32-NUM_FLT)] *pixel_data43_c11;
    weight_data33_c12 <=coeff33_c11[33:(32-NUM_FLT)] *pixel_data44_c11;
end

//----------------------------------------------------------------------
//  c13

reg                             img_vs_c13;
reg                             img_hs_c13;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c13 <= 1'b0;
        img_hs_c13 <= 1'b0;
    end
    else
    begin
        img_vs_c13 <= img_vs_c12;
        img_hs_c13 <= img_hs_c12;
    end
end

reg             [7:0]          gray_data_max_c13;
reg             [7:0]          gray_data_c13;
always @(posedge clk_in2)
begin
    gray_data_max_c13 <= gray_data_max_c12;
    gray_data_c13 <= gray_data_c12;
end

reg [(NUM_FLT+8+2):0] weight_data_temp1_c13,weight_data_temp2_c13;
reg [(NUM_FLT+8+2):0] weight_data_temp3_c13,weight_data_temp4_c13;
reg [(NUM_FLT+8+2):0] weight_data_temp5_c13,weight_data_temp6_c13;
reg [(NUM_FLT+8+2):0] weight_data_temp7_c13,weight_data_temp8_c13;

always @(posedge clk_in2)
begin
    weight_data_temp1_c13 <= weight_data00_c12+weight_data03_c12;
    weight_data_temp2_c13 <= weight_data11_c12+weight_data12_c12;
    weight_data_temp3_c13 <= weight_data21_c12+weight_data22_c12;
    weight_data_temp4_c13 <= weight_data30_c12+weight_data33_c12;

    weight_data_temp5_c13 <= weight_data01_c12+weight_data02_c12;
    weight_data_temp6_c13 <= weight_data10_c12+weight_data13_c12;
    weight_data_temp7_c13 <= weight_data20_c12+weight_data23_c12;
    weight_data_temp8_c13 <= weight_data31_c12+weight_data32_c12;

end

//----------------------------------------------------------------------
//  c14

reg                             img_vs_c14;
reg                             img_hs_c14;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c14 <= 1'b0;
        img_hs_c14 <= 1'b0;
    end
    else
    begin
        img_vs_c14 <= img_vs_c13;
        img_hs_c14 <= img_hs_c13;
    end
end

reg             [7:0]          gray_data_max_c14;
reg             [7:0]          gray_data_c14;
always @(posedge clk_in2)
begin
    gray_data_max_c14   <= gray_data_max_c13;
    gray_data_c14       <= gray_data_c13;
end

reg [(NUM_FLT+8+3):0] weight_data_temp21_c14,weight_data_temp22_c14;
reg [(NUM_FLT+8+3):0] weight_data_temp23_c14,weight_data_temp24_c14;

always @(posedge clk_in2)
begin
    weight_data_temp21_c14 <= weight_data_temp1_c13+weight_data_temp2_c13;
    weight_data_temp22_c14 <= weight_data_temp3_c13+weight_data_temp4_c13;

    weight_data_temp23_c14 <= weight_data_temp5_c13+weight_data_temp6_c13;
    weight_data_temp24_c14 <= weight_data_temp7_c13+weight_data_temp8_c13;
end

//----------------------------------------------------------------------
//  c15

reg                             img_vs_c15;
reg                             img_hs_c15;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c15 <= 1'b0;
        img_hs_c15 <= 1'b0;
    end
    else
    begin
        img_vs_c15 <= img_vs_c14;
        img_hs_c15 <= img_hs_c14;
    end
end

reg             [7:0]          gray_data_max_c15;
reg             [7:0]          gray_data_c15;
always @(posedge clk_in2)
begin
    gray_data_max_c15   <= gray_data_max_c14;
    gray_data_c15       <= gray_data_c14;
end

reg [(NUM_FLT+8+4):0] weight_data_temp31_c15,weight_data_temp32_c15;

always @(posedge clk_in2)
begin
    weight_data_temp31_c15 <= weight_data_temp21_c14+weight_data_temp22_c14;
    weight_data_temp32_c15 <= weight_data_temp23_c14+weight_data_temp24_c14;
end

//----------------------------------------------------------------------
//  c16

reg                             img_vs_c16;
reg                             img_hs_c16;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c16 <= 1'b0;
        img_hs_c16 <= 1'b0;
    end
    else
    begin
        img_vs_c16 <= img_vs_c15;
        img_hs_c16 <= img_hs_c15;
    end
end

reg             [7:0]          gray_data_max_c16;
reg             [7:0]          gray_data_c16;
always @(posedge clk_in2)
begin
    gray_data_max_c16   <= gray_data_max_c15;
        gray_data_c16       <= gray_data_c15;
end

reg [(NUM_FLT+8+5):0] weight_data_temp41_c16;

always @(posedge clk_in2)
begin
    if(weight_data_temp31_c15 >= weight_data_temp32_c15)
    begin
        weight_data_temp41_c16 <= weight_data_temp31_c15 - weight_data_temp32_c15;
    end
    else
    begin
        weight_data_temp41_c16 <= 0;
    end
end

//----------------------------------------------------------------------
//  c17

reg                             img_vs_c17;
reg                             img_hs_c17;

always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        img_vs_c17 <= 1'b0;
        img_hs_c17 <= 1'b0;
    end
    else
    begin
        img_vs_c17 <= img_vs_c16;
        img_hs_c17 <= img_hs_c16;
    end
end

reg             [7:0]          gray_data_max_c17;
reg             [7:0]              gray_data_c17;
always @(posedge clk_in2)
begin
    gray_data_max_c17   <= gray_data_max_c16;
        gray_data_c17       <= gray_data_c16;
end

reg [13:0] weight_data_temp51_c17;

always @(posedge clk_in2)
begin
    weight_data_temp51_c17 <= weight_data_temp41_c16[(NUM_FLT+8+5):NUM_FLT] + weight_data_temp41_c16[NUM_FLT-1];
end

//----------------------------------------------------------------------
//  signals output
always @(posedge clk_in2)
begin
    if(rst_n == 1'b0)
    begin
        post_img_vsync <= 1'b0;
        post_img_href  <= 1'b0;
    end
    else
    begin
        post_img_vsync <= img_vs_c17;
        post_img_href  <= img_hs_c17;
    end
end

always @(posedge clk_in2)
begin

    case({out_model})
        2'b00 : 
        begin
            if(gray_data_max_c17 > 12'd255)
                post_img_gray <= 8'd255;
            else
                post_img_gray <= gray_data_max_c17;
        end
        2'b01 : 
        begin
            if(gray_data_c17 > 12'd255)
                post_img_gray <= 8'd255;
            else
                post_img_gray <= gray_data_c17;
        end
        2'b10 : 
        begin
            if(weight_data_temp51_c17 > 14'd255)
                post_img_gray <= 8'd255;
            else
                post_img_gray <= weight_data_temp51_c17[7:0];
        end
        2'b11 : 
        begin
            if(gray_data_c17 > 12'd255)
                post_img_gray <= 8'd255;
            else
                post_img_gray <= gray_data_c17;
        end
    endcase
end


endmodule