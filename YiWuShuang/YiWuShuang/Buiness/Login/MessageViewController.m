//
//  MessageViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/27.
//  Copyright © 2020 huang. All rights reserved.
//

#import "MessageViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
    [self.checkBtn setSelected:NO];
}
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerBtnClick:(id)sender {
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"RegisterVc"];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (IBAction)loginBtn:(id)sender {
}
- (IBAction)accountLoginClick:(id)sender {
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (IBAction)wechatLogin:(id)sender {
}
- (IBAction)checkBtnClick:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}

@end
