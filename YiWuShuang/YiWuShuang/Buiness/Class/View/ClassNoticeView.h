//
//  ClassNoticeView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassNoticeView : UIView
+ (instancetype)noticeView;
@property (nonatomic, copy)dispatch_block_t block;
@end

NS_ASSUME_NONNULL_END
