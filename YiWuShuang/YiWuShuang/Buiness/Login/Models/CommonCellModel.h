//
//  CommonCellModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/12.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CellStyle) {
    CellStyleSpace,
    CellStyleLine,
    CellStyleInput,
    CellStyleSelectView,
    CellStyleOriz,
};

@interface CommonCellModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CellStyle style;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) int tag;
@end

NS_ASSUME_NONNULL_END
