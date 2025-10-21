工程使用 Efinity 2023.2.307 进行开发以及烧录，同样可以使用更高版本的 Efinity，2024版本的 Efinity 修复了一下bug，可能会更好一些（maybe）。
硬件平台：Ti60F225核心板，底板V1.0，ADV7611 HDMI转LVDS模块。

打开Efinity->open project->选择工程文件Ti60_Demo.xml 以打开工程。

.v文件：
    顶层文件：1080@60/example_top.v
    功能模块：1080@60/src 中
    算法以及单片机控制模块： 1080@60/data_in_uart_control_new/rtl 中

bit流文件：
    1080@60/outflow 中（使用Efinity进行烧录）bicubic_32_small.bit 为最新验证可用的bit流文件。

.sdc文件：
    1080@60/Ti60_Demo.pt.sdc

    
（可能存在一些未使用的冗余文件）