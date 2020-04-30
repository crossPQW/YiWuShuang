//
//  BaseNavigationController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+Addition.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHexRGB:@"#03C1AD"]];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};

}

- (void)setBarStyle:(BOOL)themeStyle {
    UIColor *titleColor;
    UIColor *tineColor;
    if (themeStyle) {
        titleColor = [UIColor whiteColor];
        tineColor = [UIColor colorWithHexRGB:@"#03C1AD"];
    }else{
        titleColor = [UIColor blackColor];
        tineColor = [UIColor whiteColor];
    }
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:tineColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor,NSFontAttributeName:[UIFont systemFontOfSize:18]};
}

@end
