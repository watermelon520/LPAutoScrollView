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
        [self.scrollView lp_reloadData];
        
    });
    
    LPAutoScrollView *scrollView = [[LPAutoScrollView alloc] initWithStyle:LPAutoScrollViewStyleHorizontal];
    
    scrollView.lp_scrollDataSource = self;
    scrollView.lp_scrollDelegate = self;
    scrollView.lp_stopForSingleDataSourceCount = YES;
    scrollView.lp_autoScrollInterval = 1;
    
    // 纯代码和xib随意切换
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

- (NSUInteger)lp_numberOfNewsDataInScrollView:(LPAutoScrollView *)scrollView {
    return self.titlesArray.count;
}

- (void)lp_scrollView:(LPAutoScrollView *)scrollView newsDataAtIndex:(NSUInteger)index forContentView:(LPView *)contentView {
    contentView.title = self.titlesArray[index];
}

- (void)lp_scrollView:(LPAutoScrollView *)scrollView didTappedContentViewAtIndex:(NSUInteger)index {
    NSLog(@"%@", self.titlesArray[index]);
}

@end
