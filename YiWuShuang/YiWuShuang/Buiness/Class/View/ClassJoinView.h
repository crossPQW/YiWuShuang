//
//  ClassJoinView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JoinBlock)(NSString *classID);
@interface ClassJoinView : UIView
@property (nonatomic, copy) JoinBlock block;
+ (instancetype)joinView;
@end

NS_ASSUME_NONNULL_END
