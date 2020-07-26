//
//  AboutViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import "AboutViewController.h"
#import "YKAddition.h"
#import "ClassSettingModel.h"
#import "ClassSettingCell.h"
#import "IntroduceViewController.h"
#import "ProvacyViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于艺无双";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_logo"]];
    [self.view addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(153);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexRGB:@"#BFC2CC"];
    label.text = @"2020 © yiwushuang.cn  京ICP备20012753号";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-35);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *copyRight = [[UILabel alloc] init];
    copyRight.font = [UIFont systemFontOfSize:16];
    copyRight.textColor = [UIColor colorWithHexRGB:@"#BFC2CC"];
    copyRight.text = @"艺无双教育科技 版权所有";
    copyRight.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyRight];
    [copyRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(label.mas_top).offset(-15);
        make.height.mas_equalTo(22);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImage.mas_bottom).offset(30);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(copyRight.mas_top).offset(-20);
    }];
    [self initDataSource];
}

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    
    ClassSettingModel *title = [[ClassSettingModel alloc] init];
    title.height = 60;
    title.style = ClassSettingModelSelect;
    title.title = @"产品介绍";
    [dataSources addObject:title];
    
    ClassSettingModel *stuCount = [[ClassSettingModel alloc] init];
    stuCount.height = 60;
    stuCount.style = ClassSettingModelSelect;
    stuCount.title = @"隐私协议";
    [dataSources addObject:stuCount];

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
            IntroduceViewController *vc = [[IntroduceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            ProvacyViewController *vc = [[ProvacyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    ClassSettingModel *model = self.dataSources[indexPath.row];
    cell.model = model;
    return cell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
