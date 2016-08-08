//
//  LPImageContentView.m
//  LPAutoScrollViewExplame
//
//  Created by Allen on 16/7/20.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import "LPImageContentView.h"

@interface LPImageContentView ()

@end


@implementation LPImageContentView

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
    
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end
