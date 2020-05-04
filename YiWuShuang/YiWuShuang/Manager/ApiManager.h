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

- (NSString *)getHost;

#pragma mark - 登录
//获取验证码
- (void)sendMessageWithPhoneNumber:(NSString *)phoneNumber
                           success:(void (^)(BaseModel *baseModel))success
                           failure:(void (^)(NSError *error))failure;

//检查 token
- (void)checkTokenSuccess:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure;
//刷新 token
- (void)refreshTokenSuccess:(void (^)(BaseModel *baseModel))success
                    failure:(void (^)(NSError *error))failure;

//登录
- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                        code:(NSString *)code
                     success:(void (^)(BaseModel *baseModel))success
                     failure:(void (^)(NSError *error))failure;

#pragma mark - 组织相关
//获取组织列表
- (void) getOrganization:(NSString *)token
                 success:(void (^)(BaseModel *baseModel))success
                 failure:(void (^)(NSError *error))failure;
//获取部门列表
- (void) getPartsWithTeamID:(NSString *)teamID
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

//创建部门
- (void) createPartWithTeamID:(NSString *)teamID
                     teamName:(NSString *)teamName
                    managerID:(NSString *)managerID
                      success:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark - 成员相关
//成员列表
- (void) memberList:(NSString *)teamId
            success:(void (^)(BaseModel *baseModel))success
            failure:(void (^)(NSError *error))failure;

//添加学员、成员，type 1=成员。2=学员
- (void) addMemberWithTeamId:(NSString *)teamId
                      partId:(NSString *)part_id
                        name:(NSString *)name
                      mobild:(NSString *)mobile
                        type:(NSString *)type
                   isManager:(BOOL)isManager
            success:(void (^)(BaseModel *baseModel))success
            failure:(void (^)(NSError *error))failure;

//删除成员
- (void) deleteMembersWithIDs:(NSArray *)ids
                       teamId:(NSString *)teamId
                      success:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure;

//type 1 成员 2 学员
- (void) moveMemberWithIDs :(NSArray *)ids
                 fromTeamID:(NSString *)fromTeamID
                 fromPartID:(NSString *)fromPartID
                   fromType:(NSString *)fromType
                   toTeamID:(NSString *)toTeamID
                   toPartID:(NSString *)toPartID
                     toType:(NSString *)toType
                    success:(void (^)(BaseModel *baseModel))success
                    failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
