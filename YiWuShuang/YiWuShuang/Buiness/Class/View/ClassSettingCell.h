//
//  ClassSettingCell.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickCellBlock)(ClassSettingModel *model);
@interface ClassSettingCell : UITableViewCell
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) ClassSettingModel *model;

@property (nonatomic, copy) ClickCellBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
