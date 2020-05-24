//
//  RealAuthView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/24.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RealAuthView : UIView
+ (instancetype)authView;
@property (nonatomic, copy)dispatch_block_t block;
@end

NS_ASSUME_NONNULL_END
