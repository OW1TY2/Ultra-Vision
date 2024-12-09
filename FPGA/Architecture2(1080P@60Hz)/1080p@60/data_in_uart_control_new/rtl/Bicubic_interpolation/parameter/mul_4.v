module mul_4(
	input clk,
	input rst_n,
	input [9:0] a,b,c,d,
	output reg [39:0] result
);

//-------------------c1---------------------
reg [19:0] result0;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result0<=20'd0;
	end
	else begin
		result0<=a*b;
	end
end


reg [ 9:0] c_c1,d_c1;
always@(posedge clk)
begin
	c_c1<=c;
	d_c1<=d;
end

//-------------------c2---------------------
reg [19:0] result1_c2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result1_c2<=20'd0;
	end
	else begin
		result1_c2<=c_c1*d_c1;
	end
end

reg [19:0] result0_c2;
always@(posedge clk)
begin
	result0_c2<=result0;
end

//------------------------c3----------------------

reg [36:0] result4_c3;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result4_c3<=40'd0;
	end
	else begin
		result4_c3<=result0_c2[19:1]*result1_c2[19:2];
	end
end

//---------------out--------------------
always@(posedge clk)
begin
	result<={result4_c3,3'b0};
end


endmodule


// module mul_4(
// 	input clk,
// 	input rst_n,
// 	input [9:0] a,b,c,d,
// 	output reg [39:0] result
// );

// //-------------------c1---------------------
// reg [19:0] result0;
// always@(posedge clk or negedge rst_n)
// begin
// 	if(!rst_n) begin
// 		result0<=20'd0;
// 	end
// 	else begin
// 		result0<=a*b;
// 	end
// end

// reg [19:0] result1;
// always@(posedge clk or negedge rst_n)
// begin
// 	if(!rst_n) begin
// 		result1<=20'd0;
// 	end
// 	else begin
// 		result1<=c*d;
// 	end
// end

// // reg [ 9:0] c_c1,d_c1;
// // always@(posedge clk)
// // begin
// // 	c_c1<=c;
// // 	d_c1<=d;
// // end

// //-------------------c2---------------------

// // reg [19:0] result1_c2;
// // always@(posedge clk or negedge rst_n)
// // begin
// // 	if(!rst_n) begin
// // 		result1_c2<=20'd0;
// // 	end
// // 	else begin
// // 		result1_c2<=c_c1*d_c1;
// // 	end
// // end

// // reg [19:0] result0_c2;
// // always@(posedge clk)
// // begin
// // 	result0_c2<=result0;
// // end
// reg [19:0]result_low, result_mid1, result_mid2, result_high;
// always@(posedge clk or negedge rst_n)
// begin
// 	if(!rst_n) begin
// 		result_low<=20'd0;
// 		result_mid1<=20'd0;
// 		result_mid2<=20'd0;
// 		result_high<=20'd0;
// 	end
// 	else begin
// 		result_low <= result0[9:0] * result1[9:0];
// 		result_mid1 <= result0[19:10] * result1[9:0];
// 		result_mid2 <= result0[9:0] * result1[19:10];
// 		result_high <= result0[19:10] * result1[19:10]; 
// 	end
// end
// //------------------------c3----------------------

// // reg [39:0] result4_c3;
// // always@(posedge clk or negedge rst_n)
// // begin
// // 	if(!rst_n) begin
// // 		result4_c3<=40'd0;
// // 	end
// // 	else begin
// // 		result4_c3<=result0_c2*result1_c2;
// // 	end
// // end

// reg [39:0] result4;
// always@(posedge clk or negedge rst_n)
// begin
// 	if(!rst_n) begin
// 		result4<=40'd0;
// 	end
// 	else begin
// 		result4<=(result_high << 20) + ((result_mid1 + result_mid2) << 10) + (result_low) ;
// 	end
// end

// //---------------out--------------------
// always@(posedge clk)
// begin
// 	result<=result4;
// end



// endmodule