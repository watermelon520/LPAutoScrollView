//
//  LPAutoScrollView.m
//  LPAutoScrollView
//
//  Created by Allen on 16/7/19.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import "LPAutoScrollView.h"

#import "LPTimerWeakTarget.h"
#import "LPContentView.h"

@interface LPAutoScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) LPContentView *contentView1;
@property (nonatomic, weak) LPContentView *contentView2;
@property (nonatomic, weak) LPContentView *contentView3;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, assign) NSUInteger totalPages;

@property (nonatomic, assign, getter=isAppear) BOOL appear;

@property (nonatomic, assign) Class contentClass;
@property (nonatomic, strong) UINib *contentNib;

@end

@implementation LPAutoScrollView {
    CGRect _lastFrame;
    BOOL _isDead;
}

#pragma mark- life cycle

- (instancetype)initWithStyle:(LPAutoScrollViewStyle)style {
    if (self = [super init]) {
        _lp_style = style;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    
    _lp_shouldAutoScroll   = YES;
    _lp_autoScrollInterval = 5.0;
    _totalPages      = 0;
    _lp_style = LPAutoScrollViewStyleVertical;
    
    self.delegate = self;
}

- (void)setUpContentView {
    
    LPContentView *contentView1 = nil;
    LPContentView *contentView2 = nil;
    LPContentView *contentView3 = nil;
    
    if (self.contentNib) {
        
        contentView1 = [self.contentNib instantiateWithOwner:nil options:nil].firstObject;
        contentView2 = [self.contentNib instantiateWithOwner:nil options:nil].firstObject;
        contentView3 = [self.contentNib instantiateWithOwner:nil options:nil].firstObject;
        
    } else if (self.contentClass) {
        
        contentView1 = [[self.contentClass alloc] init];
        contentView2 = [[self.contentClass alloc] init];
        contentView3 = [[self.contentClass alloc] init];
        
    }
    
    [self addSubview:contentView1];
    [self addSubview:contentView2];
    [self addSubview:contentView3];
    
    self.contentView1 = contentView1;
    self.contentView2 = contentView2;
    self.contentView3 = contentView3;
    
    self.contentView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lp_viewTapped:)];
    [self.contentView2 addGestureRecognizer:tapGesture];
    
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    self.appear = YES;
    
    if ([self.lp_scrollDataSource lp_numberOfNewsDataInScrollView:self]) {
        
        [self dealAutoScrollTimer];
    }
}

- (void)layoutSubviews {
    
    if (!CGRectEqualToRect(self.frame, _lastFrame)) {
        
        if (self.lp_style == LPAutoScrollViewStyleVertical) {
            
            self.contentOffset = CGPointMake(0, self.bounds.size.height);
            
            [self reloadNewsData];
            
            self.contentView1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.contentView2.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
            self.contentView3.frame = CGRectMake(0, self.bounds.size.height * 2, self.bounds.size.width, self.bounds.size.height);
            self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height * 3);
            
        } else if (self.lp_style == LPAutoScrollViewStyleHorizontal) {
            
            self.contentOffset = CGPointMake(self.bounds.size.width, 0);
            
            [self reloadNewsData];
            
            self.contentView1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.contentView2.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
            self.contentView3.frame = CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height);
            self.contentSize = CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
            
        }
        
        _lastFrame = self.frame;
        
    }
    
    [super layoutSubviews];
}

- (void)dealloc {
    _isDead = YES;
    [self.autoScrollTimer invalidate];
}


#pragma mark- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.autoScrollTimer invalidate];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self dealAutoScrollTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //计算当前实际应该显示第几页的view
    CGFloat offsetY = self.contentOffset.y;
    CGFloat offsetX = self.contentOffset.x;
    NSInteger page;
    
    CGPoint offsetPoint = CGPointZero;
    
    if (self.lp_style == LPAutoScrollViewStyleVertical) {
        
        offsetPoint = CGPointMake(0, self.bounds.size.height);
        page = (offsetY / CGRectGetHeight(self.frame) + 0.5);
        
    } else if (self.lp_style == LPAutoScrollViewStyleHorizontal) {
        
        offsetPoint = CGPointMake(self.bounds.size.width, 0);
        page = (offsetX / CGRectGetWidth(self.frame) + 0.5);
    }
    
    if (page == 0) {
        //向左
        self.currentPage = _currentPage == 0 ? (self.totalPages - 1) : _currentPage - 1;
    }else if (page == 2){
        //向右
        self.currentPage = _currentPage == (self.totalPages - 1) ? 0 : _currentPage + 1;
    }
    
    [self reloadNewsData];
    
    //将content offset设为第二页的偏移量，即，展示的永远是scrollview中第二页的偏移位置的图片
    self.contentOffset = offsetPoint;
    
}

