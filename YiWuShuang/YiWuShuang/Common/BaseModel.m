//
//  BaseModel.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        self.code = [[dict objectForKey:@"code"] intValue];
        self.msg = [dict objectForKey:@"msg"];
        self.time = [[dict objectForKey:@"code"] intValue];
        id data = [dict objectForKey:@"data"];
        if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSString class]]) {
            self.data = data;
        }else {
            self.data = nil;
        }
    }
    return self;
}
@end
