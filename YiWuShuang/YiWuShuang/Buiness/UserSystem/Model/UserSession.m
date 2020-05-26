//
//  UserSession.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import "UserSession.h"
#import "ApiManager.h"
#import "YKAddition.h"
static NSString *userkey = @"kUserInfoKey";
@interface UserSession()
@property (nonatomic, strong) User *user;
@end
@implementation UserSession
+ (instancetype)session {
    static UserSession *sessioon;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessioon = [[UserSession alloc] init];
    });
    return sessioon;
}

- (User *)currentUser {
    if (self.user) {
        return self.user;
    };
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:userkey];
    if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
        User *user = [User yy_modelWithJSON:userInfo];
        return user;
    }
    return nil;
}

- (void)updateRealAuthState {
    self.currentUser.is_realauth = YES;
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] valueForKey:userkey];
    NSMutableDictionary *temp = userinfo.mutableCopy;
    [temp yk_setValue:@(1) forKey:@"is_realauth"];
    [[NSUserDefaults standardUserDefaults] setValue:temp forKey:userkey];
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)(User * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    __weak typeof(self) weakSelf = self;
    [[ApiManager manager] loginWithPhoneNumber:phoneNumber code:code success:^(BaseModel * _Nonnull baseModel) {
        NSDictionary *data = baseModel.data;
        NSDictionary *userInfo = [data valueForKey:@"userinfo"];
        [self saveUserInfo:userInfo];
        User *user = [User yy_modelWithJSON:userInfo];
        weakSelf.user = user;
        if (success) {
            success(user);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)saveUserInfo:(NSDictionary *)info {
    if (info.count == 0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:info forKey:userkey];
}

- (void)checkUserAvailable:(void (^)(BOOL availble))available {
    __weak typeof(self) weakSelf = self;
    [[ApiManager manager] checkTokenSuccess:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1 && available) {
            available(YES);
            [[ApiManager manager] refreshTokenSuccess:^(BaseModel * _Nonnull baseModel) {
                NSDictionary *data = baseModel.data;
                NSString *token = [data stringForKey:@"token"];
                [weakSelf updateToken:token];
            } failure:nil];
        }else{
            available(NO);
        }
    } failure:^(NSError * _Nonnull error) {
        if (available) {
            available(NO);
        }
    }];
}

- (void)updateToken:(NSString *)token {
    [self currentUser].token = token;
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:userkey];
    NSMutableDictionary *tempDict = userInfo.mutableCopy;
    [tempDict yk_setValue:token forKey:@"token"];
    [self saveUserInfo:tempDict];
}
@end
