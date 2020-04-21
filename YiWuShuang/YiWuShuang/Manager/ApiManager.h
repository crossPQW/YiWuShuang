//
//  ApiManager.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApiManager : NSObject
+ (instancetype)manager;


//获取验证码
- (void)sendMessageWithPhoneNumber:(NSString *)phoneNumber
                           success:(void (^)(BaseModel *baseModel))success
                           failure:(void (^)(NSError *error))failure;

//登录
- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                        code:(NSString *)code
                     success:(void (^)(BaseModel *baseModel))success
                     failure:(void (^)(NSError *error))failure;

//获取组织列表
- (void) getOrganization:(NSString *)token
                 success:(void (^)(BaseModel *baseModel))success
                 failure:(void (^)(NSError *error))failure;

//组织性质列表
- (void) getNatureList:(NSString *)token
               success:(void (^)(BaseModel *baseModel))success
               failure:(void (^)(NSError *error))failure;


//生成组织 ID
- (void) getOrganizationID:(NSString *)token
                   success:(void (^)(BaseModel *baseModel))success
                   failure:(void (^)(NSError *error))failure;

//创建组织
- (void) fillOrganizationInfo:(NSString *)token
                        teamId:(NSString *)teamId
                        catId:(NSString *)catId
                      educate:(NSString *)educate
                      manager:(NSString *)manager
                         name:(NSString *)name
                      success:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure;

//加入组织
- (void) joinTeam:(NSString *)token
           teamId:(NSString *)teamId
             name:(NSString *)name
          success:(void (^)(BaseModel *baseModel))success
          failure:(void (^)(NSError *error))failure;

//成员列表
- (void) memberList:(NSString *)teamId
            success:(void (^)(BaseModel *baseModel))success
            failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
