//
//  PartViewcontroller.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import "TeamViewController.h"
#import "UserSession.h"
#import "LoginViewController.h"
#import "HomeTopView.h"
#import "UIView+DYKIOS.h"
#import "PersonCellTableViewCell.h"
#import "Masonry.h"
#import "ApiManager.h"
#import "YKAddition.h"
#import "NSDictionary+Addition.h"
#import "EmptyView.h"
#import "PersonHeaderView.h"
#import "PersonModel.h"
#import "TeamModel.h"
#import "TeamCell.h"
#import "AddPersonViewController.h"

@interface TeamViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL showFirstSection;
@property (nonatomic, assign) BOOL showSecondSection;
@property (nonatomic, strong) UIButton *addMemberBtn;
@property (nonatomic, strong) UIButton *addStudentBtn;
@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showFirstSection = YES;
    self.showSecondSection = YES;
    
    NSMutableArray *array = @[].mutableCopy;
    [array yk_addObject:[NSArray yy_modelArrayWithClass:[PersonModel class] json:self.model.members]];
    [array yk_addObject:[NSArray yy_modelArrayWithClass:[PersonModel class] json:self.model.students]];
    self.data = array.copy;
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(teamSetting)];
    rightItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)teamSetting {
    
}


- (void)setupSubviews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = self.model.name;
    HomeTopView *topView = [[HomeTopView alloc] init];
    self.topView = topView;
    [self.view addSubview:topView];
    
    self.addMemberBtn = [self createBtnWithTitle:@"添加成员" action:@selector(addMember:)];
    [self.view addSubview:self.addMemberBtn];
    self.addStudentBtn = [self createBtnWithTitle:@"添加学员" action:@selector(addStudent:)];
    [self.view addSubview:self.addStudentBtn];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(74);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.addMemberBtn.mas_top).offset(-10);
    }];
    
    [self.addMemberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.equalTo(self.addStudentBtn);
        make.right.equalTo(self.addStudentBtn.mas_left).offset(-34);
        make.bottom.mas_equalTo(self.view).offset(-45);
        make.height.mas_equalTo(50);
    }];
    
    [self.addStudentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addMemberBtn.mas_right).offset(34);
        make.width.equalTo(self.addMemberBtn);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.mas_equalTo(self.view).offset(-45);
        make.height.mas_equalTo(50);
    }];
}
- (void)addMember:(id)sender {
    AddPersonViewController *vc = [[AddPersonViewController alloc] init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addStudent:(id)sender {
    AddPersonViewController *vc = [[AddPersonViewController alloc] init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.data yk_objectAtIndex:section];
    if (section == 0) {
        return  self.showFirstSection ? array.count : 0;
    }else if (section == 1){
        return  self.showSecondSection ? array.count : 0;
    }
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.data yk_objectAtIndex:indexPath.section];
    PersonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCellTableViewCell" forIndexPath:indexPath];
    PersonModel *model = [array yk_objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    PersonHeaderView *headerView = [PersonHeaderView headerView];
    if (section == 0) {
        headerView.titleLabel.text = @"成员";
        if (self.showFirstSection) {
            headerView.imageView.image = [UIImage imageNamed:@"person_arrow_down"];
        }else{
            headerView.imageView.image = [UIImage imageNamed:@"person_arrow"];
        }
    }else if(section == 1){
        headerView.titleLabel.text = @"学员";
        if (self.showSecondSection) {
            headerView.imageView.image = [UIImage imageNamed:@"person_arrow_down"];
        }else{
            headerView.imageView.image = [UIImage imageNamed:@"person_arrow"];
        }
    }
    headerView.block = ^(BOOL isHidden) {
        [weakSelf handleTapHeader:section isHidden:isHidden];
    };
    return headerView;
}

- (void)handleTapHeader:(NSInteger)section isHidden:(BOOL)isHidden {
    if (section == 0) {
        self.showFirstSection = !self.showFirstSection;
    }else if (section == 1){
        self.showSecondSection = !self.showSecondSection;
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];
        [_tableView registerClass:[PersonCellTableViewCell class] forCellReuseIdentifier:@"PersonCellTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)data {
    if (!_data) {
        _data = @[];
    }
    return _data;
}

- (UIButton *)createBtnWithTitle:(NSString *)title action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    btn.adjustsImageWhenHighlighted = NO;
    btn.layer.cornerRadius = 4;
    [btn setBackgroundColor:[UIColor colorWithHexRGB:@"#03C1AD"]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
