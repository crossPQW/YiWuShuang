//
//  UIColor+Addition.h
//  Youku
//
//  Created by liusx on 12/10/14.
//  Copyright (c) 2014 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

///由16进制字符串获取颜色
+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString;

///常用蓝色RGB(38, 146, 255)
+ (UIColor *)ykBlueColor;
///常用副标题灰色
+ (UIColor *)ykSubtitleColor;

@end
