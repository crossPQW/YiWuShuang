//
//  UserSession.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSession : NSObject
+ (instancetype)session;

- (BOOL)isAvailable;

- (User *)currentUser;

- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
