//
//  LoginViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "LoginViewController.h"
#import "ApiManager.h"
#import "ChooseOrizViewController.h"
#import "YYKit.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+helper.h"
#import "UserSession.h"
#import "ChooseOrizViewController.h"
#import "BaseTabBarController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, strong) NSTimer *timer;
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

#pragma mark - event
- (IBAction)clickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLogin:(id)sender {
    BOOL hasAgress = self.checkBtn.isSelected;
    if (!hasAgress) {
        [MBProgressHUD showText:@"您还没有勾选同意" inView:self.view];
    }else{
        __weak typeof(self) ws = self;
        NSString *phoneNumber = self.accountTextField.text;
        NSString *code = self.pwdTextField.text;
        [[UserSession session] loginWithPhoneNumber:phoneNumber code:code success:^(User * _Nonnull user) {
            if (user) {
                [ws handleLoginSuccess];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (IBAction)clickCheck:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}
- (IBAction)wechatLogin:(id)sender {
}


- (IBAction)getCode:(id)sender {
    __weak typeof(self) ws = self;
    NSString *phoneNumber = self.accountTextField.text;
    if (!(phoneNumber.length == 11)) {
        [MBProgressHUD showText:@"请输入正确的手机号" inView:self.view];
        return;
    }
    [[ApiManager manager] sendMessageWithPhoneNumber:phoneNumber
                                             success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            [ws countDown];
        }else{

        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - private
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

- (void)jumpToChooseOri {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ChooseOrizViewController *chooseVc = [sb instantiateViewControllerWithIdentifier:@"chooseOrgiVc"];
    [self.navigationController pushViewController:chooseVc animated:YES];
//    [self presentViewController:chooseVc animated:YES completion:nil];
    
}

- (void)handleLoginSuccess {
    User *user = [[UserSession session] currentUser];
    __weak typeof(self) ws = self;
    [[ApiManager manager] getOrganization:user.token success:^(BaseModel * _Nonnull baseModel) {
        NSArray *list = baseModel.data;
        if ([list isKindOfClass:[NSArray class]] && list.count > 0) {
            [ws jumpToMainPage];
        }else{
            [ws jumpToChooseOri];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)jumpToMainPage{
    BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
    [[UIApplication sharedApplication].delegate.window setRootViewController:tabBar];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}
@end
