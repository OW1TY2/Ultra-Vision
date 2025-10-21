clear all; close all; clc;

% ��ȡ RGB ͼ��
IMG1 = imread('img_rgb.png'); % ��ȡ RGB ͼ��
[h1, w1, c] = size(IMG1);      % ��ȡͼ��ĸ߶ȡ���Ⱥ�ͨ����

% �����ļ����Ա��� .dat �ļ���ͼ��
output_folder = 'bigger_img_datas';
image_folder = 'bigger_img';

if ~exist(output_folder, 'dir')
    mkdir(output_folder); % ��������ļ���
end
if ~exist(image_folder, 'dir')
    mkdir(image_folder); % ����ͼ���ļ���
end

% ����Ŀ��߶ȺͿ��
target_height = 1080;
target_width = 1920;

% ��������
num_chazhi = 1; % ���ӵĴ���
height_increment = (target_height - h1) / num_chazhi; % �߶�����
width_increment = (target_width - w1) / num_chazhi;   % �������

% ��ÿ��ͨ��ת��Ϊʮ�����Ʋ����浽 .dat �ļ�
for ch = 1:c
    filename = fullfile(output_folder, sprintf('img_%d_%c.dat', w1, 'r' + ch - 1));
    fid = fopen(filename, 'w');
    
    for i = 1:h1
        hex_values = dec2hex(IMG1(i, :, ch), 2); % ת��Ϊʮ������
        hex_values_cell = cellstr(hex_values); % ת��ΪԪ������
        fprintf(fid, '%s\n', strjoin(hex_values_cell, ' ')); % д���ļ�
    end
    
    fclose(fid); % �ر��ļ�
end

% ����ԭʼͼ��Ϊ 32 λ .dat �ļ�
filename = fullfile(output_folder, sprintf('img_%d111.dat', w1 ));
fid = fopen(filename, 'w');

for i = 1:h1
    for j = 1:w1
        r = IMG1(i, j, 1);
        g = IMG1(i, j, 2);
        b = IMG1(i, j, 3);
        combined_value = bitshift(uint32(r), 16) + bitshift(uint32(g), 8) + uint32(b); % 32 λƴ��
        hex_value = dec2hex(combined_value, 6); % ת��Ϊʮ������
        
        fprintf(fid, '%s ', hex_value); % д���ļ�
    end
    fprintf(fid, '\n'); % ����
end

fclose(fid); % �ر��ļ�

% ����ͼ�񲢱����ֵ�������
for k = 1:num_chazhi
    h2 = round(h1 + k * height_increment); % �µĸ߶�
    w2 = round(w1 + k * width_increment);   % �µĿ��
    
    % �ֱ���ÿ��ͨ��
    img_r = IMG1(:, :, 1);
    img_g = IMG1(:, :, 2);
    img_b = IMG1(:, :, 3);
    
    % ���ú������в�ֵ
    r_channel = Bilinear_Interpolation_Int(img_r, h1, w1, h2, w2);
    g_channel = Bilinear_Interpolation_Int(img_g, h1, w1, h2, w2);
    b_channel = Bilinear_Interpolation_Int(img_b, h1, w1, h2, w2);
    
    % �ϲ���ֵ�������ͨ��
    IMG3 = cat(3, r_channel, g_channel, b_channel); % ƴ�� RGB ͨ��
    
    % ����ֵ�������ת��Ϊʮ�����Ʋ�����
    filename = fullfile(output_folder, sprintf('img_%d.dat', w1 + k * width_increment));
    fid = fopen(filename, 'w');
    for i = 1:h2
        for j = 1:w2
            r = r_channel(i, j);
            g = g_channel(i, j);
            b = b_channel(i, j);
            combined_value = bitshift(uint32(r), 16) + bitshift(uint32(g), 8) + uint32(b); % 32 λƴ��
            hex_value = dec2hex(combined_value, 8); % ת��Ϊʮ������
            
            % д���ļ�
            fprintf(fid, '%s ', hex_value); % д���ļ�
        end
        fprintf(fid, '\n'); % д���ļ�
    end
    
    fclose(fid); % �ر��ļ�
    
    % �����ֵ���ͼ��
    img_filename = fullfile(image_folder, sprintf('img_%d.png', w1 + k * width_increment));
    imwrite(IMG3, img_filename); % ����ͼ��
    disp('okk!');
end

disp('okk!!!!');
