//
//  PersonHeaderView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/6/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonHeaderView : UIView
+ (instancetype)headerView;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@end

NS_ASSUME_NONNULL_END
