//
//  PersonalHomeController.h
//  DailyRanking
//
//  Created by ymy on 15/11/12.
//  Copyright © 2015年 com.xianlaohu.multipeer. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NavHeadTitleView : UIView
+ (instancetype)navView;

@property (nonatomic, copy) dispatch_block_t messageBlock;
@property (nonatomic, copy) dispatch_block_t settingBlock;
@end
