`timescale 1ns/1ps

//`include "ddr3_controller.vh"


module example_top 
(
	////////////////////////////////////////////////////////////////
	//	External Clock & Reset
	//input 			nrst, 			//	Button K2
	input 			clk_24m,			//	24MHz Crystal
	input 			clk_25m,			//	25MHz Crystal 
	//////////////////////////////////////
	//input clk
	output          input_pll_rstn_o, 	//	Input PLL Reset
	input           clk_96m,
	input           clk_6m,
	input           clk_100m,

	input           input_pll_lock,		//	Input PLL Lock
	
	////////////////////////////////////////////////////////////////
	//	System Clock
	output 			sys_pll_rstn_o, 		
	
	input 			clk_sys,			//	Sys PLL 25M 
	input 			clk_pixel,			//	Sys PLL 74.25MHz
	input 			clk_pixel_2x,		//	Sys PLL 148.5MHz
	input 			clk_pixel_10x,		//	Sys PLL 742.5MHz
	
	input 			sys_pll_lock,		//	Sys PLL Lock
	
	////////////////////////////////////////////////////////////////
	// //	MIPI-DSI Clock & Reset
	////////////////////////////////////////////////////////////////
	//	DDR Clock
	output 			ddr_pll_rstn_o, 
	
	input 			tdqss_clk,			
	input 			core_clk,			//	DDR PLL 200MHz
	input 			tac_clk,			
	input 			twd_clk,			
	
	input 			ddr_pll_lock,		//	DDR PLL Lock
	
	////////////////////////////////////////////////////////////////
	//	DDR PLL Phase Shift Interface
	output 	[2:0] 	shift,
	output 	[4:0] 	shift_sel,
	output 			shift_ena,

	////////////////////////////////////////////////////////////////
	//	LVDS Clock
	////////////////////////////////////////////////////////////////
	//	DDR Interface Ports
	output 	[15:0] 	addr,
	output 	[2:0] 	ba,
	output 			we,
	output 			reset,
	output 			ras,
	output 			cas,
	output 			odt,
	output 			cke,
	output 			cs,
	
	//	DQ I/O
	input 	[15:0] 	i_dq_hi,
	input 	[15:0] 	i_dq_lo,
	
	output 	[15:0] 	o_dq_hi,
	output 	[15:0] 	o_dq_lo,
	output 	[15:0] 	o_dq_oe,
	
	//	DM O
	output 	[1:0] 	o_dm_hi,
	output 	[1:0] 	o_dm_lo,
	
	//	DQS I/O
	input 	[1:0] 	i_dqs_hi,
	input 	[1:0] 	i_dqs_lo,
	
	input 	[1:0] 	i_dqs_n_hi,
	input 	[1:0] 	i_dqs_n_lo,
	
	output 	[1:0] 	o_dqs_hi,
	output 	[1:0] 	o_dqs_lo,
	
	output 	[1:0] 	o_dqs_n_hi,
	output 	[1:0] 	o_dqs_n_lo,
	
	output 	[1:0] 	o_dqs_oe,
	output 	[1:0] 	o_dqs_n_oe,
	
	//	CK
	output 			clk_p_hi, 
	output 			clk_p_lo, 
	output 			clk_n_hi, 
	output 			clk_n_lo, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	MIPI-CSI Ctl / I2C
	// //	MIPI-CSI RXC 
	// //	MIPI-CSI RXD0
	// //	MIPI-CSI RXD1
	// //	MIPI-CSI RXD2
	// //	MIPI-CSI RXD3
	////////////////////////////////////////////////////////////////
	// //	DSI PWM & Reset Control 
	// //	MIPI-DSI TXC / TXD
	////////////////////////////////////////////////////////////////
	//	UART Interface
	// input 		 	uart_rx_i,			//	Support 460800-8-N-1. 
	// output 		 	uart_tx_o, 
	input           fpga_rxd_0,
	input           fpga_rxd_1,
	output          fpga_txd_0,
	output          fpga_txd_1,
	
	output 	[7:0] 	led_o,			//	
	
	
	////////////////////////////////////////////////////////////////
	// //	CMOS Sensor
	// //	CMOS Interface
	////////////////////////////////////////////////////////////////
	//	HDMI Interface
	output 			hdmi_txc_oe,
	output 			hdmi_txd0_oe,
	output 			hdmi_txd1_oe,
	output 			hdmi_txd2_oe,
	
	output 			hdmi_txc_rst_o,
	output 			hdmi_txd0_rst_o,
	output 			hdmi_txd1_rst_o,
	output 			hdmi_txd2_rst_o,
	
	output 	[9:0] 	hdmi_txc_o,
	output 	[9:0] 	hdmi_txd0_o,
	output 	[9:0] 	hdmi_txd1_o,
	output 	[9:0] 	hdmi_txd2_o,
	
	
	////////////////////////////////////////////////////////////////
	// //	LVDS Interface
	////////////////////////////////////////////////////////////////
	input hdmi_pclk_i,
	input hdmi_vs_i,
	input hdmi_hs_i,
	input hdmi_de_i,
	input [23:0] hdmi_data_i,
	output hdmi_scl_io,
	input hdmi_sda_io_IN,
	output hdmi_sda_io_OUT,
	output adv7611_rstn,
	output hdmi_sda_io_OE

	//	SPI Pins
	// output 			spi_sck_o, 
	// output 			spi_ssn_o 			
);
	
	parameter 	SIM_DATA 	= 0; 
	
	//	Hardware Configuration
	assign clk_p_hi = 1'b0;	//	DDR3 Clock requires 180 degree shifted. 
	assign clk_p_lo = 1'b1;
	assign clk_n_hi = 1'b1;
	assign clk_n_lo = 1'b0; 
	
	//	System Clock Tree Control
	assign sys_pll_rstn_o = 1'b1; 	//	nrst; 	//	Reset whole system when nrst (K2) is pressed. 
	assign input_pll_rstn_o = 1'b1; 	//	nrst; 	//	Reset whole system when nrst (K2) is pressed.

	//assign dsi_pll_rstn_o = sys_pll_lock; 
	assign ddr_pll_rstn_o = sys_pll_lock; 
	//assign lvds_pll_rstn_o = sys_pll_lock; 
	
	wire 			w_pll_lock = sys_pll_lock && ddr_pll_lock && input_pll_lock; // && lvds_pll_lock && dsi_pll_lock
	
	//	Synchronize System Resets. 
	reg 			rstn_sys = 0, rstn_pixel = 0; 
	wire 			rst_sys = ~rstn_sys, rst_pixel = ~rstn_pixel; 
	
	// reg 			rstn_dsi_refclk = 0, rstn_dsi_byteclk = 0; 
	// wire 			rst_dsi_refclk = ~rstn_dsi_refclk, rst_dsi_byteclk = ~rstn_dsi_byteclk; 
	
	// reg 			rstn_lvds_1x = 0; 
	// wire 			rst_lvds_1x = ~rstn_lvds_1x; 
	
	// reg 			rstn_27m = 0, rstn_54m = 0; 
	// wire 			rst_27m = ~rstn_27m, rst_54m = ~rstn_54m; 
	reg rstn_96m = 0;
	wire rst_96m = ~rstn_96m;
	
	//	Clock Gen
