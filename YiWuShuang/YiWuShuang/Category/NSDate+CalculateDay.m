//
//  NSDate+CalculateDay.m
//  YoukuCore
//
//  Created by Liu.Yang on 11/12/15.
//  Copyright © 2015 Youku.com inc. All rights reserved.
//

#import "NSDate+CalculateDay.h"

@implementation NSDate (CalculateDay)

- (NSDate *)firstDayOfNextMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps = [gregorian components:unitFlags
                                           fromDate:[NSDate date]];
    [comps setMonth:[comps month] + 1];
    [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    [comps setDay:1];
    
    return [gregorian dateFromComponents:comps];
}

@end
