//
//  HomeBottomView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/3.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBottomView : UIView
+ (instancetype)bottomView;

@property (nonatomic, copy) dispatch_block_t deleteBlock;
@property (nonatomic, copy) dispatch_block_t moveBlock;
@end

NS_ASSUME_NONNULL_END
