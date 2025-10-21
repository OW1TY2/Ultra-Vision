`timescale 100ps/100ps
module tb_rgb_biliner;

localparam src_image_width  = 640;
localparam src_image_height = 480;
localparam image_width_grow  = 2880;
localparam image_height_grow = 1512;

//----------------------------------------------------------------------
// Clock and reset signals
reg                             clk_in1;
reg                             clk_in2;
reg                             rst_n;

initial
begin
    clk_in1 = 1'b0;
    forever #50 clk_in1 = ~clk_in1; // Generate clock 1
end

initial
begin
    clk_in2 = 1'b0;
    forever #1 clk_in2 = ~clk_in2; // Generate clock 2
end

initial
begin
    rst_n = 1'b0;
    repeat(50) @(posedge clk_in1); // After 50 clock cycles, set reset to 1
    rst_n = 1'b1;
end

//----------------------------------------------------------------------
// Image data prepared to be processed
reg                             per_img_vsync;
reg                             per_img_href;
reg             [7:0]           per_img_red;
reg             [7:0]           per_img_green;
reg             [7:0]           per_img_blue;

// Processed image data
wire                            post_img_vsync;
wire                            post_img_href;
wire            [31:0]          post_img_data;

wire                            post_img_vsync_pos;
wire                            post_img_vsync_neg;
reg                             post_img_vsync_r;

assign post_img_vsync_pos = ~post_img_vsync_r & post_img_vsync; // Edge detection
assign post_img_vsync_neg = post_img_vsync_r & ~post_img_vsync;

//------------------------Custom Section-------------------------
reg  [11:0] c_dst_img_width;
reg  [11:0] c_dst_img_height;

always @(posedge clk_in2)
begin
    if (rst_n == 1'b0) begin
        c_dst_img_width  <= 27'd640; // Initialize destination image width
        c_dst_img_height <= 27'd480; // Initialize destination image height
    end
    else begin
        if (post_img_vsync_neg == 1) begin
            c_dst_img_width = c_dst_img_width + image_width_grow; // Update width at the end of each frame
            c_dst_img_height = c_dst_img_height + image_height_grow; // Update height at the end of each frame
        end
    end
end
//-------------------------------Custom Section End---------------------------

//----------------------------------------------------------------------
// Task and function definitions
task image_input(input string img_file_r,input string img_file_s,input string img_file_t);
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [7:0]       red_mem[src_image_width*src_image_height-1:0];
    bit             [7:0]       green_mem[src_image_width*src_image_height-1:0];
    bit             [7:0]       blue_mem[src_image_width*src_image_height-1:0];
    
    // Read image data from file
    $readmemh(img_file_r, red_mem); // For red channel
    $readmemh(img_file_s, green_mem); // For green channel
    $readmemh(img_file_t, blue_mem); // For blue channel
    
    @(posedge clk_in1);
    per_img_vsync = 1'b1;
    for (row_cnt = 0; row_cnt < src_image_height; row_cnt++) begin
        repeat(1) @(posedge clk_in1);
        for (col_cnt = 0; col_cnt < src_image_width; col_cnt++) begin
            per_img_href  = 1'b1;
            per_img_red   = red_mem[row_cnt*src_image_width + col_cnt]; 
            per_img_green = green_mem[row_cnt*src_image_width + col_cnt];
            per_img_blue  = blue_mem[row_cnt*src_image_width + col_cnt];
            @(posedge clk_in1);
        end
        per_img_href  = 1'b0;
    end
    repeat(5) @(posedge clk_in1);
    per_img_vsync = 1'b0; // Image data transmission complete
    @(posedge clk_in1);
endtask : image_input

always @(posedge clk_in2) begin
    if (rst_n == 1'b0)
        post_img_vsync_r <= 1'b0;
    else
        post_img_vsync_r <= post_img_vsync; // Record previous frame's vertical sync signal
end

task image_result_check(input string ref_file);
    bit frame_flag;
    bit [31:0] row_cnt;
    bit [31:0] col_cnt;
    bit [31:0] ref_mem[]; 
    
    ref_mem = new[c_dst_img_width * c_dst_img_height]; // Allocate memory for reference image
    frame_flag = 0;
    
    // Read reference data from file
    $readmemh(ref_file, ref_mem); 
    $display(ref_file);
    
    // Wait for the start of each frame
    @(post_img_vsync_pos);
    if (post_img_vsync_pos == 1'b1) begin
        frame_flag = 1;
        row_cnt = 0;
        col_cnt = 0;
        $display("############## Image result check begin ##############");
        $display ($time);
    end

    while (frame_flag) begin
        @(posedge clk_in2);
        if (post_img_href == 1'b1) begin
            if (post_img_data != ref_mem[row_cnt * c_dst_img_width + col_cnt]) begin
                $display("Result error ---> Row: %0d; Col: %0d; Pixel data: %h; Reference data: %h", row_cnt + 1, col_cnt + 1, post_img_data, ref_mem[row_cnt * c_dst_img_width + col_cnt]);
            end
            col_cnt = col_cnt + 1;
        end
        
        if (col_cnt == c_dst_img_width) begin
            col_cnt = 0;
            row_cnt = row_cnt + 1; // Move to the next row
        end
        
        if (post_img_vsync_neg == 1'b1) begin
            frame_flag = 0;
            $display("############## Image result check end ##############");
            $display ($time);
        end
    end
endtask : image_result_check

//----------------------------------------------------------------------
// Instantiate the rgb_biliner module
rgb_biliner
#(
    .C_SRC_IMG_WIDTH (src_image_width),
    .C_SRC_IMG_HEIGHT(src_image_height)
)
u_rgb_biliner
(
    .clk_in1        (clk_in1        ),
    .clk_in2        (clk_in2        ),
    .rst_n          (rst_n          ),
    
    // Image data prepared to be processed
    .per_img_vsync  (per_img_vsync  ),
    .per_img_href   (per_img_href   ),
    .per_img_red    (per_img_red    ),
    .per_img_green  (per_img_green  ),
    .per_img_blue   (per_img_blue   ),
    
    // Processed image data
    .post_img_vsync (post_img_vsync ),
    .post_img_href  (post_img_href  ),
    .post_img_data  (post_img_data  ),
    .c_dst_img_width(c_dst_img_width),
    .c_dst_img_height(c_dst_img_height)
);

initial
begin
    per_img_vsync = 0;
    per_img_href  = 0;
    per_img_red   = 0;
    per_img_green = 0;
    per_img_blue  = 0;
end

initial 
begin
    string img_file_r = "F:/FPAG_comp/testbench_test/rgb_biliner1/matlab_test/bigger_img_datas/img_640_r.dat";
    string img_file_s = "F:/FPAG_comp/testbench_test/rgb_biliner1/matlab_test/bigger_img_datas/img_640_s.dat";
    string img_file_t = "F:/FPAG_comp/testbench_test/rgb_biliner1/matlab_test/bigger_img_datas/img_640_t.dat";
    string ref_file_prefix = "F:/FPAG_comp/testbench_test/rgb_biliner1/matlab_test/bigger_img_datas/img_"; // Reference file prefix
    string ref_files[5]; // Assume a maximum of 11 reference files
    int ref_file_count = 0;
    string ref_file;
    
    // Loop to read each .dat file in the folder as reference files
    for (int i = 0; i < 5; i++) begin
        // Generate filename based on naming convention without spaces
        ref_file = {ref_file_prefix, $sformatf("%0d.dat", i*image_width_grow+src_image_width)}; 
        // Check if the file can be opened
        if ($fopen(ref_file, "r") != 0) begin
            ref_files[ref_file_count] = ref_file; // Store valid filenames
            ref_file_count++;
        end
    end

    wait(rst_n);
    for (int i = 0; i < 5; i++) begin
        fork 
            begin 
                repeat(5) @(posedge clk_in1); 
                image_input(img_file_r,img_file_s,img_file_t); // Input the image
            end 
            image_result_check(ref_files[i]); // Check results
        join
        repeat(5000) @(posedge clk_in2); 
    end
end 

endmodule
