//
//  LoginViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "LoginViewController.h"
#import "MessageViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;

@end

@implementation LoginViewController

#pragma mark - lifeStyle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
    [self.checkBtn setSelected:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)clickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickRegister:(id)sender {
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"RegisterVc"];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (IBAction)clickLogin:(id)sender {
}

- (IBAction)clickCheck:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}
- (IBAction)codeLoginClick:(id)sender {
    
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    MessageViewController *message = [loginSb instantiateViewControllerWithIdentifier:@"MessageVc"];
    [self.navigationController pushViewController:message animated:YES];
}
- (IBAction)wechatLogin:(id)sender {
}

@end
