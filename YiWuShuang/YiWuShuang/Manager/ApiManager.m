//
//  ApiManager.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ApiManager.h"
#import "NSDictionary+YYAdd.h"

@implementation ApiManager
+ (instancetype)manager {
    static ApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ApiManager alloc] init];
    });
    return manager;
}

- (void)sendMessageSuccess:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure {
    NSString *urlString = @"http://www.yws.com/api/sms/send";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"18511115346" forKey:@"mobile"];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModel *model = [[BaseModel alloc] initWithDictionary:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
