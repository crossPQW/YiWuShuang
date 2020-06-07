//
//  SetNoteViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import "SetNoteViewController.h"
#import "YKAddition.h"
#import "ClassApiManager.h"
@interface SetNoteViewController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation SetNoteViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"备注";
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(84);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexRGB:@"303033"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)done {
    if (self.textField.text.length > 0) {
        [[ClassApiManager manager] setNoteWithFriendID:self.ID note:self.textField.text success:^(BaseModel * _Nonnull baseModel) {
            if (baseModel.code == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userHasSetNote" object:nil userInfo:@{@"name":self.textField.text}];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"给TA设置一个备注吧";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.backgroundColor = [UIColor colorWithHexRGB:@"#F5F7FA"];
    }
    return _textField;
}

@end
