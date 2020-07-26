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

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

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
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.loginBtn.bounds;
    [self.loginBtn.layer addSublayer:layer];
    
    
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
    [self.checkBtn setSelected:NO];
    
    //获取文案
    [[ClassApiManager manager] getTextWithType:@"1" success:^(BaseModel * _Nonnull baseModel) {
        if ([baseModel.data isKindOfClass:[NSString class]]) {
            NSString *text = baseModel.data;
            self.textLabel.text = text;
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - event

- (IBAction)clickLogin:(id)sender {
    BOOL hasAgress = self.checkBtn.isSelected;
    if (!hasAgress) {
        [MBProgressHUD showText:@"请勾选同意用户协议及隐私政策" inView:self.view];
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
    [ShareSDK authorize:SSDKPlatformTypeWechat
               settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
           {
                NSLog(@"%@",user.rawData);
                NSLog(@"uid===%@",user.uid);
                NSLog(@"%@",user.credential);
           }
        else if (state == SSDKResponseStateCancel)
           {
                NSLog(@"取消");
           }
        else if (state == SSDKResponseStateFail)
           {
                NSLog(@"%@",error);
           }
    }];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params SSDKSetupShareParamsByText:@"test"
//                                images:[UIImage imageNamed:@"shareImg.png"]
//                                   url:[NSURL URLWithString:@"http://www.mob.com/"]
//                                 title:@"title"
//                              type:SSDKContentTypeAuto];
//    [ShareSDK share:SSDKPlatformTypeWechat parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        
//    }];
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
//    [[ApiManager manager] getOrganization:user.token success:^(BaseModel * _Nonnull baseModel) {
//        NSArray *list = baseModel.data;
//        if ([list isKindOfClass:[NSArray class]] && list.count > 0) {
//            [ws jumpToMainPage];
//        }else{
//            [ws jumpToChooseOri];
//        }
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
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
