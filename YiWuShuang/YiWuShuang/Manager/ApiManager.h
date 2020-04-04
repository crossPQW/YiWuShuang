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

- (void)sendMessageSuccess:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END