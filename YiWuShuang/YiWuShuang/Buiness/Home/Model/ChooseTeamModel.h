//
//  ChooseTeamModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/5/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseTeamModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isChecked;

@end

NS_ASSUME_NONNULL_END
