clc; clear;
weight =708;
height =518;
input_folder='bicubic_img_datas';
% 定义文件名和输出文件夹
inputFileName = fullfile(input_folder, sprintf('out_img_%d_%d.dat', weight,height ));
outputFolder = 'out_bicubic_img';
outputFileName = fullfile(outputFolder, sprintf('out_img_%d_%d.png', weight,height ));

% 确保输出文件夹存在
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 读取文件中的像素值
fileID = fopen(inputFileName, 'r');
pixelValues = fscanf(fileID, '%x', [1, Inf]);
fclose(fileID);

% 将1xN的向量转换为640x480的矩阵
img = reshape(pixelValues, [weight, height]);

% 将32位16进制数转换为RGB值
R = bitshift(img, -16); % 右移16位得到R
G = bitand(bitshift(img, -8), 255); % 与255做与操作后右移8位得到G
B = bitand(img, 255); % 直接与255做与操作得到B

% 将RGB值合并为一个图像矩阵
img1 = cat(3, R, G, B);

% 将像素值转换为图像
img1 = uint8(img1);

% 顺时针旋转90度
rotatedImg = imrotate(img1, -90);

% 镜像图片
mirroredImg = flip(rotatedImg, 2); % 沿着水平轴（第一维）翻转

% 保存图像
imwrite(mirroredImg, outputFileName);

% 显示图像
imshow(mirroredImg);