//
//  ViewController.m
//  LPAutoScrollView
//
//  Created by Allen on 16/7/19.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import "ViewController.h"

#import "LPAutoScrollView.h"
#import "LPView.h"
#import "LPImageContentView.h"

@interface ViewController () <LPAutoScrollViewDatasource, LPAutoScrollViewDelegate>

@property (nonatomic, weak) LPAutoScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titlesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = [NSMutableArray array];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 3; i ++) {
            
            [self.titlesArray addObject:[NSString stringWithFormat:@"%d + avbdsgsdg", i]];
            
        }
        
        /**
         *  切记，数据源变化后记得调用 reload
         */
        [self.scrollView lp_reloadData];
        
    });
    
    /**
     *   此处更改滚动模式
     *   LPAutoScrollViewStyleHorizontal  水平
     *   LPAutoScrollViewStyleVertical    竖直
     *
     */

    LPAutoScrollView *scrollView = [[LPAutoScrollView alloc] initWithStyle:LPAutoScrollViewStyleHorizontal];
    
    //代理和数据源
    scrollView.lp_scrollDataSource = self;
    scrollView.lp_scrollDelegate = self;
    
    //数据数组为1时是否关闭滚动
    scrollView.lp_stopForSingleDataSourceCount = YES;
    
    //滚动市场
    scrollView.lp_autoScrollInterval = 1;
    
    
    //
    /**
     *  注册内容view
     *
     *  自定义view请继承 LPContentView
     *
     *  纯代码和xib随意切换
     */
//    [scrollView lp_registerNib:[UINib nibWithNibName:NSStringFromClass([LPView class]) bundle:nil]];
    [scrollView lp_registerClass:[LPView class]];
    
    
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    scrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, 300);
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    self.scrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, 300);
}

#pragma mark - LPAutoScrollViewDatasource

- (NSUInteger)lp_numberOfNewsDataInScrollView:(LPAutoScrollView *)scrollView {
    return self.titlesArray.count;
}

/**
 *
 *  @param contentView 更改为你自己创建的view类型，使用模型赋值，类似UITableView
 */
- (void)lp_scrollView:(LPAutoScrollView *)scrollView newsDataAtIndex:(NSUInteger)index forContentView:(LPView *)contentView {
    contentView.title = self.titlesArray[index];
}

#pragma mark LPAutoScrollViewDelegate

- (void)lp_scrollView:(LPAutoScrollView *)scrollView didTappedContentViewAtIndex:(NSUInteger)index {
    NSLog(@"%@", self.titlesArray[index]);
}

@end
