//
//  ClassApiManager.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/24.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassApiManager : NSObject
+ (instancetype)manager;
//获取课程 ID
- (void)getClassIDSuccess:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure;

//创建课程， type 1.开始上课，2.预约上课
- (void)creatClassWithID:(NSString *)classID
                    name:(NSString *)className
                  number:(NSString *)stuNumber
                   ratio:(NSString *)ratio
                    type:(int) type
                playType:(int) playType
                start_at:(NSString *)time
                isCamera:(BOOL)isCamera
                   isMic:(BOOL)isMic
              isSmartMic:(BOOL)isSmartMic
                 success:(void (^)(BaseModel *baseModel))success
                 failure:(void (^)(NSError *error))failure;

//加入课程
- (void)joinClassWithID:(NSString *)classID
                success:(void (^)(BaseModel *baseModel))success
                failure:(void (^)(NSError *error))failure;

//上传图片
- (void)uploadWithParams:(NSDictionary *)params
                   image:(UIImage *)img
                    name:(NSString *)name
                fileName:(NSString *)fileName
                 success:(void (^)(BaseModel *baseModel))success
                 failure:(void (^)(NSError *error))failure;

//获取好友列表
- (void)getFriendsSuccess:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure;


//是否上传通讯录
- (void)checkContactStatusSuccess:(void (^)(BaseModel *baseModel))success
                          failure:(void (^)(NSError *error))failure;

//获取通讯录列表
- (void)getContactListSuccess:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure;

//添加好友
- (void)addFriendWithContactID:(NSString *)ID
                       success:(void (^)(BaseModel *baseModel))success
                       failure:(void (^)(NSError *error))failure;

//好友详情页
- (void)getFriendDetailWithID:(NSString *)ID
                       success:(void (^)(BaseModel *baseModel))success
                       failure:(void (^)(NSError *error))failure;

//删除好友
- (void)deleteFriendWithID:(NSString *)ID
                   success:(void (^)(BaseModel *baseModel))success
                   failure:(void (^)(NSError *error))failure;

//给好友设置备注
- (void)setNoteWithFriendID:(NSString *)ID
                       note:(NSString *)note
                    success:(void (^)(BaseModel *baseModel))success
                    failure:(void (^)(NSError *error))failure;

//搜索联系人
- (void) searchContactWithMobile:(NSString *)mobile
                         success:(void (^)(BaseModel *baseModel))success
                         failure:(void (^)(NSError *error))failure;

//搜索好友
- (void) searchFriendsWithkeyword:(NSString *)keyword
                         success:(void (^)(BaseModel *baseModel))success
                         failure:(void (^)(NSError *error))failure;

//意见反馈
- (void) feedbackWithText:(NSString *)text
                  success:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure;

//项目各种文案
//1：登录页文案，2：充值说明，3：关于我们 ，4：常见问题，5：邀请规则，6：合伙人说明，7：提现规则
- (void)getTextWithType:(NSString *)type
                success:(void (^)(BaseModel *baseModel))success
                failure:(void (^)(NSError *error))failure;
#pragma mark - 上传通讯录
//上传通讯录
- (void)uploadContact;
@end

NS_ASSUME_NONNULL_END
