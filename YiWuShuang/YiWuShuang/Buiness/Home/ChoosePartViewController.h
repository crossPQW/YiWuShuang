//
//  ChoosePartViewController.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/3.
//  Copyright © 2020 huang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChoosePartViewController : BaseViewController
@property (nonatomic, strong) NSString *teamName;//组织名字
@property (nonatomic, strong) NSString *teamID;//组织ID
@property (nonatomic, strong) NSString *partID;//部门 ID
@property (nonatomic, strong) NSArray *ids;
@end

NS_ASSUME_NONNULL_END

