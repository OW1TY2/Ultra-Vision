工程使用 Efinity 2023.2.307 进行开发以及烧录，同样可以使用更高版本的 Efinity，2024版本的 Efinity 修复了一下bug，可能会更好一些（maybe）。
硬件平台：Ti60F225核心板，底板V1.0，ADV7611 HDMI转LVDS模块。

打开Efinity->open project->选择工程文件Ti60_Demo.xml 以打开工程。

.v文件：
    顶层文件：2k@50+/example_top.v
    功能模块：2k@50+/src 中
    算法以及单片机控制模块： 2k@50+/data_in_uart_control_new/rtl 中

bit流文件：
    2k@50+/outflow 中（使用Efinity进行烧录）帧率打头+lw/better的基本为验证可用的bit流文件。

.sdc文件：
    2k@50+/Ti60_Demo.pt.sdc

本工程由异步FIFO作为输出缓冲模块，FIFO持续输出。控制逻辑为当FIFO数据量小于一定值时，控制DDR向插值算法输入数据，经过插值后，输出数据到FIFO中。故其受输出分辨率与帧率控制，可调整范围较大。调整HDMI输出时钟时，需要一并调整FIFO输入时钟与DDR输出时钟。
为了使FIFO不至于空或满，DDR读时钟、FIFO写时钟、FIFO读时钟、FIFO阈值数据量、行放大倍数、列放大倍数之间有相互约束关系，追求高帧率、高分辨率输出时需仔细调整。
##寒假有空时补充详细调整说明

（可能存在一些未使用的冗余文件）