//	always @(posedge clk_27m or negedge w_pll_lock) begin if(~w_pll_lock) rstn_27m <= 0; else rstn_27m <= 1; end
	always @(posedge clk_96m or negedge w_pll_lock) begin if(~w_pll_lock) rstn_96m <= 0; else rstn_96m <= 1; end
	always @(posedge clk_sys or negedge w_pll_lock) begin if(~w_pll_lock) rstn_sys <= 0; else rstn_sys <= 1; end
	always @(posedge clk_pixel or negedge w_pll_lock) begin if(~w_pll_lock) rstn_pixel <= 0; else rstn_pixel <= 1; end
	// always @(posedge dsi_refclk_i or negedge w_pll_lock) begin if(~w_pll_lock) rstn_dsi_refclk <= 0; else rstn_dsi_refclk <= 1; end
	// always @(posedge dsi_byteclk_i or negedge w_pll_lock) begin if(~w_pll_lock) rstn_dsi_byteclk <= 0; else rstn_dsi_byteclk <= 1; end
	//always @(posedge clk_lvds_1x or negedge w_pll_lock) begin if(~w_pll_lock) rstn_lvds_1x <= 0; else rstn_lvds_1x <= 1; end
	
	
	localparam 	CLOCK_MAIN 	= 96000000; 	//	System clock using 96MHz. 
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	Flash Burner Control
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	LCD Data Mux
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DDR3 Controller
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire			w_ddr3_ui_clk = clk_100m;
	wire			w_ddr3_ui_rst = rst_96m;
	wire			w_ddr3_ui_areset = rst_96m;
	wire			w_ddr3_ui_aresetn = rstn_96m;
	

	//	General AXI Interface 
	wire	[3:0] 	w_ddr3_awid;
	wire	[31:0]	w_ddr3_awaddr;
	wire	[7:0]		w_ddr3_awlen;
	wire			w_ddr3_awvalid;
	wire			w_ddr3_awready;
	
	wire 	[3:0]  	w_ddr3_wid;
	wire 	[127:0] 	w_ddr3_wdata;
	wire 	[15:0]	w_ddr3_wstrb;
	wire			w_ddr3_wlast;
	wire			w_ddr3_wvalid;
	wire			w_ddr3_wready;
	
	wire 	[3:0] 	w_ddr3_bid;
	wire 	[1:0] 	w_ddr3_bresp;
	wire			w_ddr3_bvalid;
	wire			w_ddr3_bready;
	
	wire	[3:0] 	w_ddr3_arid;
	wire	[31:0]	w_ddr3_araddr;
	wire	[7:0]		w_ddr3_arlen;
	wire			w_ddr3_arvalid;
	wire			w_ddr3_arready;
	
	wire 	[3:0] 	w_ddr3_rid;
	wire 	[127:0] 	w_ddr3_rdata;
	wire			w_ddr3_rlast;
	wire			w_ddr3_rvalid;
	wire			w_ddr3_rready;
	wire 	[1:0] 	w_ddr3_rresp;
	
	
	//	AXI Interface Request
	wire 	[3:0] 	w_ddr3_aid;
	wire 	[31:0] 	w_ddr3_aaddr;
	wire 	[7:0]  	w_ddr3_alen;
	wire 	[2:0]  	w_ddr3_asize;
	wire 	[1:0]  	w_ddr3_aburst;
	wire 	[1:0]  	w_ddr3_alock;
	wire			w_ddr3_avalid;
	wire			w_ddr3_aready;
	wire			w_ddr3_atype;
	
	wire 			w_ddr3_cal_done, w_ddr3_cal_pass; 
	
	//	Do not issue DDR read / write when ~cal_done. 
	reg 			r_ddr_unlock = 0; 
	always @(posedge w_ddr3_ui_clk or negedge w_ddr3_ui_aresetn) begin
		if(~w_ddr3_ui_aresetn)
			r_ddr_unlock <= 0; 
		else
			r_ddr_unlock <= w_ddr3_cal_done; 
	end
	
	DdrCtrl ddr3_ctl_axi (	
		.core_clk		(core_clk),
		.tac_clk		(tac_clk),
		.twd_clk		(twd_clk),	
		.tdqss_clk		(tdqss_clk),
		
		.reset		(reset),
		.cs			(cs),
		.ras			(ras),
		.cas			(cas),
		.we			(we),
		.cke			(cke),    
		.addr			(addr),
		.ba			(ba),
		.odt			(odt),
		
		.o_dm_hi		(o_dm_hi),
		.o_dm_lo		(o_dm_lo),
		
		.i_dq_hi		(i_dq_hi),
		.i_dq_lo		(i_dq_lo),
		.o_dq_hi		(o_dq_hi),
		.o_dq_lo		(o_dq_lo),
		.o_dq_oe		(o_dq_oe),
		
		.i_dqs_hi		(i_dqs_hi),
		.i_dqs_lo		(i_dqs_lo),
		.i_dqs_n_hi		(i_dqs_n_hi),
		.i_dqs_n_lo		(i_dqs_n_lo),
		.o_dqs_hi		(o_dqs_hi),
		.o_dqs_lo		(o_dqs_lo),
		.o_dqs_n_hi		(o_dqs_n_hi),
		.o_dqs_n_lo		(o_dqs_n_lo),
		.o_dqs_oe		(o_dqs_oe),
		.o_dqs_n_oe		(o_dqs_n_oe),
		
		.clk			(w_ddr3_ui_clk),
		.reset_n		(w_ddr3_ui_aresetn),
		
		.axi_avalid		(w_ddr3_avalid && r_ddr_unlock),	//	Enable command only when unlocked. 
		.axi_aready		(w_ddr3_aready),
		.axi_aaddr		(w_ddr3_aaddr),
		.axi_aid		(w_ddr3_aid),
		.axi_alen		(w_ddr3_alen),
		.axi_asize		(w_ddr3_asize),
		.axi_aburst		(w_ddr3_aburst),
		.axi_alock		(w_ddr3_alock),
		.axi_atype		(w_ddr3_atype),
		
		.axi_wid		(w_ddr3_wid),
		.axi_wvalid		(w_ddr3_wvalid),
		.axi_wready		(w_ddr3_wready),
		.axi_wdata		(w_ddr3_wdata),
		.axi_wstrb		(w_ddr3_wstrb),
		.axi_wlast		(w_ddr3_wlast),
		
		.axi_bvalid		(w_ddr3_bvalid),
		.axi_bready		(w_ddr3_bready),
		.axi_bid		(w_ddr3_bid),
		.axi_bresp		(w_ddr3_bresp),
		
		.axi_rvalid		(w_ddr3_rvalid),
		.axi_rready		(w_ddr3_rready),
		.axi_rdata		(w_ddr3_rdata),
		.axi_rid		(w_ddr3_rid),
		.axi_rresp		(w_ddr3_rresp),
		.axi_rlast		(w_ddr3_rlast),
		
		.shift		(shift),
		.shift_sel		(),
		.shift_ena		(shift_ena),
		
		.cal_ena		(1'b1),
		.cal_done		(w_ddr3_cal_done),
		.cal_pass		(w_ddr3_cal_pass)
	);
	
	assign w_ddr3_bready = 1'b1; 
	assign shift_sel = 5'b00100; 		//	ddr_tac_clk always use PLLOUT[2]. 
	
	
	AXI4_AWARMux #(.AID_LEN(4), .AADDR_LEN(32)) axi4_awar_mux (
		.aclk_i			(w_ddr3_ui_clk), 
		.arst_i			(w_ddr3_ui_rst), 
		
		.awid_i			(w_ddr3_awid),
		.awaddr_i			(w_ddr3_awaddr),
		.awlen_i			(w_ddr3_awlen),
		.awvalid_i			(w_ddr3_awvalid),
		.awready_o			(w_ddr3_awready),
		
		.arid_i			(w_ddr3_arid),
		.araddr_i			(w_ddr3_araddr),
		.arlen_i			(w_ddr3_arlen),
		.arvalid_i			(w_ddr3_arvalid),
		.arready_o			(w_ddr3_arready),
		
		.aid_o			(w_ddr3_aid),
		.aaddr_o			(w_ddr3_aaddr),
		.alen_o			(w_ddr3_alen),
		.atype_o			(w_ddr3_atype),
		.avalid_o			(w_ddr3_avalid),
		.aready_i			(w_ddr3_aready)
	);
	
	assign w_ddr3_asize = 4; 		//	Fixed 128 bits (16 bytes, size = 4)
	assign w_ddr3_aburst = 1; 
	assign w_ddr3_alock = 0; 
	
	//assign led_o[1:0] = {w_ddr3_cal_pass, w_ddr3_cal_done}; 
	
	
	
	
