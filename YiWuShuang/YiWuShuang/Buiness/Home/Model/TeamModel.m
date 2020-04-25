//
//  TeamModel.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import "TeamModel.h"

@implementation TeamModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"ID":@"id",
        @"managerID":@"manager_id",
    };
}
@end
