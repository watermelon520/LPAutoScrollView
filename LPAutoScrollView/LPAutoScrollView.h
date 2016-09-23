//
//  LPAutoScrollView.h
//  LPAutoScrollView
//
//  Created by Allen on 16/7/19.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPAutoScrollView;
@class LPContentView;

typedef enum : NSUInteger {
    LPAutoScrollViewStyleVertical,
    LPAutoScrollViewStyleHorizontal,
} LPAutoScrollViewStyle;

@protocol LPAutoScrollViewDatasource <NSObject>

@required
- (NSUInteger)lp_numberOfNewsDataInScrollView:(nullable LPAutoScrollView *)scrollView;
- (void)lp_scrollView:(nullable LPAutoScrollView *)scrollView newsDataAtIndex:(NSUInteger)index forContentView:(nullable LPContentView *)contentView;

@end

@protocol LPAutoScrollViewDelegate <NSObject>

@optional
- (void)lp_scrollView:(nullable LPAutoScrollView *)scrollView didTappedContentViewAtIndex:(NSUInteger)index;
- (void)lp_scrollView:(nullable LPAutoScrollView *)scrollView didDidScrollToPage:(NSUInteger)page;

@end

@interface LPAutoScrollView : UIScrollView

@property (nonatomic, weak, nullable) IBOutlet id<LPAutoScrollViewDatasource> lp_scrollDataSource;
@property (nonatomic, weak, nullable) IBOutlet id<LPAutoScrollViewDelegate> lp_scrollDelegate;

/**
 *  防止轮播器在不显示的时候也滚动，可以在控制器的appear方法里更改这个属性
 */
@property (nonatomic, assign) IBInspectable BOOL lp_shouldAutoScroll;//是否自动轮播，默认YES
@property (nonatomic, assign) IBInspectable CGFloat lp_autoScrollInterval;//自动轮播时间间隔，默认5s,不得小于1s

@property (nonatomic, assign) IBInspectable BOOL lp_stopForSingleDataSourceCount; //数据源数组为1时是否关闭自动轮播

@property (nonatomic, assign, readonly) LPAutoScrollViewStyle lp_style; //默认竖直方向滚动

- (void)lp_registerNib:(nullable UINib *)contentNib;
- (void)lp_registerClass:(nullable Class)contentClass;

- (nullable instancetype)initWithStyle:(LPAutoScrollViewStyle)style;

/**
 *  当数据源改变时，刷新数据
 */
- (void)lp_reloadData;

@end
