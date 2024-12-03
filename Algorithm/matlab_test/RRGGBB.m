% 设置图像尺寸
width = 1920;
height = 1080;

% 计算每个竖条纹的宽度
numStripes = 500; % 竖条纹的数量
stripeWidth = floor(width / numStripes);

% 创建图像矩阵
image = zeros(height, width, 3, 'uint8');

% 随机生成每个竖条纹的颜色
for i = 1:numStripes
    % 随机颜色
    color = randi([0, 255], 1, 3);
    
    % 计算当前竖条纹的像素范围
    startX = (i - 1) * stripeWidth + 1;
    endX = min(i * stripeWidth, width);
    
    % 给当前竖条纹区域赋上随机颜色
    image(:, startX:endX, :) = repmat(reshape(color, 1, 1, 3), height, endX - startX + 1);
end

% 显示图像
imshow(image);


% 保存图像到文件
imwrite(image, 'striped_image.png');