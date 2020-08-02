//
//  ShareView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/8/2.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^tapBlock)(int type);
@interface ShareView : UIView
@property (nonatomic, copy) tapBlock block;
+ (instancetype)shareView;
@end

NS_ASSUME_NONNULL_END
