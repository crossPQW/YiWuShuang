//
//  PersonModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : NSObject
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *partID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@end

NS_ASSUME_NONNULL_END
