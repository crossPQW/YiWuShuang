//
//  GetTrafficViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import "GetTrafficViewController.h"
#import "YKAddition.h"
@interface GetTrafficViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation GetTrafficViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"邀请好友赚流量";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    self.imageView.frame = self.view.bounds;
    
    [self.view addSubview:self.btn];
    self.btn.frame = CGRectMake(18, self.view.height - 54 - 70 - 50, self.view.width - 36, 54);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"invate_page"];
    }
    return _imageView;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setBackgroundImage:[UIImage imageNamed:@"poster_btn"] forState:UIControlStateNormal];
        _btn.adjustsImageWhenHighlighted = NO;
        [_btn setTitle:@"生成专属海报" forState:UIControlStateNormal];
        [_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _btn;
}
@end
