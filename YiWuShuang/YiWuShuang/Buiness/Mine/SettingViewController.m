//
//  SettingViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import "SettingViewController.h"
#import "ClassSettingCell.h"
#import "ClassSettingModel.h"
#import "YKAddition.h"
#import "AboutViewController.h"
#import "GradientButton.h"
#import "UserSession.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;

@property (nonatomic, strong) GradientButton *logoutBtn;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    
    GradientButton *bottomBtn = [[GradientButton alloc] init];
    bottomBtn.frame = CGRectMake(18, self.view.height - 64 - 50, self.view.width - 18 * 2, 50);
    [bottomBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    self.logoutBtn = bottomBtn;
    
    [self initDataSource];
}

- (void)logout {
    [[UserSession session] logoutSuccess:^(BaseModel * _Nonnull baseModel) {
        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVc = [loginSb instantiateViewControllerWithIdentifier:@"loginVc"];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVc];
        [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    
    ClassSettingModel *title = [[ClassSettingModel alloc] init];
    title.height = 60;
    title.style = ClassSettingModelSelect;
    title.title = @"清除缓存";
    [dataSources addObject:title];
    
    ClassSettingModel *stuCount = [[ClassSettingModel alloc] init];
    stuCount.height = 60;
    stuCount.style = ClassSettingModelSelect;
    stuCount.title = @"关于我们";
    [dataSources addObject:stuCount];
    
    ClassSettingModel *classID = [[ClassSettingModel alloc] init];
    classID.height = 60;
    classID.style = ClassSettingModelSubtitle;
    classID.title = @"当前版本";
    classID.subtitle = @"V 1.01";
    [dataSources addObject:classID];
    

    self.dataSources = dataSources.copy;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassSettingModel *model = self.dataSources[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.clickBlock = ^(ClassSettingModel * _Nonnull model) {
        if (indexPath.row == 0) {
            [MBProgressHUD showText:@"清除完成" inView:self.view];
        }else if (indexPath.row == 1){
            AboutViewController *vc = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    ClassSettingModel *model = self.dataSources[indexPath.row];
    cell.model = model;
    return cell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [MBProgressHUD showText:@"清除完成" inView:self.view];
    }else if (indexPath.row == 1){
        AboutViewController *vc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ClassSettingCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
