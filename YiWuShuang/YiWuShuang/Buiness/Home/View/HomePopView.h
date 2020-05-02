//
//  HomePopView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/2.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePopView : UIView
@property (nonatomic, copy)dispatch_block_t addMemberBlock;
@property (nonatomic, copy)dispatch_block_t addStudentBlock;
@property (nonatomic, copy)dispatch_block_t addTeamBlock;
@property (nonatomic, copy)dispatch_block_t addOrigBlock;
@property (nonatomic, copy)dispatch_block_t joinOrigBlock;
+ (instancetype)popView;

@end

NS_ASSUME_NONNULL_END
