//
//  InvateView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/31.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvateView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) dispatch_block_t block;
+ (instancetype)invateView;
@end

NS_ASSUME_NONNULL_END
