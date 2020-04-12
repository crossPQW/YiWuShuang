//
//  UITabBarItem+Addition.m
//  YoukuCore
//
//  Created by liusx on 2016/12/30.
//  Copyright © 2016 Youku.com inc. All rights reserved.
//

#import "UITabBarItem+Addition.h"
#import <objc/runtime.h>

static const void *kPropIdentifier = "Identifier";
static const void *kShowingRefreshImage = "ShowingRefreshImage";

@implementation UITabBarItem (Addition)

- (NSString *)identifier
{
    return objc_getAssociatedObject(self, kPropIdentifier);
}

- (void)setIdentifier:(NSString *)identifier
{
    objc_setAssociatedObject(self, kPropIdentifier, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowingRefreshImage
{
    return [objc_getAssociatedObject(self, kShowingRefreshImage) boolValue];
}

- (void)setShowingRefreshImage:(BOOL)showingRefreshIcon
{
    objc_setAssociatedObject(self, kShowingRefreshImage, @(showingRefreshIcon), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
