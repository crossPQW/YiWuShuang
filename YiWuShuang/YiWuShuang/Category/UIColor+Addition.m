//
//  UIColor+Addition.m
//  Youku
//
//  Created by liusx on 12/10/14.
//  Copyright (c) 2014 Youku.com inc. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

//由16进制字符串获取颜色，支持RGB和ARGB格式
+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString
{
    NSString *formatString = [hexRGBString hasPrefix:@"#"] ? [hexRGBString substringFromIndex:1] : hexRGBString;
    if (formatString.length == 6 || formatString.length == 8) {
        unsigned int colorCode = 0;
        unsigned char redByte, greenByte, blueByte, alphaByte;
        
        NSScanner *scanner = [NSScanner scannerWithString:formatString];
        [scanner scanHexInt:&colorCode];
        
        if (formatString.length == 6) { //RGB
            alphaByte = 0xff;
        } else { //ARGB
            alphaByte = (unsigned char) (colorCode >> 24);
        }
        redByte     = (unsigned char) (colorCode >> 16);
        greenByte   = (unsigned char) (colorCode >> 8);
        blueByte    = (unsigned char) (colorCode);
        
        return [UIColor colorWithRed:(float)redByte/0xff green:(float)greenByte/0xff blue:(float)blueByte/0xff alpha:(float)alphaByte/0xff];
    }
    return [UIColor clearColor];
}

//常用蓝色
+ (UIColor *)ykBlueColor
{
    return [self colorWithRed:0.15 green:0.57 blue:1.0 alpha:1.0]; //RGB(38, 146, 255)
}

//常用副标题灰色
+ (UIColor *)ykSubtitleColor
{
    return [self colorWithWhite:0.71 alpha:1.0];
}

@end
