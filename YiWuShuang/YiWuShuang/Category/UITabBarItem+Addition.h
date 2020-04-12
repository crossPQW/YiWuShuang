//
//  UITabBarItem+Addition.h
//  YoukuCore
//
//  Created by liusx on 2016/12/30.
//  Copyright © 2016 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (Addition)

@property (nonatomic, strong) NSString *identifier;

///用于判断首页是否在显示刷新图标（埋点参数需求）
@property (nonatomic, getter=isShowingRefreshImage) BOOL showingRefreshImage;

@end
