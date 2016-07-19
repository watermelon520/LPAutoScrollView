//
//  LPView.m
//  LPScrollView
//
//  Created by Allen on 16/7/12.
//  Copyright © 2016年 watermelon_lp. All rights reserved.
//

#import "LPView.h"

@interface LPView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation LPView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    label.backgroundColor = [UIColor redColor];
    _titleLabel = label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.label.text = title;
    self.titleLabel.text = title;
}

@end
