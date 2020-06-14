//
//  NormalMineHeader.h
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NormalMineHeader : UIView
+ (instancetype)headerView;

@property (nonatomic, copy) dispatch_block_t requestPartnerBlock;
@property (nonatomic, copy) dispatch_block_t clickTrafficBlock;
@end

NS_ASSUME_NONNULL_END
