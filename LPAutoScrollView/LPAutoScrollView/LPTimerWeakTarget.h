//
//  LPTimerWeakTarget.h
//  LPScrollView
//
//  Created by Allen on 16/7/12.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPTimerWeakTarget : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)sel;
- (void)timerDidFire:(NSTimer *)timer;

@end
