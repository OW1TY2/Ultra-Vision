from PIL import Image


def rgb_to_grayscale(image_path, output_path):
    # 打开图片
    image = Image.open(image_path)

    # 转换为灰度
    grayscale_image = image.convert('L')

    # 保存灰度图片
    grayscale_image.save(output_path)


# 使用示例
rgb_to_grayscale('tip_line.png', 'tip_line_gray.png')
