//
//  MineModel.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/5.
//  Copyright © 2020 huang. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel
- (MineModel *)initWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle {
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}
@end
