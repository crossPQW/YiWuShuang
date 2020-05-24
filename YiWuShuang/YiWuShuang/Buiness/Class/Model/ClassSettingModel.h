//
//  ClassSettingModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ClassSettingModelStyle) {
    ClassSettingModelStyleNotice,
    ClassSettingModelStyleSpace,
    ClassSettingModelStyleLine,
    ClassSettingModelTitle,
    ClassSettingModelSelect,
    ClassSettingModelSwitch,
    ClassSettingModelButton,
    ClassSettingModelCopy,
    ClassSettingModelJoin,
};

@interface ClassSettingModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) ClassSettingModelStyle style;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) NSString *btnImg;
@property (nonatomic, assign) BOOL switchOn;
@end

NS_ASSUME_NONNULL_END
