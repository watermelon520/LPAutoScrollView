# LPAutoScrollView

极简的自定义自动无限轮播框架

### 使用方法

* 直接下载压缩包，将LPAutoScrollView导入你的项目，`#import "LPAutoScrollView.h"`
* 使用cocoapods `pod 'LPAutoScrollView'`

### 特色

* 支持竖直以及水平自动轮播
* 没有侵入性，使用自定义的view
* 自定的view支持纯代码或者xib
* 采用类似UITableView的方式构建框架
* view重用机制的无限轮播，性能优异
* 使用简易

### 使用注意事项

* 自定义view请继承 LPContentView，并且向LPAutoScrollView注册。
* 使用代理方法赋值，在`- (void)lp_scrollView:(LPAutoScrollView *)scrollView newsDataAtIndex:(NSUInteger)index forContentView:(LPContentView *)contentView` 方法中，请自行更换LPContentView 为你自定义的view，然后模型赋值。
* 两种滚动模式，默认竖直 `LPAutoScrollViewStyleVertical,`

  `LPAutoScrollViewStyleHorizontal,`


