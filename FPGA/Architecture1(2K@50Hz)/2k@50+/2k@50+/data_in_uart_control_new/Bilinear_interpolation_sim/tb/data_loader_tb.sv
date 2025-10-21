`timescale 1ns/1ns
module data_loader_tb();

parameter H_PIX_MAX=10'd640;
parameter V_PIX_MAX=10'd480;

parameter H_PIX=12'd1920;
parameter V_PIX=12'd1080;
localparam image_width_grow  = 1280;
localparam image_height_grow = 600;

reg sys_clk_96M;//系统时钟
reg sys_clk_24M;//输出时钟
reg biliner_clk_in;
reg clk_out;//168MHz
reg sys_rst_n;
reg pix_clk_i;//输入时钟

reg hsync_i;
reg vsync_i;
reg pix_en_i;
reg ADV7611_config_done;
reg [23:0] RGB_data_i;

wire post_img_vsync;
wire post_img_href;
wire [31:0]      post_img_data;

reg         vsync_o_r;
assign vsync_pos = ~vsync_o_r &  post_img_vsync; // Edge detection
assign vsync_neg =  vsync_o_r & ~post_img_vsync;

always @(posedge biliner_clk_in) begin
    if (sys_rst_n == 1'b0)
        vsync_o_r <= 1'b0;
    else
        vsync_o_r <= post_img_vsync; // Record previous frame's vertical sync signal
end


initial
begin
    sys_clk_96M = 1'b0;
    forever #5 sys_clk_96M = ~sys_clk_96M; // Generate clock 1 100M
end

initial
begin
    sys_clk_24M = 1'b0;
    forever #21 sys_clk_24M = ~sys_clk_24M; // Generate clock 2 25M
end

initial
begin
    biliner_clk_in = 1'b0;
    forever #25 biliner_clk_in = ~biliner_clk_in; // Generate clock 2 20M
end

initial
begin
    clk_out = 1'b0;
    forever #2 clk_out = ~clk_out; // Generate clock 2 168M
end

initial
begin
    pix_clk_i = 1'b0;
    forever #40 pix_clk_i = ~pix_clk_i; // Generate clock 2 20M
end

initial
begin
    sys_rst_n = 1'b0;
    repeat(100) @(posedge sys_clk_96M); // After 200 clock cycles, set reset to 1
    sys_rst_n = 1'b1;
end

initial
begin
    ADV7611_config_done = 1'b0;
    repeat(100) @(posedge sys_clk_96M); // After 200 clock cycles, set reset to 1
    ADV7611_config_done = 1'b1;
end

task image_input(input string img_file);
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [23:0]       mem[H_PIX_MAX*V_PIX_MAX-1:0];
    $display("aaaaa");
    $readmemh(img_file, mem); // Read image data from file
    //$display(img_file);
    @(posedge pix_clk_i);
    vsync_i = 1'b1;
    for (row_cnt = 0; row_cnt < V_PIX_MAX; row_cnt++) begin
        repeat(5) @(posedge pix_clk_i);
        for (col_cnt = 0; col_cnt < H_PIX_MAX; col_cnt++) begin
            hsync_i  = 1'b1;
            //repeat(5) @(posedge pix_clk_i);
            pix_en_i= 1'b1;
            RGB_data_i  = mem[row_cnt*H_PIX_MAX + col_cnt]; // Transmit image data row by row
            @(posedge pix_clk_i);
        end
        pix_en_i= 1'b0;
        repeat(5) @(posedge pix_clk_i);
        hsync_i  = 1'b0;
    end
    repeat(5) @(posedge pix_clk_i);
    vsync_i = 1'b0; // Image data transmission complete
    @(posedge pix_clk_i);
endtask : image_input

reg  [11:0] c_dst_img_width;
reg  [11:0] c_dst_img_height;

always @(posedge clk_out)
begin
    if (sys_rst_n == 1'b0) begin
        c_dst_img_width  <= 27'd640; // Initialize destination image width
        c_dst_img_height <= 27'd480; // Initialize destination image height
    end
    else begin
        if (vsync_neg == 1) begin
            c_dst_img_width = c_dst_img_width + image_width_grow; // Update width at the end of each frame
            c_dst_img_height = c_dst_img_height + image_height_grow; // Update height at the end of each frame
        end
    end
end

task image_result_check(input string ref_file);
    reg frame_flag;
    bit [31:0] row_cnt;
    bit [31:0] col_cnt;
    bit [31:0] mem[]; 
    mem = new[c_dst_img_width*c_dst_img_height]; // Allocate memory for reference image

    frame_flag = 0;
    $display(ref_file);
    $readmemh(ref_file, mem); // Read reference data from file
    // Wait for the start of each frame
    @(vsync_pos);
    if (vsync_pos == 1'b1) begin
        frame_flag = 1;
        row_cnt = 0;
        col_cnt = 0;
        $display("############## Image result check begin ##############");
        $display ($time);
    end

    while (frame_flag) begin
        @(posedge clk_out);
        if (post_img_href == 1'b1) begin
            if (post_img_data != mem[row_cnt * c_dst_img_width + col_cnt]) begin
                $display("Result error ---> Row: %0d; Col: %0d; Pixel data: %h; Reference data: %h", row_cnt + 1, col_cnt + 1, post_img_data, mem[row_cnt * c_dst_img_width + col_cnt]);
            end
            col_cnt = col_cnt + 1;
        end
        
        if (col_cnt == c_dst_img_width) begin
            col_cnt = 0;
            row_cnt = row_cnt + 1; // Move to the next row
        end
        
        if (vsync_neg == 1'b1) begin
            frame_flag = 0;
            $display("############## Image result check end ##############");
            $display ($time);
        end
    end
endtask : image_result_check

initial
begin
    pix_en_i = 0;
    hsync_i  = 0;
    vsync_i  = 0;
    RGB_data_i=0;
end


initial
begin
    string img_file = "D:/FPGA_Competition/FPGAprojects/data_in_uart_control/rtl/Bilinear_interpolation/testbench_test/matlab_test/bigger_img_datas/img_640.dat";
    string ref_file_prefix = "D:/FPGA_Competition/FPGAprojects/data_in_uart_control/rtl/Bilinear_interpolation/testbench_test/matlab_test/bigger_img_datas/img_"; // Reference file prefix
    string ref_files[2]; // Assume a maximum of 11 reference files
    int ref_file_count = 0;
    string ref_file;
    
    // Loop to read each .dat file in the folder as reference files
    for (int i = 0; i < 2; i++) begin
        // Generate filename based on naming convention without spaces
        ref_file = {ref_file_prefix, $sformatf("%0d.dat", i*image_width_grow+640)}; 
        // Check if the file can be opened
        if ($fopen(ref_file, "r") != 0) begin
            ref_files[ref_file_count] = ref_file; // Store valid filenames
            ref_file_count++;
        end
    end

    wait(sys_rst_n);
   
    for (int i = 0; i < 2; i++) begin
        
        fork 

            image_result_check(ref_files[i]); // Check results
        join
        //join
        //repeat(5000) @(posedge clk_out); 
    end

end 


initial 
begin
    string img_file = "D:/FPGA_Competition/FPGAprojects/data_in_uart_control/rtl/Bilinear_interpolation/testbench_test/matlab_test/bigger_img_datas/img_640.dat";
    string ref_file_prefix = "D:/FPGA_Competition/FPGAprojects/data_in_uart_control/rtl/Bilinear_interpolation/testbench_test/matlab_test/bigger_img_datas/img_"; // Reference file prefix
    string ref_files[2]; // Assume a maximum of 11 reference files
    int ref_file_count = 0;
    string ref_file;
    
    // Loop to read each .dat file in the folder as reference files
    for (int i = 0; i < 2; i++) begin
        // Generate filename based on naming convention without spaces
        ref_file = {ref_file_prefix, $sformatf("%0d.dat", i*image_width_grow+640)}; 
        // Check if the file can be opened
        if ($fopen(ref_file, "r") != 0) begin
            ref_files[ref_file_count] = ref_file; // Store valid filenames
            ref_file_count++;
        end
    end

    wait(sys_rst_n);
   
    for (int i = 0; i < 2; i++) begin
        
        fork 
            begin
                image_input(img_file); // Input the image
            end
            //image_result_check(ref_files[i]); // Check results
        join
        //join
        //repeat(5000) @(posedge clk_out); 
    end
    
end 

Bilinear_interpolation_RGB_top Bilinear_interpolation_RGB_top_u(
    .sys_clk_96M    (sys_clk_96M),
    .sys_clk_24M    (sys_clk_24M),
    .biliner_clk_in (biliner_clk_in),
    .clk_out(clk_out),
    .sys_rst_n      (sys_rst_n),
    .pix_clk_i      (pix_clk_i),
    .RGB_data_i     (RGB_data_i),
    .pix_en_i       (pix_en_i),
    .hsync_i        (hsync_i),
    .vsync_i        (vsync_i),
    .ADV7611_config_done    (ADV7611_config_done),
    .c_dst_img_width        (c_dst_img_width),
    .c_dst_img_height        (c_dst_img_height),
    .post_img_vsync           (post_img_vsync),
    .post_img_href          (post_img_href),
    .post_img_data          (post_img_data)


);

endmodule