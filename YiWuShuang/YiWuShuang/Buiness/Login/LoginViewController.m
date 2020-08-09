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
#import <ShareSDK/ShareSDK.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import "ClassApiManager.h"
#import "BindPhoneViewController.h"
#import "WXApi.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, strong) NSString *thirdID;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LoginViewController

#pragma mark - lifeStyle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.loginBtn.bounds;
    [self.loginBtn.layer addSublayer:layer];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.privacyLabel.text];
    NSRange range = [self.privacyLabel.text rangeOfString:@"《用户协议与隐私政策》"];
    [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#15C3D6"]} range:range];
    self.privacyLabel.attributedText = attr;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxDidLogin:) name:@"wxLogin" object:nil];
    
    //获取文案
    [[ClassApiManager manager] getTextWithType:@"1" success:^(BaseModel * _Nonnull baseModel) {
        if ([baseModel.data isKindOfClass:[NSString class]]) {
            NSString *text = baseModel.data;
            self.textLabel.text = text;
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    //隐私授权
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - event

- (IBAction)clickLogin:(id)sender {
//    BOOL hasAgress = self.checkBtn.isSelected;
//    if (!hasAgress) {
//        [MBProgressHUD showText:@"请勾选同意用户协议及隐私政策" inView:self.view];
//    }else{
        NSString *phoneNumber = self.accountTextField.text;
        NSString *code = self.pwdTextField.text;
        [[UserSession session] loginWithPhoneNumber:phoneNumber code:code third_id:self.thirdID success:^(User * _Nonnull user) {
            if (user) {
                BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
                [[UIApplication sharedApplication].delegate.window setRootViewController:tabBar];
                [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
//    }
}


- (IBAction)clickCheck:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}
- (IBAction)wechatLogin:(id)sender {
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

- (void)wxDidLogin:(NSNotification *)noti {
    SendAuthResp *resp = noti.object;
    NSString *code = resp.code;
    [[UserSession session] wechatLoginWithCode:code success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 400) {
            if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
                NSString *thirdId = [baseModel.data stringForKey:@"third_id"];
                self.thirdID = thirdId;
            }
            UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            BindPhoneViewController *bindVc = [loginSb instantiateViewControllerWithIdentifier:@"BindVc"];
            bindVc.thirdID = self.thirdID;
            [self presentViewController:bindVc animated:YES completion:nil];
        }else if (baseModel.code == 1){
            BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
            [[UIApplication sharedApplication].delegate.window setRootViewController:tabBar];
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        }else{
            [self showError];
        }

    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)showError {
    [MBProgressHUD showText:@"登录失败" inView:self.view];
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
    [self jumpToMainPage];
}

- (void)jumpToMainPage{
    BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
    [[UIApplication sharedApplication].delegate.window setRootViewController:tabBar];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (CAGradientLayer *)gLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:239/255.0 blue:162/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:20/255.0 green:193/255.0 blue:215/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    return gl;
}

@end
