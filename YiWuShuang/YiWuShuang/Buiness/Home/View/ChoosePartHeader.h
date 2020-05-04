//
//  ChoosePartHeader.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/3.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChoosePartHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamName;
+ (instancetype)partHeader;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@end

NS_ASSUME_NONNULL_END
