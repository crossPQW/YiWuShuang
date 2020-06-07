//
//  PersonModel.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"teamID":@"team_id",
        @"partID":@"part_id",
        @"userID":@"user_id",
        @"friendId":@"id",
    };
}
@end
