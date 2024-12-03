from PIL import Image
import random

# 设置图片大小
width, height = 80, 60

# 创建一个新的灰度图片
image = Image.new('L', (width, height))

# 为图片的每个像素分配一个随机的灰度值
for x in range(width):
    for y in range(height):
        pixel_value = random.randint(0, 255)
        image.putpixel((x, y), pixel_value)

# 保存图片
image.save('img_gray.png')

# 显示图片
image.show()
