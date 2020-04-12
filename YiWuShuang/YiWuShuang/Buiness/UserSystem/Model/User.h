//
//  User.h
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

//"userinfo": {
//    "id": 2,
//    "username": "18310879772",
//    "nickname": "183****9772",
//    "mobile": "18310879772",
//    "token": "25ca8124-701d-49f9-b41d-93d269cce4ff",
//    "user_id": 2,
//    "createtime": 1585723865,
//    "expiretime": 1588315865,
//    "expires_in": 2592000//过期时间
//}
@interface User : NSObject

@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *token;

@property (nonatomic, assign)NSTimeInterval createtime;
@property (nonatomic, assign)NSTimeInterval expiretime;
@property (nonatomic, assign)NSTimeInterval expires_in;

@end

NS_ASSUME_NONNULL_END
