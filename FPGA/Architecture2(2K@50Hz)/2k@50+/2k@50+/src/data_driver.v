`timescale 1ns/1ps

module data_driver #(
	//	Setting up default timing
	parameter 	H_FRONT	= 12'd1,
			H_SYNC 	=  12'd1,
			H_BACK 	= 12'd1  ,
			H_DISP	= 12'd640,
			H_TOTAL	= 12'd643,
						
			V_FRONT	= 12'd1,
			V_SYNC 	= 12'd1,
			V_BACK 	= 12'd2,
			V_DISP 	= 12'd480,
			V_TOTAL	= 12'd484,
			
			DATA_WIDTH 	= 24
)(  	
	//global clocks
	//input clk_x27,
	input					clk,			//system clock
	input					rst_n,     		//sync reset

	input fifo_in_req,
	
	output reg			data_hs,	    	//lcd horizontal sync
	output reg			data_vs,	    	//lcd vertical sync
	output reg			data_en,			//lcd display enable
	output	[DATA_WIDTH-1:0]	data_rgb,		//lcd display data

	//user interface
	output reg			data_req,	//lcd data request

	input 	[DATA_WIDTH-1:0]	data_data		//lcd data
);	 

wire [23:0]fake_data;
assign fake_data = (hcnt < H_SYNC + H_BACK + H_DISP/2)? 
				   
				   ((vcnt < V_SYNC + V_BACK + V_DISP/2)? 24'hFFFFFF : 24'h00FF00)
					:
				   ((vcnt < V_SYNC + V_BACK + V_DISP/2)? 24'h0000FF : 24'hFF0000);
				   


/*******************************************
		SYNC--BACK--DISP--FRONT
*******************************************/
//------------------------------------------

reg order_mes;

//h_sync counter & generator
reg [13:0] hcnt; 
always @ (posedge clk or negedge rst_n)
begin
	if (!rst_n)begin
		hcnt <= 12'd0;
		order_mes <= 0;
	end
	else begin
		if(fifo_in_req)begin
			order_mes <= 1;
		end 
		
		if(order_mes)
			begin
				if(hcnt < H_TOTAL - 1'b1)begin		//line over			
					hcnt <= hcnt + 1'b1;
				end else begin
					hcnt <= 12'd0;
					order_mes <= 0;
				end
				
				data_hs <= ((hcnt <= H_SYNC - 1'b1) ? 1'b0 : 1'b1);
			end
	end
end 


//------------------------------------------
//v_sync counter & generator
reg [11:0] vcnt;
always@(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		vcnt <= 12'b0;
	else if(hcnt == H_TOTAL - 1'b1 && order_mes)		//line over
		begin
		if(vcnt < V_TOTAL - 1'b1)		//frame over
			vcnt <= vcnt + 1'b1;
		else
			vcnt <= 12'd0;
            
        data_vs <= (vcnt <= V_SYNC - 1'b1) ? 1'b0 : 1'b1;
		end
	else begin
		vcnt <= vcnt;
		data_vs <= data_vs;
	end	
end


//------------------------------------------
//LCELL	LCELL(.in(clk),.out(lcd_dclk));
assign	lcd_dclk = ~clk;
assign	lcd_blank = data_hs & data_vs;		
assign	lcd_sync = 1'b0;


//-----------------------------------------
reg     [DATA_WIDTH-1:0]  r_data_rgb = 0; 
always@(posedge clk) begin
	data_en		<=	(hcnt >= H_SYNC + H_BACK  && hcnt < H_SYNC + H_BACK + H_DISP) &&
						(vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP) 
						? 1'b1 : 1'b0;
    r_data_rgb 	<= 	data_data;
end 
assign data_rgb = data_en ? r_data_rgb : 0; 

//------------------------------------------
//ahead x clock
localparam	H_AHEAD = 	12'd1;

//	Standard FIFO Request Port
 always@(posedge clk) begin
	data_req	<=	(hcnt >= H_SYNC + H_BACK - H_AHEAD && hcnt < H_SYNC + H_BACK + H_DISP - H_AHEAD) &&
						 (vcnt >= V_SYNC + V_BACK && vcnt < V_SYNC + V_BACK + V_DISP) 
						 ? 1'b1 : 1'b0;
end


endmodule