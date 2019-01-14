# GLKLineKit
这可能是目前性能最高的K线图之一👍

## 特点：
	1. 高性能，处理1k条数据内存占用20~30M
	2. 高扩展性，采用插入算法的方式扩展功能
		2.1 添加一个新的指标只需要编写一个算法类，添加到数组中就可以了
		2.2 可以像调整图层一样调整指标组合
## 预览：	

![竖屏预览](https://github.com/ghostlordstar/PicRepo/blob/master/DemoShowImg/kline/kline_Demo_portrait_git_001.gif?raw=true)
![横屏预览](https://github.com/ghostlordstar/PicRepo/blob/master/DemoShowImg/kline/kline_Demo_landscape_git_001.gif?raw=true)
## 备注：
	1.当前未完成(十字线和详情浮层实现比较乱，需要封装)
	2.框架结构未整理
	3.文档未整理
	4.数据为 bitCNY_ETH 的分钟数据，所以数据波动较小

## TODO:
- [x] 添加K线图充满模式
- [x] 对Demo进行精简，添加英文国际化
- [ ] 将指标和K线整合到一张View中，以解决跨界面捏合手势和时间显示重合问题
- [x] 优化捏合手势操作

# ChangeLog
>* 20190114_21:29:
	1.修改十字线横轴向下划超出显示区域的问题
	2.删除冗余文件
	3.修复七牛图床失效问题



##  ✊欢迎交流。欢迎提Issues和Star，也希望看到你们的Pull requests！

----
1. QQ群:901786039
<img src="https://github.com/ghostlordstar/PicRepo/blob/master/DemoShowImg/kline/kline_qqGroup_qrcode.jpeg?raw=true"  height="370" width="270">
