//
//  AppDelegate.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UserSession.h"
#import "LoginViewController.h"
#import "YKWoodpecker.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
#ifdef DEBUG
    [[YKWoodpeckerManager sharedInstance] show];
#endif
    
    BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
    [self.window setRootViewController:tabBar];
    [self.window makeKeyAndVisible];
    
    [[UserSession session] checkUserAvailable:^(BOOL availble) {
        if (!availble) {
            
            UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
            
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVc];
            [self.window setRootViewController:nav];
            [self.window makeKeyAndVisible];
        }
    }];
//    if ([[UserSession session] isAvailable]) {
//        BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
////        BaseNavigationController *root = [[BaseNavigationController alloc] initWithRootViewController:tabBar];
//        [self.window setRootViewController:tabBar];
//        [self.window makeKeyAndVisible];
//    }else{
//        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
//
//        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVc];
//        [self.window setRootViewController:nav];
//        [self.window makeKeyAndVisible];
//    }
    
    return YES;
}




@end
