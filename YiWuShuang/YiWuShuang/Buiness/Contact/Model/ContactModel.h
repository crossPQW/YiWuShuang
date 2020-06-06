//
//  ContactModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/6/6.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject
@property (nonatomic, strong) NSString *contacts_id;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
