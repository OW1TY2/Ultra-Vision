% 设置图片大小
width = 640;
height = 480;

% 创建一个纯白图片矩阵，所有像素值都设置为255（白色），并复制到三个通道
whiteImage = repmat(127 * ones(height, width, 'uint8'), [1, 1, 3]);

% 显示图片
imshow(whiteImage);

% 如果需要保存图片，可以使用imwrite函数
imwrite(whiteImage, 'grayImage.png');