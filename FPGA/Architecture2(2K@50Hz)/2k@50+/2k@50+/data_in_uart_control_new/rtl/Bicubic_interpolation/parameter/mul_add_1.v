module mul_add_1(
	input        clk,
	input        rst_n,
	input [39:0] a,
	input [37:0] b,
	input        c,
	input [8:0]  coeffHalf,
	output reg [16:0]  result
);


//-----------------c1-----------------------
reg [45:0] result0_c1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result0_c1<=46'd0;
	end
	else begin
		result0_c1<=a+(c<<32);
	end
end

reg [45:0] b_c1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		b_c1 <= 46'd0;
	end
	else begin
		b_c1 <= b << 8;
	end
end

//-----------------c2-----------------------
reg [45:0] result1_c2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		result1_c2<=46'd0;
	end
	else begin
		result1_c2<=result0_c1 - b_c1;
	end
end


//---------------out--------------------
//寄存延时
always@(posedge clk)
begin
	result <= result1_c2[32:16];
end



endmodule