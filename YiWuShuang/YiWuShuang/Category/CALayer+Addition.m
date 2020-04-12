//
//  CALayer+Addition.m
//  Youku
//
//  Created by 光 李 on 4/17/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "CALayer+Addition.h"
#import <UIKit/UIScreen.h>
@implementation CALayer (Addition)
- (void)autoSetContentsScale {
    if ([self respondsToSelector:@selector(contentsScale)]) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
}
@end
