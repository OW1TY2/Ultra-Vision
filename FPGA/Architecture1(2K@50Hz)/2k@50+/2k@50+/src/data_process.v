`timescale 1ns/1ps

module data_process#
(	parameter 	//////////////////720P边界可用640/////////////
            // H_FRONT	= 88,
			// H_SYNC 	= 44,
			// H_BACK 	= 148,
			// H_DISP	= 1920,
			// H_TOTAL	= 2200,
						
			// V_FRONT	= 4,
			// V_SYNC 	= 5,
			// V_BACK 	= 36,
			// V_DISP 	= 1080,
			// V_TOTAL	= 1125
            H_FRONT	= 10,
			H_SYNC 	= 2,
			H_BACK 	= 10,
			//H_DISP	= 640,
			//H_TOTAL	= 800,
						
			V_FRONT	= 0,
			V_SYNC 	= 10,
			V_BACK 	= 0
			//V_DISP 	= 480
			//V_TOTAL	= 525      
	// H_FRONT	=12'd110,
	// H_SYNC 	=12'd40,
	// H_BACK 	=12'd220,
	// H_DISP	=12'd1280,
	// H_DISP_REQ	=12'd1280,
	// H_TOTAL=	12'd1650,
 				
	// V_FRONT	=12'd5,
	// V_SYNC =	12'd5   ,
	// V_BACK =	12'd20 ,
	// V_DISP =	12'd720   ,
	// V_DISP_REQ =	12'd720  ,
	// V_TOTAL=	12'd750      
            )
(
    input clk,
    input rst_n,

	input frame_count,

    output reg data_vs,
    output reg data_hs,
    output reg data_de,
	output reg en,
    output [23:0] data_out,
	input [11:0]H_DISP,
	input [11:0]V_DISP
);
// parameter H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_DISP;
// parameter V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_DISP;
wire [11:0]H_TOTAL;
wire [11:0]V_TOTAL;
assign H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_DISP;
assign V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_DISP;


reg [1:0]bf_frame_count;
// reg en=1;
always @ (posedge clk)begin
	// bf_frame_count <= {bf_frame_count[0], frame_count};
	bf_frame_count[1] <= bf_frame_count[0];
	bf_frame_count[0] <= frame_count;
end


reg [13:0] hcnt=0; 
always @ (posedge clk or negedge rst_n)
begin
	if ((!rst_n)||(bf_frame_count == 2'b10 || bf_frame_count == 2'b01))begin
		hcnt <= 12'd0;
//		frame_count <= 1'b0;
	end
	else
		begin
        if(hcnt < H_TOTAL - 1'b1)		//line over			
            hcnt <= hcnt + 1'b1;
        else if(vcnt < V_TOTAL - 1'b1)		//frame over
            hcnt <= 12'd0;
        
        data_hs <= (en)? ((hcnt <= H_SYNC - 1'b1) ? 1'b0 : 1'b1) : 1'b0;//no used
		end
end 


//------------------------------------------
//v_sync counter & generator
reg [11:0] vcnt=0;
always@(posedge clk or negedge rst_n)
begin
	if ((!rst_n)||(bf_frame_count == 2'b10 || bf_frame_count == 2'b01))begin
		vcnt <= 12'b0;
		en <= 1;
	end
	else if(hcnt == H_TOTAL - 1'b1)		//line over
		begin
		if(vcnt < V_TOTAL - 1'b1)		//frame over
			vcnt <= vcnt + 1'b1;
		else begin
			vcnt <= 12'd0;//end write, hanging
			en <= 0;
		end
            
        data_vs <= (en)? ((vcnt <= V_SYNC - 1'b1) ? 1'b0 : 1'b1) : 1'b0;
		end
end


reg [23:0] data;
always @ (posedge clk)begin
	data_de	<= (en)?	((hcnt >= H_SYNC + H_BACK  && hcnt < H_SYNC + H_BACK + H_DISP) &&
						 (vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP) 
						 ? 1'b1 : 1'b0) : 1'b0;
    if((hcnt >= H_SYNC + H_BACK && hcnt < H_SYNC + H_BACK + H_DISP/2)&&(vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP/2))
    begin
        data <= 24'h0FF800;
    end else if((hcnt >= H_SYNC + H_BACK && hcnt < H_SYNC + H_BACK + H_DISP/2)&&(vcnt >= V_SYNC + V_BACK + V_DISP/2 && vcnt < V_SYNC + V_BACK + V_DISP))           
    begin
        data <= 24'h123456;
    end else if((hcnt >= H_SYNC + H_BACK + H_DISP/2 && hcnt < H_SYNC + H_BACK + H_DISP)&&(vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP/2))
    begin
        data <= 24'h285714;
    end else if((hcnt >= H_SYNC + H_BACK + H_DISP/2 && hcnt < H_SYNC + H_BACK + H_DISP)&&(vcnt >= V_SYNC + V_BACK + V_DISP/2 && vcnt < V_SYNC + V_BACK + V_DISP))
    begin
        data <= 24'hFC05C6;
    end    
end

assign data_out = (en)? (data_de ? data : 0) : 0;

endmodule