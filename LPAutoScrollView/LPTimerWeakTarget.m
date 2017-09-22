//
//  LPTimerWeakTarget.m
//  LPScrollView
//
//  Created by Allen on 16/7/12.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import "LPTimerWeakTarget.h"

@implementation LPTimerWeakTarget{
    
    __weak id _target;
    SEL _selector;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)sel{
    if (self = [super init]) {
        _target = target;
        _selector = sel;
    }
    return self;
}

- (void)timerDidFire:(NSTimer *)timer
{
    if(_target)
    {
        if ([_target respondsToSelector:_selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
            [_target performSelector:_selector withObject:timer];
#pragma clang diagnostic pop
            
        }
    }
    else
    {
        [timer invalidate];
    }
}

@end
