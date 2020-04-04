//
//  BaseModel.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject
@property (nonatomic, assign) int code;
@property (nonatomic, strong, nullable) NSDictionary *data;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) int time;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
