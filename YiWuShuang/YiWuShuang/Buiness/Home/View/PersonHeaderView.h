//
//  PersonHeaderView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(BOOL isHidden);
@interface PersonHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) Block block;

+ (instancetype)headerView;
@end

NS_ASSUME_NONNULL_END
