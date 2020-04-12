//
//  AppDelegate.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UserSession.h"
#import "LoginViewController.h"
#import "YKWoodpecker.h"

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
    
    if ([[UserSession session] isAvailable]) {
        RootViewController *rootVc = [[RootViewController alloc] init];
        [self.window setRootViewController:rootVc];
        [self.window makeKeyAndVisible];
    }else{
        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}




@end
