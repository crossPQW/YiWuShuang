//
//  TeamPickView.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/22.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TeamPickerViewDelegate <NSObject>

- (void)didSelectedTeamWithIndex:(NSInteger)index;
- (void)didDismiss;

@end
@interface TeamPickView : UIView
@property (nonatomic, weak) id<TeamPickerViewDelegate>delegate;
- (void)setData:(NSArray *)list;
@end

NS_ASSUME_NONNULL_END
