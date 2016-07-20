//
//  LPImageContentView.m
//  LPAutoScrollViewExplame
//
//  Created by Allen on 16/7/20.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import "LPImageContentView.h"

@interface LPImageContentView ()

@property (nonatomic, weak) UIImageView *imageView;

@end


@implementation LPImageContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (image) {
        self.imageView.image = image;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end
