//
//  PasswordViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/27.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmTf;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
    [self.checkBtn setSelected:NO];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}
- (IBAction)complateClick:(id)sender {
}
- (IBAction)checkBtnClick:(id)sender {
    self.checkBtn.selected = !self.checkBtn.isSelected;
}

@end
