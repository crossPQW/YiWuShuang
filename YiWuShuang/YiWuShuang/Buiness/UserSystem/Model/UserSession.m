//
//  UserSession.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import "UserSession.h"
#import "ApiManager.h"

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
    return self.user;;
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)(User * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    __weak typeof(self) weakSelf = self;
    [[ApiManager manager] loginWithPhoneNumber:phoneNumber code:code success:^(BaseModel * _Nonnull baseModel) {
        NSDictionary *data = baseModel.data;
        NSDictionary *userInfo = [data valueForKey:@"userinfo"];
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
@end
