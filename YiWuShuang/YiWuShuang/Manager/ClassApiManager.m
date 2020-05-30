//
//  ClassApiManager.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/24.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassApiManager.h"
#import "NSDictionary+YYAdd.h"
#import "NSObject+YYModel.h"
#import "UserSession.h"
#import "YKAddition.h"

static NSString *getCourseID = @"/api/course/getCourseId";
static NSString *createClassUrl = @"/api/course/create";
static NSString *joinClassUrl = @"/api/course/addCourse";
static NSString *uploadUrl = @"/api/common/upload";


static NSString *debugHost = @"https://test.yiwushuang.cn";
static NSString *releaseHost = @"https://www.yiwushuang.cn";
@interface ClassApiManager()

@end
@implementation ClassApiManager
+ (instancetype)manager {
    static ClassApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ClassApiManager alloc] init];
    });
    return manager;
}
- (NSString *)getHost {
#ifdef DEBUG
    return debugHost;
#endif
    return releaseHost;
}

- (void)getClassIDSuccess:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure {
    [self requestWithApi:getCourseID params:nil success:success failure:failure];
}

- (void)creatClassWithID:(NSString *)classID name:(NSString *)className number:(NSString *)stuNumber ratio:(NSString *)ratio type:(int)type start_at:(NSString *)time isCamera:(BOOL)isCamera isMic:(BOOL)isMic isSmartMic:(BOOL)isSmartMic success:(void (^)(BaseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:classID forKey:@"unique_id"];
    [params yk_setValue:className forKey:@"name"];
    [params yk_setValue:stuNumber forKey:@"number"];
    [params yk_setValue:ratio forKey:@"ratio"];
    [params yk_setValue:@(type) forKey:@"type"];
    if (type == 2) {
        [params yk_setValue:time forKey:@"start_at"];
    }
    [params yk_setValue:@(isCamera) forKey:@"is_camera"];
    [params yk_setValue:@(isMic) forKey:@"is_make"];
    [params yk_setValue:@(isSmartMic) forKey:@"is_zhimai"];
    [self requestWithApi:createClassUrl params:params success:success failure:failure];
}

- (void)joinClassWithID:(NSString *)classID
                success:(void (^)(BaseModel *baseModel))success
                failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:classID forKey:@"unique_id"];
    [self requestWithApi:joinClassUrl params:params success:success failure:failure];
}
#pragma mark - basic
- (void)requestWithApi:(NSString *)api params:(NSDictionary *)params success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    NSString *host = releaseHost;
#ifdef DEBUG
    host = debugHost;
#endif
    NSString *url = [host stringByAppendingString:api];
    NSMutableDictionary *paramter = @{}.mutableCopy;
    [paramter yk_setValue:[UserSession session].currentUser.token forKey:@"token"];
    [paramter addEntriesFromDictionary:params];
    [httpManager POST:url parameters:paramter headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void)uploadWithParams:(NSDictionary *)params image:(UIImage *)img name:(NSString *)name fileName:(NSString *)fileName success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *host = releaseHost;
    #ifdef DEBUG
        host = debugHost;
    #endif
    NSString *url = [host stringByAppendingString:uploadUrl];
    NSMutableDictionary *paramter = @{}.mutableCopy;
    [paramter yk_setValue:[UserSession session].currentUser.token forKey:@"token"];
    [paramter addEntriesFromDictionary:params];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:url parameters:paramter headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
        [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@.jpeg",fileName] mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