- (void)setUpAutoScrollTimer {
    
    if (!_autoScrollTimer.isValid) {
        
        LPTimerWeakTarget *target = [[LPTimerWeakTarget alloc] initWithTarget:self selector:@selector(autoScrollTimerFired:)];
        _autoScrollTimer = [NSTimer timerWithTimeInterval:self.lp_autoScrollInterval
                                                   target:target
                                                 selector:@selector(timerDidFire:)
                                                 userInfo:nil
                                                  repeats:YES
                            ];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)autoScrollTimerFired:(NSTimer *)timer {
    
    CGPoint offsetPoint = CGPointZero;
    
    if (self.lp_style == LPAutoScrollViewStyleVertical) {
        
        offsetPoint = CGPointMake(0, 2 * self.bounds.size.height);
        
    } else if (self.lp_style == LPAutoScrollViewStyleHorizontal) {
        
        offsetPoint = CGPointMake(2 * self.bounds.size.width, 0);
    }
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.contentOffset = offsetPoint;
                     }
                     completion:^(BOOL finished) {
                         [self scrollViewDidEndDecelerating:self];
                     }];
}

#pragma mark- public method

- (void)lp_reloadData {
    
    NSUInteger count = [self.lp_scrollDataSource lp_numberOfNewsDataInScrollView:self];
    self.totalPages = count;
    if (_currentPage > count - 1) {
        _currentPage = count - 1;
    }
    
    if (count && self.isAppear) {
        
        [self dealAutoScrollTimer];
    }
    
    [self reloadNewsData];
    
}

- (void)lp_registerNib:(nullable UINib *)contentNib {
    
    self.contentNib = contentNib;
    self.contentClass = nil;
    
    [self checkContentClass:[[contentNib instantiateWithOwner:nil options:nil].firstObject class]];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self setUpContentView];
}

- (void)lp_registerClass:(nullable Class)contentClass {
    
    self.contentClass = contentClass;
    self.contentNib = nil;
    
    [self checkContentClass:contentClass];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self setUpContentView];
}

#pragma mark- private method

- (void)checkContentClass:(Class)contentClass {
    
    if (![contentClass isSubclassOfClass:[LPContentView class]] ) {
        
        NSException *e = [NSException
                          exceptionWithName: [NSString stringWithFormat:@"%s %@ not fount", __func__, contentClass]
                          reason: @"lp_contentViewClass 不是 LPContentView 的子类,请继承 LPContentView"
                          userInfo: nil];
        @throw e;
        
    }
}

- (void)reloadNewsData {
    
    if (!self.totalPages) return;
    
    [self.lp_scrollDataSource lp_scrollView:self newsDataAtIndex:_currentPage forContentView:self.contentView2];
    [self.lp_scrollDataSource lp_scrollView:self newsDataAtIndex:_currentPage == (self.totalPages - 1) ? 0 : _currentPage + 1 forContentView:self.contentView3];
    [self.lp_scrollDataSource lp_scrollView:self newsDataAtIndex:_currentPage == 0 ? (self.totalPages - 1) : _currentPage - 1 forContentView:self.contentView1];
    
    if ([self.lp_scrollDelegate respondsToSelector:@selector(lp_scrollView:didDidScrollToPage:)]) {
        [self.lp_scrollDelegate lp_scrollView:self didDidScrollToPage:self.currentPage];
    }
}

- (void)dealAutoScrollTimer {
    
    [self.autoScrollTimer invalidate];
    
    if (self.lp_shouldAutoScroll) {
        
        if (!self.totalPages) return;
        if (self.lp_stopForSingleDataSourceCount && self.totalPages == 1) return;
        
        [self setUpAutoScrollTimer];
    }
    
}

#pragma mark- Actions & Events

- (void)lp_viewTapped:(UITapGestureRecognizer *)gesture {
    
    if (!self.totalPages) return;
    
    if ([self.lp_scrollDelegate respondsToSelector:@selector(lp_scrollView:didTappedContentViewAtIndex:)]){
        [self.lp_scrollDelegate lp_scrollView:self didTappedContentViewAtIndex:self.currentPage];
    }
}

#pragma mark- getters & setters

- (void)setLp_shouldAutoScroll:(BOOL)lp_shouldAutoScroll {
    _lp_shouldAutoScroll = lp_shouldAutoScroll;
    
    [self dealAutoScrollTimer];
}

- (void)setLp_autoScrollInterval:(CGFloat)lp_autoScrollInterval {
    _lp_autoScrollInterval = lp_autoScrollInterval > 1 ? lp_autoScrollInterval : 1.0;
}

- (void)setLp_scrollDataSource:(id<LPAutoScrollViewDatasource>)lp_scrollDataSource {
    _lp_scrollDataSource = lp_scrollDataSource;
    [self lp_reloadData];
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    if (!_isDead) {
        [super setDelegate:self];
    }
}

@end
