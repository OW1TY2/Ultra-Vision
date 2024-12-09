`timescale 1ns/1ps

module fifo_to_lcd#()
(
    input wr_clk,
    input rd_clk,
    input rst,
    input wr_en,
    input rd_en,
    input [23:0]data_in,
    input wire [11:0]Vv,
    input wire [11:0]Hh,

    output [23:0]data_out,
    output reg fifo_in_req,

    output reg start_disp,///fifo enough then start display

    output wire prog_empty_o,
    output wire prog_full_o,
    output wire full_o,
    output wire empty_o
);

// wire prog_empty_o;
// wire prog_full_o;
// wire full_o;
// wire empty_o;
wire [14:0]wr_datacount_o;
wire [14:0]rd_datacount_o;
reg [1:0]state;
parameter IDLE = 2'b00;
parameter WRITE_IN = 2'b01;
parameter READ_OUT = 2'b10;
parameter WRITE_READY = 2'b11;

// always @(posedge wr_clk or posedge rst) begin
//     if(rst) begin
//         state <= IDLE;
//         fifo_in_req <= 1'b0;
//         start_disp <= 0;
//     end
//     else if(wr_datacount_o <= 15'd6144 && state != WRITE_READY)begin
//         state <= WRITE_READY;
//     end
//     else if(wr_datacount_o <= 15'd20480 && (state == WRITE_READY || state == WRITE_IN))begin
//         state <= WRITE_IN;
//         fifo_in_req <= 1'b1;
//     end 
//     else if(wr_datacount_o >= 15'd20480 || (state == READ_OUT && rd_datacount_o >= 15'd6144))begin
//         state <= READ_OUT;
//         fifo_in_req <= 1'b0;
//         start_disp <= 1;
//     end
// end

reg [14:0]line;
always @(posedge wr_clk or posedge rst) begin
    if(rst)begin
        line <= 15'd24576;
    end
    else begin
        case ({Hh[11],Hh[10],Vv[10],Vv[9]})
            4'b0000: line <= 15'd24576;
            4'b0001: line <= 15'd20480;
            4'b0010: line <= 15'd16384;
            4'b0100: line <= 15'd24576;
            4'b0101: line <= 15'd16384;
            4'b0110: line <= 15'd9216;
            4'b1000: line <= 15'd24576;
            4'b1001: line <= 15'd9216;
            4'b1010: line <= 15'd5120;
            default: line <= 15'd16384;
        endcase
    end
end

always @(posedge wr_clk or posedge rst) begin
    if(rst) begin
        fifo_in_req <= 1'b0;
        start_disp <= 0;
    end
    else if(wr_datacount_o <= line)begin//d12288
        fifo_in_req <= 1'b1;
        start_disp <= start_disp;
    end
    else if(wr_datacount_o > line+1)begin//d12288

        fifo_in_req <= 1'b0;
        start_disp <= 1;
    end
end


// always @(posedge wr_clk or posedge rst) begin
//     if(rst) begin
//     end
//     else begin
//         case(state):
//             IDLE:begin
//             end
//             WRITE_IN:begin
//                 fifo_in <= 1'b1;
//             end
//             WRITE_READY:begin
//             end
//             READ_OUT:begin
//             end
//         endcase
//     end
// end

R0_FIFO u_R0_FIFO(
    .wr_clk_i(wr_clk),
    .rd_clk_i(rd_clk),
    .a_rst_i(rst),
    .wr_en_i(wr_en),
    .rd_en_i(rd_en),

    .wdata(data_in),
    .rdata(data_out),

    .prog_empty_o(prog_empty_o),
    .prog_full_o(prog_full_o),
    .full_o(full_o),
    .empty_o(empty_o),
    .wr_datacount_o(wr_datacount_o),
    .rd_datacount_o(rd_datacount_o)
);
endmodule