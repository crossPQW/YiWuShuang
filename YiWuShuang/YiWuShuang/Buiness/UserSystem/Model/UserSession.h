//
//  UserSession.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserSession : NSObject
+ (instancetype)session;

- (User *)currentUser;
- (void)updateRealAuthState;
- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code third_id:(NSString *)thirdID success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;
- (void)logoutSuccess:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure;
- (void)wechatLoginWithCode:(NSString *)code success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure;
- (void)checkUserAvailable:(void (^)(BOOL availble))available;


@end

NS_ASSUME_NONNULL_END
