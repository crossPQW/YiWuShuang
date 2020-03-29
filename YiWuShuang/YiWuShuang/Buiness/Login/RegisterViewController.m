//
//  RegisterViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/27.
//  Copyright © 2020 huang. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
    
    
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
    [self.checkBtn setSelected:NO];
}
- (IBAction)checkBtnClick:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}

- (IBAction)clickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)nextStepClick:(id)sender {
}
- (IBAction)accountLoginClick:(id)sender {
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
    loginVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:loginVc animated:YES];
}

@end
