//
//  UITableViewCell+Addition.m
//  YoukuCore
//
//  Created by yanghu on 14-1-3.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "UITableViewCell+Addition.h"

@implementation UITableViewCell (Addition)
- (UITableView *)ownerTableView {
    /*In iOS7 UITableViewWrapperView is the superview of a UITableViewCell. Also UITableView is superview of a UITableViewWrapperView*/
    if ([self.superview isKindOfClass:[UITableView class]]) /*under iOS7*/
        return (UITableView *)self.superview;
    else if ([self.superview.superview isKindOfClass:[UITableView class]])
        return (UITableView *)self.superview.superview;
    else
    {
        NSAssert(NO, @"UITableView shall always be found.");
        return nil;
    }
}
@end
