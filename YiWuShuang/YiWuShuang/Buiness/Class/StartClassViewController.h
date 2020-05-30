//
//  StartClassViewController.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/16.
//  Copyright © 2020 huang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StartClassViewController : BaseViewController

//NO 发起课程页面， YES 预约课程页面
@property (nonatomic, assign) BOOL isOrder;
@end

NS_ASSUME_NONNULL_END
