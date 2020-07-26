//
//  FeedbackViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "YKAddition.h"
#import "GradientButton.h"
#import "ClassApiManager.h"
@interface FeedbackViewController ()
@property (nonatomic, strong) UITextView *tv;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"建议意见";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *tv = [[UITextView alloc] init];
    self.tv = tv;
    tv.font = [UIFont systemFontOfSize:15];
    tv.frame = CGRectMake(18, 100, self.view.width-18*2, 250);
    tv.backgroundColor = [UIColor colorWithHexRGB:@"#F5F7FA"];
    tv.layer.cornerRadius = 4;
    tv.layer.masksToBounds = YES;
    [self.view addSubview:tv];

    GradientButton *btn = [[GradientButton alloc] init];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    btn.left = 18;
    btn.top = tv.bottom + 20;
    btn.size = CGSizeMake(self.view.width - 36, 50);
    [self.view addSubview:btn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)submit {
    if (self.tv.text.length == 0) {
        [MBProgressHUD showText:@"您还没有输入内容" inView:self.view];
        return;
    }
    [[ClassApiManager manager] feedbackWithText:self.tv.text success:^(BaseModel * _Nonnull baseModel) {
        [MBProgressHUD showText:baseModel.msg inView:self.view];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
