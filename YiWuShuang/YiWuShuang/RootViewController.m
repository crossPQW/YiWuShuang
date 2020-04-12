//
//  ViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "RootViewController.h"
#import "User.h"
#import "LoginViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    loginVc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
