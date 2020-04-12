//
//  NSDate+CalculateDay.h
//  YoukuCore
//
//  Created by Liu.Yang on 11/12/15.
//  Copyright © 2015 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalculateDay)

/**
 * @brief   获取当前时间下 下一个月份的第一天
 *
 * @return  下一个月份的第一天
 */
- (NSDate *)firstDayOfNextMonth;

@end
