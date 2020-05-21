//
//  TeamModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "PersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *managerID;
@property (nonatomic, strong) NSArray <PersonModel *> *members;
@property (nonatomic, strong) NSArray <PersonModel *> *students;

@property (nonatomic, assign) BOOL isChecked;

@end

NS_ASSUME_NONNULL_END
