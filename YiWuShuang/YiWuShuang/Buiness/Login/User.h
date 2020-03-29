//
//  User.h
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, assign) BOOL isLogin;

- (User *)currentUser;
@end

NS_ASSUME_NONNULL_END
