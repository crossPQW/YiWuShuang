//
//  ApiManager.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ApiManager.h"
#import "NSDictionary+YYAdd.h"
#import "NSObject+YYModel.h"
#import "UserSession.h"
#import "YKAddition.h"
static NSString *sendCodeUrl = @"http://yiwushuang.sabinetek.com.cn/api/sms/send";
static NSString *loginUrl = @"http://yiwushuang.sabinetek.com.cn/api/user/login";
static NSString *getOrigUrl = @"http://yiwushuang.sabinetek.com.cn/api/team/list";
static NSString *getOrizIDUrl = @"http://yiwushuang.sabinetek.com.cn/api/team/create";
static NSString *teamNatureListUrl = @"http://yiwushuang.sabinetek.com.cn/api/category/team";
static NSString *joinTeam = @"http://yiwushuang.sabinetek.com.cn/api/team/add";
@implementation ApiManager
+ (instancetype)manager {
    static ApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ApiManager alloc] init];
    });
    return manager;
}

- (void)sendMessageWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure; {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneNumber forKey:@"mobile"];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:sendCodeUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure {
    if (!phoneNumber || !code) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneNumber forKey:@"mobile"];
    [params setValue:code forKey:@"captcha"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:loginUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void) getOrganization:(NSString *)token success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure {
    if (token.length == 0) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:loginUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void) getNatureList:(NSString *)token
               success:(void (^)(BaseModel *baseModel))success
               failure:(void (^)(NSError *error))failure {
    if (token.length == 0) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:teamNatureListUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void) getOrganizationID:(NSString *)token
                   success:(void (^)(BaseModel *baseModel))success
                   failure:(void (^)(NSError *error))failure {
    if (token.length == 0) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    [params yk_setValue:@"base" forKey:@"event"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:getOrizIDUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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


- (void) fillOrganizationInfo:(NSString *)token
                       teamId:(NSString *)teamId
                        catId:(NSString *)catId
                      educate:(NSString *)educate
                      manager:(NSString *)manager
                         name:(NSString *)name
                      success:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure {
    if (token.length == 0) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    [params yk_setValue:@"info" forKey:@"event"];
    [params yk_setValue:teamId forKey:@"team_id"];
    [params yk_setValue:catId forKey:@"cat_id"];
    [params yk_setValue:educate forKey:@"educate"];
    [params yk_setValue:manager forKey:@"manager"];
    [params yk_setValue:name forKey:@"name"];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:getOrizIDUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void) joinTeam:(NSString *)token
           teamId:(NSString *)teamId
             name:(NSString *)name
          success:(void (^)(BaseModel *baseModel))success
          failure:(void (^)(NSError *error))failure {
    if (token.length == 0) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    [params yk_setValue:teamId forKey:@"team_id"];
    [params yk_setValue:name forKey:@"name"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:loginUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
