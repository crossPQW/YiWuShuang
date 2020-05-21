//
//  ClassTopView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/16.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassTopView : UIView
+(instancetype)topView;

@property (nonatomic, copy) dispatch_block_t tapMessageBlock;
@property (nonatomic, copy) dispatch_block_t tapAddPersonBlock;
@property (nonatomic, copy) dispatch_block_t tapStartClassBlock;
@property (nonatomic, copy) dispatch_block_t tapJoinClassBlock;
@property (nonatomic, copy) dispatch_block_t tapOrderClassBlock;
@end

NS_ASSUME_NONNULL_END
