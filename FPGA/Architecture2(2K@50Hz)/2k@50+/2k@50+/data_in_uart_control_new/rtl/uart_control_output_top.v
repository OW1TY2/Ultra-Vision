`timescale 1ns/1ns
module uart_control_output_top
(
	//global clock
	input				clk_24M,                //24MHz
//	input				rst_n,
    input               sys_clk_96M,  //96MHz
    input               sys_pll_locked,
	
	//user interface
    input               fpga_rxd_0,     //uart_0_input
    output              fpga_txd_0,     //uart_0_output
    
	input				fpga_rxd_1,		//uart_1_input
	output				fpga_txd_1		//uart_1_output
);
wire    clk_ref = sys_clk_96M;    //96MHz
wire    sys_rst_n = sys_pll_locked;


//------------------------------------
//Precise clk divider
wire	divide_clken;
integer_divider	
#(

//    .DEVIDE_CNT (13)      //460800bps * 16
	.DEVIDE_CNT	(52)	//115200bps * 16
//	.DEVIDE_CNT	(625)	//9600bps * 16
)
u_integer_devider
(
	//global
	.clk				(clk_ref),		//96MHz clock
	.rst_n				(sys_rst_n),    //global reset
	
	//user interface
	.divide_clken		(divide_clken)
);


wire	clken_16bps = divide_clken;
//---------------------------------
//Data receive for PC to FPGA.
wire			rxd_flag_0;
wire	[7:0]	rxd_data_0;
uart_receiver	u_uart_receiver_0
(
	//gobal clock
	.clk			(clk_ref),
	.rst_n			(sys_rst_n),
	
	//uart interface
	.clken_16bps	(clken_16bps),	//clk_bps * 16
	.rxd			(fpga_rxd_0),		//uart txd interface
	
	//user interface
	.rxd_data		(rxd_data_0),		//uart data receive
	.rxd_flag		(rxd_flag_0)  	//uart data receive done
);





//串口控制部分
wire			rxd_flag_1;
wire	[7:0]	rxd_data_1;
wire    [10:0]  x_pix_len;
wire    [10:0]  y_pix_len;
wire            pix_len_update;
wire            txd_flag;

reg             txd_en;
reg     [7:0]   txd_data;
reg     [1:0]   txd_cnt;

always@(posedge sys_clk_96M or negedge sys_rst_n)begin
    if(!sys_rst_n)begin 
        txd_en<=1'b0;
        txd_data<=8'b0;
        txd_cnt<=2'b0;
    end
    
    else if(txd_cnt==2'b0 && pix_len_update)begin//发送前8位
        txd_cnt<=2'b1;
        txd_data[2:0]<=x_pix_len[10:8];
        txd_en<=1'b1;
    end
    
    else if(txd_cnt==2'b1 && txd_flag)begin//发送后8位
        txd_cnt<=2'b10;
        txd_data[7:0]<=x_pix_len[7:0];
        txd_en<=1'b1;
    end    
    
    else if(txd_cnt==2'b10 && txd_flag)begin//等待发送完毕 归位
        txd_cnt<=2'b0;
        txd_data[7:0]<=8'b0;
        txd_en<=1'b0;
    end     
    
    else begin
        txd_en<=1'b0;
        txd_cnt<=txd_cnt;
        txd_data<=txd_data;
    end
end

uart_receiver	u_uart_receiver_1
(
	//gobal clock
	.clk			(clk_ref),
	.rst_n			(sys_rst_n),
	
	//uart interface
	.clken_16bps	(clken_16bps),	//clk_bps * 16
	.rxd			(fpga_rxd_1),		//uart txd interface
	
	//user interface
	.rxd_data		(rxd_data_1),		//uart data receive
	.rxd_flag		(rxd_flag_1)  	//uart data receive done
);

uart_control u_uart_control(
    .sys_rst_n      (sys_rst_n),
    .sys_clk        (sys_clk_96M),
    .uart_rx_flag   (rxd_flag_1),
    .uart_rx_data   (rxd_data_1),
    .x_pix_len      (x_pix_len),
    .y_pix_len      (y_pix_len),
    .pix_len_update (pix_len_update)
);


//---------------------------------
//Data receive for PC to FPGA.
uart_transfer	u_uart_transfer_1
(
	//gobal clock
	.clk			(clk_ref),
	.rst_n			(sys_rst_n),
	
	//uaer interface
	.clken_16bps	(clken_16bps),	//clk_bps * 16
	.txd			(fpga_txd_1),  	//uart txd interface
           
	//user interface  
	.txd_en			(rxd_flag_0),		//uart data transfer enable
	.txd_data		(rxd_data_0), 	//uart transfer data	
	.txd_flag		() 			    //uart data transfer done    
	//.txd_en			(txd_en),		//uart data transfer enable
	//.txd_data		(txd_data), 	//uart transfer data	
	//.txd_flag		(txd_flag) 			    //uart data transfer done
		    //uart data transfer done
);

//---------------------------------
//Data receive for PC to FPGA.
uart_transfer	u_uart_transfer_0
(
	//gobal clock
	.clk			(clk_ref),
	.rst_n			(sys_rst_n),
	
	//uaer interface
	.clken_16bps	(clken_16bps),	//clk_bps * 16
	.txd			(fpga_txd_0),  	//uart txd interface
           
	//user interface   
	//.txd_en			(rxd_flag_0),		//uart data transfer enable
	//.txd_data		(rxd_data_0), 	//uart transfer data	
	//.txd_flag		() 			    //uart data transfer done
    .txd_en			(txd_en),		//uart data transfer enable
    .txd_data		(txd_data), 	//uart transfer data	
    .txd_flag		(txd_flag) 			    //uart data transfer done
);
endmodule