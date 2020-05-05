//
//  BaseTabBarController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "ClassViewController.h"
#import "MineViewController.h"
#import "BaseNavigationController.h"
#import "UIColor+Addition.h"
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupControllers];
}

- (void)setupControllers {
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    BaseNavigationController *homeVcNav = [[BaseNavigationController alloc] initWithRootViewController:homeVc];
    [self addChildViewController:homeVcNav title:@"首页" imageNamed:@"tabbar_home"];
    
    ClassViewController *classVc = [[ClassViewController alloc] init];
    BaseNavigationController *classVcNav = [[BaseNavigationController alloc] initWithRootViewController:classVc];
    [self addChildViewController:classVcNav title:@"上课" imageNamed:@"tabbar_class"];
    
    MineViewController *mineVc = [[MineViewController alloc] init];
    BaseNavigationController *mineVcNav = [[BaseNavigationController alloc] initWithRootViewController:mineVc];
    [self addChildViewController:mineVcNav title:@"我的" imageNamed:@"tabbar_mine"];
    
    self.viewControllers = @[homeVcNav,classVcNav,mineVcNav];
}

- (void)addChildViewController:(BaseNavigationController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed
{
    UIColor *normalColor = [UIColor colorWithHexRGB:@"#909399"];
    UIColor *seleceColor = [UIColor colorWithHexRGB:@"#03C1AD"];
    NSString *normalImage = [imageNamed stringByAppendingString:@"_normal"];
    NSString *selectedImagStr = [imageNamed stringByAppendingString:@"_selected"];
    UIImage *image = [UIImage imageNamed:normalImage];
    UIImage *selectImage = [UIImage imageNamed:selectedImagStr];
    vc.tabBarItem.title = title;
    vc.tabBarItem.selectedImage = selectImage;
    vc.tabBarItem.image = image;
    
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: normalColor} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: seleceColor} forState:UIControlStateSelected];
}

@end
