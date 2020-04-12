//
//  UIViewController+Addition.h
//  Youku
//
//  Created by Peter on 9/21/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

- (void)pushController:(UIViewController *)controller animated:(BOOL)animated;
- (void)popController:(BOOL)animated;

@end
