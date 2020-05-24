//
//  GradientButton.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/24.
//  Copyright © 2020 huang. All rights reserved.
//

#import "GradientButton.h"

@interface GradientButton()
@property (nonatomic, strong) CAGradientLayer *bgLayer;
@end
@implementation GradientButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self.layer insertSublayer:self.bgLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgLayer.frame = self.bounds;
}

- (CAGradientLayer *)bgLayer {
    if (!_bgLayer) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:239/255.0 blue:162/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:20/255.0 green:193/255.0 blue:215/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        _bgLayer = gl;
    }
    return _bgLayer;
}
@end
