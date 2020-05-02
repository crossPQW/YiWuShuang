//
//  AddTeamViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/2.
//  Copyright © 2020 huang. All rights reserved.
//

#import "AddTeamViewController.h"

@interface AddTeamViewController ()

@end

@implementation AddTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建部门";
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self setupSubviews];
    [self initDataSource];
}

- (void)setupSubviews {
    
}

- (void)initDataSource {
    
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
