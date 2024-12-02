## 实现功能

该项目使用单片机作为图形界面上位机，通过串口控制FPGA内部缩放所使用的算法、算法所使用的权重参数、缩放大小等信息。图形界面支持用按键、滑块手动单独控制缩放图像的长、宽像素数，同时单片机也内置了四种缩放动画，包括线性缩放动画和三种非线性缩放动画展示我们作品的缩放流畅度。

![图形界面](https://github.com/Floatkyun/Ultra-Vision/blob/main/GUI/STM32_Keil_Project/img/界面.png) 

## 项目文件结构
本项目使用HAL库进行单片机应用开发，使用CubeMX图形化界面对单片机资源进行配置。

**MDK-ARM** 目录下为Arm Keil工程

**LVGL** 目录下为LVGL图形库和图形界面相关代码

**MY_APP** 目录下为该项目的主要控制逻辑代码

**RGBLCD** 目录下为触摸屏驱动代码


## 硬件信息
本工程使用了反客的STM32H743XIH6+7寸RGB触摸屏（480*800）的开发套件（反客淘宝店有售），选择该方案是因为官方提供的大屏幕、屏幕支架和磁吸设计非常适合演示且方便拆装，如果要复刻该项目，也推荐将代码移植到性价比更高的F4系列。

![反客H7](https://github.com/Floatkyun/Ultra-Vision/blob/main/GUI/STM32_Keil_Project/img/fanke_H743.png)  

本项目用到的单片机外设主要有以下几个，单片机选型时请注意兼容性：

**USART** 串口用于向FPGA传输缩放所使用的算法、算法所使用的权重参数、缩放大小等信息。

**FSMC** FSMC用于读写SDRAM，项目中将其作为大容量显存供LVGL渲染画面使用。

**LTDC** LTDC用于驱动RGB屏幕，请根据屏幕类型选择合适的驱动外设。

**TIMER** 该项目需要两个定时器外设，且对定时器位宽要求低，ST系列单片机均可满足要求。


## GUIguider工程和本工程的关系
该目录下的`\LVGL\generated`中的代码是由GUIguider工程中`generated`目录下的代码修改而来的，这些代码描述了GUI界面中各种控件及其事件回调。

## 为什么CubeMX的工程名叫Alpha-GoLite
该工程使用了本人的一个[将Alpha-Go移植到STM32的工程](https://github.com/Floatkyun/Alpha_Gobang_Lite_On_STM32)的基本软件框架，而该轻量化的强化学习模型的名字是Alpha-GoLite，CubeMX的工程名被继承下来了。


