module mul_3(
	input clk,
	input rst_n,
	input [17:0] a,
	input [9:0] b,c,
	output reg [37:0] result
);

//------------c1----------------------
reg [19:0] result0;
always@(posedge clk )
begin
	if(!rst_n) begin
		result0<=20'd0;
	end
	else begin
		result0<=c*b;
	end
end

reg [17:0] a_reg;
always@(posedge clk )
begin
	if(!rst_n) begin
		a_reg<=18'd0;
	end
	else begin
		a_reg<=a;
	end
end

//------------c2----------------------
reg [19:0] result1;
reg [17:0] a_reg0;
//寄存延时
always@(posedge clk)
begin
	result1<=result0;
	a_reg0<=a_reg;
end

//------------c3----------------------
reg [37:0] result2;
always@(posedge clk )
begin
	if(!rst_n) begin
		result2<=38'd0;
	end
	else begin
		result2<=result1*a_reg0;
	end
end
//------------out----------------------
//寄存延时
always@(posedge clk)
begin
	result<=result2;
end


endmodule