// //--------------------------------------------------------------------------------------------------------------------
// //--------------------------------------sync the vsync----------------------------------------------------------------
// //--------------------------------------------------------------------------------------------------------------------
// //--------------------------------------------------------------------------------------------------------------------
// assign adv7611_rstn = 1'b1;
// wire                   [   8:0]         i2c_config_index           ;
// wire                   [  23:0]         i2c_config_data            ;
// wire                   [   8:0]         i2c_config_size            ;
// wire                                    i2c_config_done            ;

// i2c_timing_ctrl #(
//     .CLK_FREQ ( 24_000_000 ),
//     .I2C_FREQ ( 50000 ))
//  u_i2c_timing_ctrl (
//     .clk                     ( clk_24m                      ),
//     .rst_n                   ( rstn_sys                    ),
//     .i2c_sdat_IN             ( hdmi_sda_io_IN              ),
//     .i2c_config_size         ( i2c_config_size   [7:0]  ),
//     .i2c_config_data         ( i2c_config_data   [23:0] ),

//     .i2c_sclk                ( hdmi_scl_io                 ),
//     .i2c_sdat_OUT            ( hdmi_sda_io_OUT             ),
//     .i2c_sdat_OE             ( hdmi_sda_io_OE              ),
//     .i2c_config_index        ( i2c_config_index  [7:0]  ),
//     .i2c_config_done         ( i2c_config_done          )
// );

