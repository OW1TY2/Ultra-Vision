module data_loader(
    input       sys_clk_96M,
    input       biliner_clk_in,
    input       sys_rst_n,
    
    input               pix_clk_i,
    input      [23:0]   RGB_data_i,
    input               pix_en_i,
    input               hsync_i,//锟斤拷锟斤拷锟斤拷锟脚猴拷
    input               vsync_i,//锟斤拷锟诫场锟脚猴拷
    input               ADV7611_config_done,
    
    output wire [23:0]    RGB_data_o,
    
    output reg          hsync_o,//锟斤拷锟脚猴拷 锟斤拷1锟斤拷锟脚猴拷
    output reg          vsync_o,//锟斤拷锟脚猴拷

    output wire wr_en_i,
    output reg rd_en_i,
    output wire [1:0]state_debug
);
parameter H_PIX_MAX=10'd640;
parameter V_PIX_MAX=10'd480;

//wire    almost_full_o;
//wire    prog_full_o;
//wire    full_o;
//wire    overflow_o;
//wire    wr_ack_o;
//wire    empty_o;
//wire    almost_empty_o;
//wire    underflow_o;
//wire    rd_valid_o;
//wire    rst_busy;
wire [15:0]     wr_datacount_o;
wire [15:0]     rd_datacount_o;

// wire     wr_en_i;
// reg     rd_en_i;


data_in_fifo u_data_in_fifo(
.almost_full_o (),//
.prog_full_o (),
.full_o (),
.overflow_o (),
.wr_ack_o (),
.empty_o (),
.almost_empty_o (),
.underflow_o (),
.rd_valid_o (),
.wr_clk_i ( pix_clk_i ),
.rd_clk_i ( biliner_clk_in ),
.wr_en_i ( wr_en_i ),
.rd_en_i ( rd_en_i ),
.wdata ( RGB_data_i ),
.wr_datacount_o ( wr_datacount_o ),
.rst_busy (),
.rdata ( RGB_data_o ),
.rd_datacount_o ( rd_datacount_o ),
.a_rst_i ( ~sys_rst_n )
);

//锟斤拷锟脚猴拷锟铰斤拷锟截硷拷锟�
reg start_load;
reg [7:0] vsync_negedge_cnt;
reg vsync_r;
wire vsync_negedge;
always@(posedge sys_clk_96M or negedge sys_rst_n )begin
    if(!sys_rst_n)
        vsync_r<=1'b0;
    else
        vsync_r<=vsync_i;
end

assign vsync_negedge=(~vsync_i)&&vsync_r;

always@(posedge sys_clk_96M or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        vsync_negedge_cnt<=8'b0;
        start_load<=1'b0;
    end
    else if(vsync_negedge && vsync_negedge_cnt<128)
        vsync_negedge_cnt<=vsync_negedge_cnt+8'b1;
    else if(vsync_negedge && vsync_negedge_cnt==128)
        start_load<=1'b1;
    else
        start_load<=start_load;
end

assign wr_en_i= start_load&&sys_rst_n&&ADV7611_config_done && hsync_i && vsync_i && pix_en_i ? 1'b1:1'b0;
assign state_debug = state;

reg [1:0]   state;
reg [10:0]  h_cnt;
reg [10:0]  v_cnt;
wire h_trans_flag;
wire v_trans_flag;
reg v_trans_flag_r;

assign h_trans_flag = h_cnt==(H_PIX_MAX-10'd1)? 1'b1:1'b0;
assign v_trans_flag = v_cnt==(V_PIX_MAX-10'd1)? 1'b1:1'b0;

//锟斤拷锟斤拷锟斤拷锟阶刺拷锟�
always @(posedge biliner_clk_in or negedge sys_rst_n )begin
    if (!sys_rst_n)begin
        state<=2'd0;
    end
    else if(state==2'd0 && ADV7611_config_done)begin
        if(wr_datacount_o>=3000)begin
            state<=2'd1;
        end
        else begin
            state<=2'd0;
        end
    end
    
    else if(state==2'd1)begin
        if(rd_datacount_o>=H_PIX_MAX)begin
            state<=2'd2;
        end
        else begin
            state<=2'd1;
        end
    end
    
    else if(state==2'd2)begin
        if(v_trans_flag && h_trans_flag)begin//一锟斤拷锟斤拷锟斤拷锟斤拷锟�
            state<=2'd0;
        end
            
        else if((!v_trans_flag)&&h_trans_flag)begin//一锟叫达拷锟斤拷锟斤拷锟�
            state<=2'd1;
        end
        
        else begin//锟斤拷锟斤拷锟斤拷
            state<=2'd2;
        end
    end
    
    else begin
        state<=state;
    end
end

reg hsync_flag;
reg start_up;
//锟斤拷锟斤拷锟斤拷锟� rd_en_i hsync_o vsync_o
always @(posedge biliner_clk_in or negedge sys_rst_n )begin
    if (!sys_rst_n)begin
        rd_en_i<=1'b0;
        h_cnt<=11'd0;
        v_cnt<=11'd0;
        hsync_o<=1'b0;
        vsync_o<=1'b0;
        hsync_flag<=1'b0;
        start_up<=1'b0;
    end
    
    else if(state==2'd0 )begin//锟斤拷锟斤拷锟斤拷
        rd_en_i<=1'b0;
        h_cnt<=11'd0;
        v_cnt<=11'd0;
        vsync_o<=1'b0;
        hsync_o<=1'b0;
    end
    
    else if(state==2'd1)begin//锟斤拷锟斤拷锟斤拷
        rd_en_i<=1'b0;
        h_cnt<=11'd0;
        hsync_o<=1'b0;
        vsync_o<=1'b1;
        hsync_flag<=1'b0;
    end
    
    else if(state==2'd2)begin//锟斤拷锟�
        if(h_cnt == 10'd0 && start_up!=1'b0 && hsync_flag == 1'b0)begin
            rd_en_i<=1'b1;
            //h_cnt<=h_cnt+11'd1;
            hsync_o<=1'b0;
            vsync_o<=1'b1;
            hsync_flag<=1'b1;
        end
        else if(h_cnt<H_PIX_MAX-10'd1)begin
            rd_en_i<=1'b1;
            h_cnt<=h_cnt+11'd1;
            hsync_o<=1'b1;
            vsync_o<=1'b1;
            start_up<=1'b1;
            
        end
        else if(h_cnt==H_PIX_MAX-10'd1)begin
            h_cnt<=11'd0;
            v_cnt<=v_cnt+11'd1;
            rd_en_i<=1'b0;
            hsync_o<=1'b1;
            vsync_o<=1'b1;
        end
    end
    
    else begin
        h_cnt<=h_cnt;
        v_cnt<=v_cnt;
        rd_en_i<=1'b0;
    end
end



endmodule