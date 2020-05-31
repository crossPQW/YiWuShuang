//
//  EmptyView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyView : UIView
+ (instancetype)emptyView;

@property (nonatomic, copy) dispatch_block_t block;
@end

NS_ASSUME_NONNULL_END