// I2C_ADV7611_Config u_I2C_ADV7611_Config
// (
// .LUT_INDEX                         (i2c_config_index          ),
// .LUT_DATA                          (i2c_config_data           ),
// .LUT_SIZE                          (i2c_config_size           ) 
// );


wire                       LCD_DCLK ;
wire                       LCD_VS   ;
wire                       LCD_HS   ;
wire                       LCD_DE   ;
wire      [  31:0]         LCD_DATA ;                  

assign LCD_DCLK = 		  hdmi_pclk_i  ;
assign LCD_VS = 		  hdmi_vs_i    ;
assign LCD_HS = 		  hdmi_hs_i    ;
assign LCD_DE = 		  hdmi_de_i   ;
assign LCD_DATA = 		  {8'b0000_0000,hdmi_data_i}  ;//hdmi_data_i
///data in and process////////////////////////////////////////////////////////////
wire process_de;
wire process_vs;
wire [31:0]process_data;
wire [11:0]H_PROCESS;
wire [11:0]V_PROCESS;
wire ini;
wire hsync_o;
wire vsync_o;
wire wr_en_i;
wire rd_en_i;
wire [1:0]state_debug;

data_in_uart_control_top u_data_in_uart_control_top(
	.sys_clk_96M(clk_96m),
	.sys_clk_24M(clk_24m),//6M
	.biliner_clk_in(clk_24m),//>23m
	.biliner_clk_out(clk_pixel),//>168m
	.sys_rst_n(rstn_sys),//more pll

	//hdmi in
	.hdmi_pix_clk_i(hdmi_pclk_i),
	.hdmi_pix_en_i(hdmi_de_i),
	.hdmi_hsync_i(hdmi_hs_i),
	.hdmi_vsync_i(hdmi_vs_i),
	.hdmi_RGB_data_i(hdmi_data_i),//24'hFFFFFF
	//uart
	.fpga_rxd_0(fpga_rxd_0),//in
	.fpga_rxd_1(fpga_rxd_1),
	.fpga_txd_0(fpga_txd_0),//out
	.fpga_txd_1(fpga_txd_1),
	//ADV7611
	.hdmi_sda_io_IN(hdmi_sda_io_IN),
	.hdmi_sda_io_OE(hdmi_sda_io_OE),
	.hdmi_sda_io_OUT(hdmi_sda_io_OUT),
	.hdmi_scl_o(hdmi_scl_io),
	.adv7611_rstn(adv7611_rstn),
	//data out
	.post_img_href(process_de),
	.post_img_vsync(process_vs),
	.post_img_data(process_data[31:0]),

	.C_DST_IMG_HEIGHT(V_PROCESS),
	.C_DST_IMG_WIDTH(H_PROCESS),

	.ADV7611_config_done(ini),
	.hsync_o(hsync_o),
	.vsync_o(vsync_o),
	.wr_en_i(wr_en_i),
	.rd_en_i(rd_en_i),
	.state_debug(state_debug)

	//.frame_count(lcd_vs)
);

//data_product--------------------------------------------------------------------------------------------------------------
//data_product--------------------------------------------------------------------------------------------------------------
//data_product--------------------------------------------------------------------------------------------------------------
// wire self_vs;
// wire self_hs;
// wire self_de;
// wire [31:0] self_data;
// wire en;

// data_process u_data_process(
// 	.clk(clk_pixel),
// 	.rst_n(rstn_sys),
// 	.data_vs(self_vs),
// 	.data_hs(self_hs),
// 	.data_de(self_de),
// 	.data_out(self_data[23:0]),

// 	.H_DISP(H_REAL),
// 	.V_DISP(V_REAL),
// 	.frame_count(frame_count),

// 	.en(en)
// );

	////////////////////////////////////////////////////////////////
	//	DDR R/W Control


	wire                            lcd_de;
	wire                            lcd_hs;      
	wire                            lcd_vs;
	wire 					  lcd_request; 
	wire            [7:0]           lcd_red, lcd_red2;
	wire            [7:0]           lcd_green, lcd_green2;
	wire            [7:0]           lcd_blue, lcd_blue2;
	wire            [31:0]          lcd_data;


	assign w_ddr3_awid = 0; 
	assign w_ddr3_wid = 0; 
	
	wire 			w_wframe_vsync; 
	wire 	[7:0] 	w_axi_tp; 
	reg            frame_count=0;
///////////////////////////////////////////////paras///////////////////////////

	reg [9:0]sf=0;
	reg [9:0]cnt = 0;
	reg [11:0]hreal=640;
	reg [11:0]vreal=480;
	reg [11:0]bf_hreal = 640;
	reg [11:0]bf_vreal = 480;
	// always @(negedge self_vs) begin
	// 	if(sf<=1)begin
	// 		sf<=sf+1;
	// 	end	
	// 	else begin
	// 		sf<=0;
	// 		if(cnt<=100)
	// 			cnt<=cnt+1;
	// 		else
	// 			cnt<=0;
	// 	end
		
	// end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// reg [1:0]bf_process_vs;
	// always @(posedge clk_pixel or negedge rstn_sys)begin
	// 	if(!rstn_sys)
	// 		bf_process_vs[1:0] <= 2'b00;
	// 	else begin
	// 		bf_process_vs[1] <= bf_process_vs[0];
	// 		bf_process_vs[0] <= process_vs;
	// 	end
	// end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	always @(posedge clk_pixel or negedge rstn_sys) begin//write frame next
		if(!rstn_sys)begin
			hreal <= 640;
			vreal <= 480;
			bf_hreal <= 640;
			bf_vreal <= 480;
			frame_count <= 0;
		end else if(!trig_vs)begin//write frame next
			hreal <= H_PROCESS;
			vreal <= V_PROCESS;
			bf_hreal <= hreal;
			bf_vreal <= vreal;
			frame_count <= ~frame_count;
		end
	end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//or

	reg delay_vs=1'b0;
	wire trig_vs;
	always @(posedge clk_pixel or negedge rstn_sys)begin
		if(!rstn_sys)
			delay_vs <= 1'b0;
		else begin
			delay_vs <= process_vs;
		end
	end
	assign trig_vs = (process_vs) || (~delay_vs);//negetive trig

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// wire [11:0]H_REAL;
	// wire [11:0]V_REAL;
	// wire [11:0]bf_H_REAL;
	// wire [11:0]bf_V_REAL;
	// wire [31:0]ADDR_SIZE;
	// assign H_REAL = 12'd640;//from binary
	// assign V_REAL = 12'd480;
	// // assign H_REAL = hreal;
	// // assign V_REAL = vreal;
	// assign bf_H_REAL = bf_hreal;
	// assign bf_V_REAL = bf_vreal;

	//assign ADDR_SIZE = (bf_H_REAL * bf_V_REAL)<<2;

	wire [31:0]BLOCK;
	wire [31:0]W_ADDR_START;
	wire [31:0]R_ADDR_START;
	//wire [31:0]R_ADDR_END;

	assign BLOCK = 32'h0800_0000;//23+2+1=26bit
	assign W_ADDR_START = frame_count ? BLOCK : 0;
	assign R_ADDR_START = frame_count ? 0 : BLOCK;
	//assign R_ADDR_END = ADDR_SIZE;
//or?
	// reg [31:0]waddr=0;
	// reg [31:0]raddr=32'd8388608;
	// always @(negedge lcd_vs)begin
	// 	waddr <= BLOCK - waddr;
	// 	raddr <= BLOCK - raddr;
	// end 
	// assign W_ADDR_START = waddr;
	// assign R_ADDR_START = raddr;
	// assign R_ADDR_END = ADDR_SIZE;
//
	// assign ADDR_START = 0;
	// assign ADDR_END = ADDR_START + ADDR_SIZE;
////////////////////////////////////////////////////////////////////////////////////////////
wire w_full_o;
wire r_full_o;
	axi4_ctrl #(.C_W_WIDTH(32), .C_R_WIDTH(32), .C_ID_LEN(4)) u_axi4_ctrl (

		.axi_clk        (w_ddr3_ui_clk            ),
		.axi_reset      (w_ddr3_ui_rst            ),

		.axi_awaddr     (w_ddr3_awaddr       ),
		.axi_awlen      (w_ddr3_awlen        ),
		.axi_awvalid    (w_ddr3_awvalid      ),
		.axi_awready    (w_ddr3_awready      ),

		.axi_wdata      (w_ddr3_wdata        ),
		.axi_wstrb      (w_ddr3_wstrb        ),
		.axi_wlast      (w_ddr3_wlast        ),
		.axi_wvalid     (w_ddr3_wvalid       ),
		.axi_wready     (w_ddr3_wready       ),

		.axi_bid        (0          ),
		.axi_bresp      (0        ),
		.axi_bvalid     (1       ),

		.axi_arid       (w_ddr3_arid         ),
		.axi_araddr     (w_ddr3_araddr       ),
		.axi_arlen      (w_ddr3_arlen        ),
		.axi_arvalid    (w_ddr3_arvalid      ),
		.axi_arready    (w_ddr3_arready      ),

		.axi_rid        (w_ddr3_rid          ),
		.axi_rdata      (w_ddr3_rdata        ),
		.axi_rresp      (0        ),
		.axi_rlast      (w_ddr3_rlast        ),
		.axi_rvalid     (w_ddr3_rvalid       ),
		.axi_rready     (w_ddr3_rready       ),

		.wframe_pclk    (clk_pixel),//clk_pixel
		.wframe_vsync   (process_vs), //process_vs   ),		//	Writter VSync. Flush on rising edge. Connect to EOF. //self_vs
		.wframe_data_en (process_de && process_vs),//process_de
		.wframe_data    (process_data),//process_data
		
		.rframe_pclk    (clk_pixel_2x            ),
		.rframe_vsync   (~lcd_vs             ),		//	Reader VSync. Flush on rising edge. Connect to ~EOF. 
		.rframe_data_en (lcd_request             ),
		.rframe_data    (lcd_data           ),
		
		.tp_o 		(w_axi_tp),

		.W_C_BASE_ADDR(W_ADDR_START),//W_ADDR_START),//pingpong
		.R_C_BASE_ADDR(R_ADDR_START),//R_ADDR_START),
		.R_C_RD_END_ADDR(hreal*vreal*4),//R_ADDR_END),//H*V*4

		.w_full_o(w_full_o),
		.r_full_o(r_full_o)
	);
	assign led_o[0] = ~w_full_o; 
	assign led_o[1] = ~r_full_o;
	assign led_o[2] = process_vs;
	assign led_o[3] = ~hdmi_vs_i;
	assign led_o[4] = ~ini;
	assign led_o[5] = ~vsync_o;
	assign led_o[6] = ~wr_en_i;
	assign led_o[7] = ~rd_en_i;
	////////////////////////////////////////////////////////////////
	//  LCD Timing Driver
	
	lcd_driver #()u_lcd_driver
	(
	    //  global clock
	    .clk        (clk_pixel_2x   ),
	    .rst_n      (rstn_pixel), 
	    
	    //  lcd interface
	    .lcd_dclk   (               ),
	    .lcd_blank  (               ),
	    .lcd_sync   (               ),
	    .lcd_request(lcd_request    ), 	//	Request data 1 cycle ahead. 
	    .lcd_hs     (lcd_hs         ),
	    .lcd_vs     (lcd_vs         ),
	    .lcd_en     (lcd_de         ),
	    .lcd_rgb    ({lcd_red2,lcd_green2,lcd_blue2, lcd_red,lcd_green,lcd_blue}),

		.H_REAL     (hreal),
		.V_REAL     (vreal),
	    //  user interface
	    .lcd_data   ({lcd_data[23:0],lcd_data[23:0]} ),//////////////LCD_DATA connected
		// frame_pingpong
		//.frame_count()
		//.bf_process_vs(bf_process_vs)
		.trig_vs(trig_vs)
	);
	
	
	
	////////////////////////////////////////////////////////////////
	//	HDMI Interface. 
	
	//	HDMI requires specific timing, thus is not compatible with LCD & LVDS & DSI. Must implement standalone. 
	
	assign hdmi_txd0_rst_o = rst_pixel; 
	assign hdmi_txd1_rst_o = rst_pixel; 
	assign hdmi_txd2_rst_o = rst_pixel; 
	assign hdmi_txc_rst_o = rst_pixel; 
	
	assign hdmi_txd0_oe = 1'b1; 
	assign hdmi_txd1_oe = 1'b1; 
	assign hdmi_txd2_oe = 1'b1; 
	assign hdmi_txc_oe = 1'b1; 
	
	//-------------------------------------
	//Digilent HDMI-TX IP Modified by CB elec.
	rgb2dvi #(.ENABLE_OSERDES(0)) u_rgb2dvi 
	(
		//.TMDS_Clk_p		(hdmio_txc_p_o), 	//	w_hdmio_txc), 
		//.TMDS_Clk_n		(hdmio_txc_n_o), 
		//.TMDS_Data_p	(hdmio_txd_p_o), 	//	w_hdmio_txd), 
		//.TMDS_Data_n 	(hdmio_txd_n_o), 
		
		.oe_i 		(1), 			//	Always enable output
		.bitflip_i 		(4'b0000), 		//	Reverse clock & data lanes. 
		
		.aRst			(1'b0), 
		.aRst_n		(1'b1), 
		
		.PixelClk		(clk_pixel_2x        ),//pixel clk = 74.25M
		.SerialClk		(     ),//pixel clk *5 = 371.25M
		
		.vid_pVSync		(lcd_vs), 
		.vid_pHSync		(lcd_hs), 
		.vid_pVDE		(lcd_de), 
		.vid_pData		({lcd_red, lcd_green, lcd_blue}), 
		
		.txc_o			(hdmi_txc_o), 
		.txd0_o			(hdmi_txd0_o), 
		.txd1_o			(hdmi_txd1_o), 
		.txd2_o			(hdmi_txd2_o)
	); 
		
	






	
	
endmodule


