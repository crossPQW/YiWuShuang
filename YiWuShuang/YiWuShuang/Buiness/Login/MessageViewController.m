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
#import "ApiManager.h"
#import "MBProgressHUD.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, strong) NSTimer *timer;
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
- (IBAction)getCode:(id)sender {
    
    __weak typeof(self) ws = self;
    [[ApiManager manager] sendMessageSuccess:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            [ws countDown];
        }else{

        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

- (void)countDown {
    [self setBtnText:@"60s"];
    __block int t = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        t -= 1;
        if (t <= 0) {
            [self setBtnText:@"获取验证码"];
            self.getCodeBtn.enabled = YES;
            [timer setFireDate:[NSDate distantFuture]];
            [timer invalidate];
        }else{
            NSString *title = [NSString stringWithFormat:@"%ds",t];
            [self setBtnText:title];
            self.getCodeBtn.enabled = NO;
        }
    }];
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)setBtnText:(NSString *)text {
    self.getCodeBtn.titleLabel.text = text;
    [self.getCodeBtn setTitle:text forState:UIControlStateNormal];
}
@end
