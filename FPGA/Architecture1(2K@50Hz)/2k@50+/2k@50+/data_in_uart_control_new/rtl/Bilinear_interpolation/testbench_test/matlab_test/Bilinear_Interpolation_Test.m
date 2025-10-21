clear all; close all; clc;

% 读取 RGB 图像
IMG1 = imread('img_rgb.png'); % 读取 RGB 图像
[h1, w1, c] = size(IMG1);      % 获取图像的高度、宽度和通道数

% 创建文件夹以保存 .dat 文件和图像
output_folder = 'bigger_img_datas';
image_folder = 'bigger_img';

if ~exist(output_folder, 'dir')
    mkdir(output_folder); % 创建输出文件夹
end
if ~exist(image_folder, 'dir')
    mkdir(image_folder); % 创建图像文件夹
end

% 设置目标高度和宽度
target_height = 1080;
target_width = 1920;

% 计算增量
num_chazhi = 1; % 增加的次数
height_increment = (target_height - h1) / num_chazhi; % 高度增量
width_increment = (target_width - w1) / num_chazhi;   % 宽度增量

% 将每个通道转换为十六进制并保存到 .dat 文件
for ch = 1:c
    filename = fullfile(output_folder, sprintf('img_%d_%c.dat', w1, 'r' + ch - 1));
    fid = fopen(filename, 'w');
    
    for i = 1:h1
        hex_values = dec2hex(IMG1(i, :, ch), 2); % 转换为十六进制
        hex_values_cell = cellstr(hex_values); % 转换为元胞数组
        fprintf(fid, '%s\n', strjoin(hex_values_cell, ' ')); % 写入文件
    end
    
    fclose(fid); % 关闭文件
end

% 保存原始图像为 32 位 .dat 文件
filename = fullfile(output_folder, sprintf('img_%d111.dat', w1 ));
fid = fopen(filename, 'w');

for i = 1:h1
    for j = 1:w1
        r = IMG1(i, j, 1);
        g = IMG1(i, j, 2);
        b = IMG1(i, j, 3);
        combined_value = bitshift(uint32(r), 16) + bitshift(uint32(g), 8) + uint32(b); % 32 位拼接
        hex_value = dec2hex(combined_value, 6); % 转换为十六进制
        
        fprintf(fid, '%s ', hex_value); % 写入文件
    end
    fprintf(fid, '\n'); % 换行
end

fclose(fid); % 关闭文件

% 处理图像并保存插值后的数据
for k = 1:num_chazhi
    h2 = round(h1 + k * height_increment); % 新的高度
    w2 = round(w1 + k * width_increment);   % 新的宽度
    
    % 分别处理每个通道
    img_r = IMG1(:, :, 1);
    img_g = IMG1(:, :, 2);
    img_b = IMG1(:, :, 3);
    
    % 调用函数进行插值
    r_channel = Bilinear_Interpolation_Int(img_r, h1, w1, h2, w2);
    g_channel = Bilinear_Interpolation_Int(img_g, h1, w1, h2, w2);
    b_channel = Bilinear_Interpolation_Int(img_b, h1, w1, h2, w2);
    
    % 合并插值后的三个通道
    IMG3 = cat(3, r_channel, g_channel, b_channel); % 拼接 RGB 通道
    
    % 将插值后的数据转换为十六进制并保存
    filename = fullfile(output_folder, sprintf('img_%d.dat', w1 + k * width_increment));
    fid = fopen(filename, 'w');
    for i = 1:h2
        for j = 1:w2
            r = r_channel(i, j);
            g = g_channel(i, j);
            b = b_channel(i, j);
            combined_value = bitshift(uint32(r), 16) + bitshift(uint32(g), 8) + uint32(b); % 32 位拼接
            hex_value = dec2hex(combined_value, 8); % 转换为十六进制
            
            % 写入文件
            fprintf(fid, '%s ', hex_value); % 写入文件
        end
        fprintf(fid, '\n'); % 写入文件
    end
    
    fclose(fid); % 关闭文件
    
    % 保存插值后的图像
    img_filename = fullfile(image_folder, sprintf('img_%d.png', w1 + k * width_increment));
    imwrite(IMG3, img_filename); % 保存图像
    disp('okk!');
end

disp('okk!!!!');
