# 算法代码已提交，文档还在写。。。。。。
代码部分top为 `rgb_bicubic.v`。`bicubic_interpolation.v`是一个通道的算法。 
可以看mian（划掉）文件夹里的算法细节


## 2024.12.9更新
1. 算法基于CrazyBingo的双线性缩放，借鉴了  [FPGA-Bicubic-interpolation](https://github.com/KevinHexin/FPGA-Bicubic-interpolation)
的8个插值参数计算部分（不过大部分插拍都改掉了），修改完成了算法。目前支持双线性，双三次，最近临的缩放。

2. `out_model`只在最后进行算法输出的选择，本质上三种算法都进行了计算。0为最近临，1为双线性，2为双三次。

3. 算法的状态机还是基于 CrazyBingo 的缩放算法，进行了更改以兼容双三次算法设计。



