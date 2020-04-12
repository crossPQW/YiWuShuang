//
//  CommonCell.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/12.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommonCell : UITableViewCell
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) CommonCellModel *model;
@end

NS_ASSUME_NONNULL_END
