//
//  UIScreen+Addition.h
//  Youku
//
//  Created by liusx on 12/25/14.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Addition)

///竖屏尺寸（不受当前屏幕转向影响）
- (CGRect)portraitBounds;

///屏幕分辨率。高*宽。
- (NSString *)resolution;

@end
