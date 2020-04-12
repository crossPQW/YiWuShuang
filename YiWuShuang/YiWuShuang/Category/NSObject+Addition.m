//
//  NSObject+Addition.m
//  YKiPad
//
//  Created by joycodes on 11-5-4.
//  Copyright 2011年 优酷. All rights reserved.
//

#import "NSObject+Addition.h"

@implementation NSObject(Addition)
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        id __unsafe_unretained usurP1 = p1;
        id __unsafe_unretained usurP2 = p2;
        id __unsafe_unretained usurP3 = p3;
        
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        [invo setArgument:&usurP1 atIndex:2];
        [invo setArgument:&usurP2 atIndex:3];
        [invo setArgument:&usurP3 atIndex:4];
        [invo invoke];
        if (sig.methodReturnLength) {
            id __unsafe_unretained anObject;
            [invo getReturnValue:&anObject];
            return anObject;
            
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *string = unicodeStr;
    NSString *tempStr1 = [string stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
- (NSString *)prettyDescription {
    NSString *desc = [NSString stringWithFormat:@"%@", self];
    return [self replaceUnicode:desc];
}
@end
