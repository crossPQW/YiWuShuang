//
//  UIScreen+Addition.m
//  Youku
//
//  Created by liusx on 12/25/14.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "UIScreen+Addition.h"

@implementation UIScreen (Addition)

//竖屏尺寸（不受当前屏幕转向影响）
- (CGRect)portraitBounds
{
    static CGRect bounds;
    if (CGRectIsEmpty(bounds)) {
        bounds = self.bounds;
        
        CGFloat width = bounds.size.width;
        CGFloat height = bounds.size.height;
        if (width > height) { //当前是横屏状态
            bounds.size.width = height;
            bounds.size.height = width;
        }
    }
    return bounds;
}

//屏幕分辨率
- (NSString *)resolution
{
    static NSString *resolution = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect bounds = [[UIScreen mainScreen] portraitBounds];
        CGFloat scale = [[UIScreen mainScreen] scale];
        resolution = [NSString stringWithFormat:@"%.f*%.f", bounds.size.height * scale, bounds.size.width * scale];
    });
    return resolution;
}

@end
