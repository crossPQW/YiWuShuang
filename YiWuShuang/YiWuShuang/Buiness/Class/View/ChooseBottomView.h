//
//  ChooseBottomView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/31.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ChooseBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, copy) dispatch_block_t block;

+ (instancetype)bottomView;
@end

NS_ASSUME_NONNULL_END
