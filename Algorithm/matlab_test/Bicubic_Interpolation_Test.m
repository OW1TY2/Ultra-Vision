clear all; close all; clc;

% ��ȡ RGB ͼ��
IMG1 = imread('whiteImage.png'); % ��ȡ RGB ͼ��
[h1, w1, c] = size(IMG1);      % ��ȡͼ��ĸ߶ȡ���Ⱥ�ͨ����

% �����ļ����Ա��� .dat �ļ���ͼ��

out_model =2;

% ����Ŀ��߶ȺͿ��
target_width =  708;
target_height = 518;


% ��������
num_chazhi =1 ; % ���ӵĴ���

if (out_model==0)
    output_folder = 'neighbor_img_datas';
    image_folder = 'neighbor_img';
    if ~exist(output_folder, 'dir')
        mkdir(output_folder); % ��������ļ���
    end
    if ~exist(image_folder, 'dir')
        mkdir(image_folder); % ����ͼ���ļ���
    end
end
if (out_model==1)
    output_folder = 'biliner_img_datas';
    image_folder = 'biliner_img';
    if ~exist(output_folder, 'dir')
        mkdir(output_folder); % ��������ļ���
    end
    if ~exist(image_folder, 'dir')
        mkdir(image_folder); % ����ͼ���ļ���
    end
end

if (out_model==2)
    output_folder = 'bicubic_img_datas';
    image_folder = 'bicubic_img';
    if ~exist(output_folder, 'dir')
        mkdir(output_folder); % ��������ļ���
    end
    if ~exist(image_folder, 'dir')
        mkdir(image_folder); % ����ͼ���ļ���
    end
end



height_increment = (target_height - h1) / num_chazhi; % �߶�����
width_increment = (target_width - w1) / num_chazhi;   % �������
if (1)
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
filename = fullfile(output_folder, sprintf('img_%d_%d.dat', w1,h1 ));
fid = fopen(filename, 'w');

for i = 1:h1
    for j = 1:w1
        r = IMG1(i, j, 1);
        g = IMG1(i, j, 2);
        b = IMG1(i, j, 3);
        combined_value = bitshift(uint32(r), 16) + bitshift(uint32(g), 8) + uint32(b); % 32 λƴ��
        hex_value = dec2hex(combined_value, 8); % ת��Ϊʮ������
        
        fprintf(fid, '%s ', hex_value); % д���ļ�
    end
    fprintf(fid, '\n'); % ����
end

fclose(fid); % �ر��ļ�

filename_out = fullfile(output_folder, sprintf('out_img_%d_%d.dat', w1,h1 ));
fid_out = fopen(filename_out, 'w');
fclose(fid_out);

end
% ����ͼ�񲢱����ֵ�������
for k = 1:num_chazhi
    h2 = round(h1 + k * height_increment); % �µĸ߶�
    w2 = round(w1 + k * width_increment);   % �µĿ��
    
    % �ֱ���ÿ��ͨ��
    img_r = IMG1(:, :, 1);
    img_g = IMG1(:, :, 2);
    img_b = IMG1(:, :, 3);
    
    % ���ú������в�ֵ
    if (out_model==0)
        r_channel = Neighborhood_Int(img_r, h1, w1, h2, w2);
        g_channel = Neighborhood_Int(img_g, h1, w1, h2, w2);
        b_channel = Neighborhood_Int(img_b, h1, w1, h2, w2);
    end
    if (out_model==1)
        r_channel = Bilinear_Interpolation_Int(img_r, h1, w1, h2, w2);
        g_channel = Bilinear_Interpolation_Int(img_g, h1, w1, h2, w2);
        b_channel = Bilinear_Interpolation_Int(img_b, h1, w1, h2, w2);
    end
     if(out_model==2)
            r_channel = Bicubic_Interpolation(img_r, h1, w1, h2, w2);
            g_channel = Bicubic_Interpolation(img_g, h1, w1, h2, w2);
            b_channel = Bicubic_Interpolation(img_b, h1, w1, h2, w2);
    end
    % �ϲ���ֵ�������ͨ��
    IMG3 = cat(3, r_channel, g_channel, b_channel); % ƴ�� RGB ͨ��
    
    % ����ֵ�������ת��Ϊʮ�����Ʋ�����
    filename = fullfile(output_folder, sprintf('img_%d_%d.dat', w1 + k * width_increment,h1 + k * height_increment));
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
    filename_out = fullfile(output_folder, sprintf('out_img_%d_%d.dat', w1 + k * width_increment,h1 + k * height_increment));
    fid_out = fopen(filename_out, 'w');
    fclose(fid_out); % �ر��ļ�

    
    % �����ֵ���ͼ��
    img_filename = fullfile(image_folder, sprintf('img_%d_%d.png', w1 + k * width_increment,h1 + k * height_increment));
    imwrite(IMG3, img_filename); % ����ͼ��
    disp(strcat('okk!',img_filename));
end

disp('okk!!!!');


