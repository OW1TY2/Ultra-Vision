module my16bram (
    input  wire             clk_in1 ,
    input  wire             clk_in2,

    input  wire                             bram0_wenb,
    input  wire                             bram1_wenb, 
    input  wire                             bram2_wenb,
    input  wire                             bram3_wenb, 
    input  wire             [10:0]          bram_waddr,
    input  wire             [ 7:0]          bram_wdata,

    input  wire            [10:0]          bram11_raddr,
    input  wire            [10:0]          bram12_raddr,
    input  wire            [10:0]          bram13_raddr,
    input  wire            [10:0]          bram14_raddr,

    input  wire            [10:0]          bram21_raddr,
    input  wire            [10:0]          bram22_raddr,
    input  wire            [10:0]          bram23_raddr,
    input  wire            [10:0]          bram24_raddr,

    input  wire            [10:0]          bram31_raddr,
    input  wire            [10:0]          bram32_raddr,
    input  wire            [10:0]          bram33_raddr,
    input  wire            [10:0]          bram34_raddr,

    input  wire            [10:0]          bram41_raddr,
    input  wire            [10:0]          bram42_raddr,
    input  wire            [10:0]          bram43_raddr,
    input  wire            [10:0]          bram44_raddr,
    

    output              [ 7:0]          bram11_rdata,
    output              [ 7:0]          bram12_rdata,
    output              [ 7:0]          bram13_rdata,
    output              [ 7:0]          bram14_rdata,

    output              [ 7:0]          bram21_rdata,
    output              [ 7:0]          bram22_rdata,
    output              [ 7:0]          bram23_rdata,
    output              [ 7:0]          bram24_rdata,

    output              [ 7:0]          bram31_rdata,
    output              [ 7:0]          bram32_rdata,
    output              [ 7:0]          bram33_rdata,
    output              [ 7:0]          bram34_rdata,

    output              [ 7:0]          bram41_rdata,
    output              [ 7:0]          bram42_rdata,
    output              [ 7:0]          bram43_rdata,
    output              [ 7:0]          bram44_rdata

);

// *******************************1line*******************************
my_bram_ip  u11_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram0_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram11_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram11_rdata )
);
my_bram_ip  u12_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram0_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram12_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram12_rdata )
);
my_bram_ip  u13_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram0_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram13_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram13_rdata )
);
my_bram_ip  u14_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram0_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram14_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram14_rdata )
);

// *******************************2line*******************************
my_bram_ip  u21_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram1_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram21_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram21_rdata )
);
my_bram_ip  u22_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram1_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram22_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram22_rdata )
);
my_bram_ip  u23_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram1_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram23_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram23_rdata )
);
my_bram_ip  u24_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram1_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram24_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram24_rdata )
);

// *******************************3line*******************************
my_bram_ip  u31_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram2_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram31_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram31_rdata )
);
my_bram_ip  u32_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram2_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram32_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram32_rdata )
);
my_bram_ip  u33_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram2_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram33_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram33_rdata )
);
my_bram_ip  u34_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram2_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram34_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram34_rdata )
);

// *******************************4line*******************************
my_bram_ip  u41_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram3_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram41_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram41_rdata )
);
my_bram_ip  u42_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram3_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram42_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram42_rdata )
);
my_bram_ip  u43_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram3_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram43_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram43_rdata )
);
my_bram_ip  u44_my_bram_ip(
    .clk_a                             (    clk_in1      ),
    .we_a                              (    bram3_wenb   ),
    .addr_a                            (    bram_waddr   ),
    .wdata_a                           (    bram_wdata   ),
    .rdata_a                           (                 ),
    .clk_b                             (    clk_in2      ), 
    .we_b                              (    1'b0         ),
    .addr_b                            (    bram44_raddr ),
    .wdata_b                           (    8'b0         ),
    .rdata_b                           (    bram44_rdata )
);




endmodule