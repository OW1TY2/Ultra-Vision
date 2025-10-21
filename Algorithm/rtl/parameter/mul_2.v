module mul_2(
	input          clk,
	input          rst_n,
	input  [9:0]   a,
	input  [17:0]  b,
	output reg [27:0]  result
);


//---------------------c1----------------------
reg [27:0] result0;
always@(posedge clk )
begin
	if(!rst_n) begin
		result0<=28'd0;
	end
	else begin
		result0<=a*b;
	end
end

//----------------c2,c3,out------------------
reg [27:0] result1,result2;
//寄存延时
always@(posedge clk)
begin
	result1<=result0;
	result2<=result1;
	result<=result2;
end


endmodule