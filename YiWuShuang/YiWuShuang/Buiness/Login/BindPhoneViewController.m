//
//  BindPhoneViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/8/8.
//  Copyright © 2020 huang. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "YKAddition.h"
#import "ApiManager.h"
#import "UserSession.h"
#import "BaseTabBarController.h"
#import <YYKit.h>

@interface BindPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phontTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bindBtn.layer.cornerRadius = 4;
    self.bindBtn.layer.masksToBounds = YES;
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.bindBtn.bounds;
    [self.bindBtn.layer addSublayer:layer];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.privacyLabel.text];
    NSRange range = [self.privacyLabel.text rangeOfString:@"《用户协议与隐私政策》"];
    [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#15C3D6"]} range:range];
    self.privacyLabel.attributedText = attr;
    
//    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_uncheck"] forState:UIControlStateNormal];
//    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
//    [self.checkBtn setSelected:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)getCode:(id)sender {
    __weak typeof(self) ws = self;
    NSString *phoneNumber = self.phontTextField.text;
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
- (IBAction)bind:(id)sender {
//    BOOL hasAgress = self.checkBtn.isSelected;
//    if (!hasAgress) {
//        [MBProgressHUD showText:@"请勾选同意用户协议及隐私政策" inView:self.view];
//    }else{
        __weak typeof(self) ws = self;
        NSString *phoneNumber = self.phontTextField.text;
        NSString *code = self.codeTextField.text;
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
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (IBAction)checkBtnTaped:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}

- (void)setBtnText:(NSString *)text {
    self.getCodeBtn.titleLabel.text = text;
    [self.getCodeBtn setTitle:text forState:UIControlStateNormal];
}


- (CAGradientLayer *)gLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:239/255.0 blue:162/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:20/255.0 green:193/255.0 blue:215/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    return gl;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
