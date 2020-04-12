//
//  NSObject+Addition.h
//  YKiPad
//
//  Created by joycodes on 11-5-4.
//  Copyright 2011年 优酷. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(Addition)
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (NSString *)prettyDescription;
@end