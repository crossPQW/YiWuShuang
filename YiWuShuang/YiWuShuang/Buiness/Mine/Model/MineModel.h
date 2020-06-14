//
//  MineModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/5.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MineModel : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int tag;

- (MineModel *)initWithIcon:(NSString *)icon title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
