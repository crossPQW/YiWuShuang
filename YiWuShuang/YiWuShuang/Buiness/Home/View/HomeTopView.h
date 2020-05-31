//
//  HomeTopView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTopView : UIView
@property (strong, nonatomic)  UIButton *managericon;
- (void)fillData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
