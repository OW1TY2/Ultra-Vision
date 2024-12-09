module uart_control
(
    input               sys_rst_n,
    input               sys_clk,
    
    input               uart_rx_flag,
    input [7:0]         uart_rx_data,
    
    output reg [11:0]   x_pix_len,  //max 3840  min 320
    output reg [11:0]   y_pix_len,  //max 2160  min 330
    output reg          pix_len_update,//������±�־λ
    
    output reg [1:0]    algorithm,//0:˫���Բ�ֵ 1������ٲ�ֵ 2��˫���β�ֵ
    output reg          vid_format, //0:1080p 1:4k
    output reg [8:0]    bi_a    //˫���β�ֵ BiCubic���� ϵ��a��ֵ
);

reg [3:0]   rx_data_cnt;
reg [31:0]  temp_x_pix;
reg [31:0] temp_y_pix;
reg [7:0]   temp_vid_format;
reg [7:0]   temp_algorithm;
reg [15:0] temp_bi_a;

//����uart_rx_data  modeģʽ����
always@(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        x_pix_len<=12'd640;
        y_pix_len<=12'd480;
        vid_format<=1'b0;
        algorithm<=2'b0;
        temp_x_pix<=32'd0;
        temp_y_pix<=32'd0;
        rx_data_cnt<=4'd0;
        temp_bi_a<=16'b0;
        bi_a <=9'd128;
    end
    
    else if (rx_data_cnt==4'd0 && uart_rx_flag) begin //У��λ0
        if(uart_rx_data==8'd170)begin
            rx_data_cnt=4'd1;
        end
        else begin
            rx_data_cnt<=4'd0;
        end
    end
    
    else if (rx_data_cnt==4'd1 && uart_rx_flag) begin //У��λ1
        if(uart_rx_data==8'd85)begin
            rx_data_cnt<=4'd2;
        end
        else begin
            rx_data_cnt<=4'd0;
        end
    end
    
//����ߴ�x  
 
    else if (rx_data_cnt==4'd2 && uart_rx_flag) begin //����λx1
        if(uart_rx_data==8'b11001111)begin//jump to vid_format
            rx_data_cnt<=8;//jump to vid_format
        end
        
        else if(uart_rx_data==8'b00111111)begin//jump to algorithm
            rx_data_cnt<=10;//jump to algorithm
        end
        
        else if(uart_rx_data==8'b10101111)begin//jump to bi_a
            rx_data_cnt<=12;//jump to bi_a
        end
        
        else if(uart_rx_data[7:4]==4'b0) begin//����λΪ0ʱ����ͨ������������λx1
            rx_data_cnt<=4'd3;
            temp_x_pix[11:8]<=uart_rx_data[3:0];
        end
        
        else begin
            rx_data_cnt<=4'd0;//����������Ч
        end
    end   
    
    else if (rx_data_cnt==4'd3 && uart_rx_flag) begin //����λx2
        rx_data_cnt<=4'd4;
        temp_x_pix[7:0]<=uart_rx_data;
    end 
    
//����ߴ�y

    else if (rx_data_cnt==4'd4 && uart_rx_flag) begin //����λy1
        rx_data_cnt<=4'd5;
        temp_y_pix[11:8]<=uart_rx_data[3:0];
    end
    
    else if (rx_data_cnt==4'd5 && uart_rx_flag) begin//����λy2
        rx_data_cnt<=4'd6;
        temp_y_pix[7:0]<=uart_rx_data;
    end
    
//���ݷ�Χ����   
    else if (rx_data_cnt==4'd6) begin //��Χ����x y
        rx_data_cnt<=4'd7;
        
        //����x
        if(temp_x_pix<=32'd161)begin
            temp_x_pix<=32'd161;
        end
        else if(temp_x_pix>=32'd1920)begin
            temp_x_pix<=32'd1920;
        end
        else begin
            temp_x_pix<=temp_x_pix;
        end
        
        //����y
        if(temp_y_pix<=32'd121)begin
            temp_y_pix<=32'd121;
        end
        else if(temp_y_pix>=32'd1080)begin
            temp_y_pix<=32'd1080;
        end
        else begin
            temp_y_pix<=temp_y_pix;
        end
    end 

    else if (rx_data_cnt==4'd7)begin//�������
        rx_data_cnt<=4'd15;
        x_pix_len<=temp_x_pix[11:0];
        y_pix_len<=temp_y_pix[11:0];
        pix_len_update<=1'b1;
    end  
    
    else if (rx_data_cnt==4'd8 && uart_rx_flag) begin//����λvid_format
        rx_data_cnt<=4'd9;
        temp_vid_format<=uart_rx_data;
    end
    
    else if(rx_data_cnt==4'd9)begin//vid_format���
        if(temp_vid_format==8'b0)begin
            vid_format<=1'b0;
            rx_data_cnt<=4'd15;
        end
        
        else if (temp_vid_format==8'b1)begin
            vid_format<=1'b1;
            rx_data_cnt<=4'd15;
        end
        
        else begin
            rx_data_cnt<=4'd15;
        end
    end
        
    else if(rx_data_cnt==4'd10 && uart_rx_flag)begin//����λalgorithm
        rx_data_cnt<=4'd11;
        temp_algorithm<=uart_rx_data;
    end
    
    else if(rx_data_cnt==4'd11)begin//algorithm���
        if(temp_algorithm==8'b0)begin
            algorithm<=2'b0;
            rx_data_cnt<=4'd15;
        end
        
        else if(temp_algorithm==8'b1)begin
            algorithm<=2'b1;
            rx_data_cnt<=4'd15;
        end
        
        else if(temp_algorithm==8'b10)begin
            algorithm<=2'b10;
            rx_data_cnt<=4'd15;
        end
        
        else begin
            rx_data_cnt<=4'd15;
        end
    end
    
    else if(rx_data_cnt==4'd12&& uart_rx_flag)begin//����λ bi_a_1
        temp_bi_a[15:8]<=uart_rx_data;
        rx_data_cnt<=4'd13;
    end
    
    else if(rx_data_cnt==4'd13&& uart_rx_flag)begin//����λ bi_a_2
        temp_bi_a[7:0]<=uart_rx_data;
        rx_data_cnt<=4'd14;
    end    
    
    else if(rx_data_cnt==4'd14)begin//bi_a���
        bi_a<=temp_bi_a[8:0];
        rx_data_cnt<=4'd15;
    end
    
    else if (rx_data_cnt==4'd15)begin//����
        rx_data_cnt<=4'd0;
        temp_x_pix<=32'b0;
        temp_y_pix<=32'b0;
        temp_vid_format<=8'b0;
        temp_algorithm<=8'b0;
        pix_len_update<=1'b0;
    end  
    
    else begin
        pix_len_update<=1'b0;
        rx_data_cnt<=rx_data_cnt;
        temp_x_pix<=temp_x_pix;
        temp_y_pix<=temp_y_pix;
        temp_algorithm<=temp_algorithm;
        temp_vid_format<=temp_vid_format;
        temp_bi_a<=temp_bi_a;
        x_pix_len<=x_pix_len;
        y_pix_len<=y_pix_len;
    end
    
end

endmodule