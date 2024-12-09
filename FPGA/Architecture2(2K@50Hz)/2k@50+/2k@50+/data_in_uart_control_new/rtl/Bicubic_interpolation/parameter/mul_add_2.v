module mul_add_2(
	input        clk,
	input        rst_n,
	input [39:0] a,
	input [37:0] b,
	input [27:0] c,
	input [17:0] d,
	input [8:0]  coeffHalf,
	output  reg [16:0] result
);
//--------------------c1---------------------
reg [45:0] result0_c1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result0_c1<=46'd0;
	end
	else begin
		result0_c1<=a+(c<<16);
	end
end

reg [45:0] result1_c1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result1_c1<=46'd0;
	end
	else begin
		result1_c1<=(b<<8)+(d<<24);
	end
end

//--------------------c2---------------------
reg [45:0] result2_c2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result2_c2<=46'd0;
	end
	else begin
		result2_c2<=result0_c1 - result1_c1;
	end
end


//---------------out--------------------
always@(posedge clk)
begin
	result <= result2_c2[32:16];
end




endmodule