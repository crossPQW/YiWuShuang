//
//  MBProgressHUD+helper.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/6.
//  Copyright © 2020 huang. All rights reserved.
//

#import "MBProgressHUD+helper.h"

@implementation MBProgressHUD (helper)
+ (void)showText:(NSString *)text inView:(UIView *)view {
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:view];
    hub.mode = MBProgressHUDModeText;
    hub.label.text = text;
    [view addSubview:hub];
    [hub showAnimated:YES];
    [hub performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];

}
@end
