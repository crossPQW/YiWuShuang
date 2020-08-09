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
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

#define wechatAppKey @"wxea7ba9acc178cc95"
#define wechatAppSecrect @"07c8294cbd4452a4729067183b361fef"
#define dingAppKey @"dingoavdkwtbhmfcetfbwb"
#define dingAppSecrect @"xp0AkyA0qLahK06kTe3Z146_GitvWCbMyr6fO1QBaFdvgVxAdaNpR8RbfYf1VvXB"
#define kUniversalLink @"https://www.yiwushuang.app/"
@interface AppDelegate ()<WXApiDelegate>

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
    
    //分享 sdk
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
//        [platformsRegister setupWeChatWithAppId:@"wxea7ba9acc178cc95" appSecret:@"07c8294cbd4452a4729067183b361fef" universalLink:@"https://in0f5.share2dlink.com/"];
        [platformsRegister setupQQWithAppId:@"101879792" appkey:@"0fad1de252e7ff7baaf01ce95e778fe1" enableUniversalLink:NO universalLink:nil];
        [platformsRegister setupDingTalkWithAppId:@"dingoavdkwtbhmfcetfbwb"];
    }];
    [WXApi registerApp:@"wxea7ba9acc178cc95" universalLink:@"https://in0f5.share2dlink.com/"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *resp2 = (SendAuthResp *)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wxLogin" object:resp2];
    }else{
        
    }
}


- (void)onReq:(BaseReq *)req {
    
}
@end
