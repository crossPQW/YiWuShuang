//
//  NSDateFormatter+TIXACategory.h
//  Lianxi
//
//  Created by Liusx on 12-8-13.
//  Copyright (c) 2012年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Addition)

+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter; //yyyy-MM-dd HH:mm:ss

@end
