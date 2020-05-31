//
//  PersonCellTableViewCell.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonCellTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL hiddenCheckMark;
@property (nonatomic, strong) PersonModel *model;
@end

NS_ASSUME_NONNULL_END
