//
//  ViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "HomeViewController.h"
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
#import "TeamViewController.h"
#import "HomePopView.h"
#import "AddPersonViewController.h"
#import "CreateOrizViewController.h"
#import "JoinOrizViewController.h"
#import "AddTeamViewController.h"
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *teamList;//组织列表
@property (nonatomic, strong) HomePopView *popView;

@property (nonatomic, strong) UISearchBar *serchBar;
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL showFirstSection;
@property (nonatomic, assign) BOOL showSecondSection;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.showFirstSection = YES;
    self.showSecondSection = YES;
    self.data = @[];
    self.teamList = @[];
    [self setupSubviews];
    [self requestTeamList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"锐听音乐培训学校" style:UIBarButtonItemStylePlain target:self action:@selector(tapLeftItem)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"person_add"] style:UIBarButtonItemStylePlain target:self action:@selector(tapRightItem)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexRGB:@"#03C1AD"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexRGB:@"#03C1AD"]};
}


- (void)setupSubviews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.serchBar];
    [self.serchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(42);
    }];
    
    HomeTopView *topView = [[HomeTopView alloc] init];
    self.topView = topView;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.serchBar.mas_bottom).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(74);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    EmptyView *emptyView = [EmptyView emptyView];
    emptyView.block = ^{
        NSLog(@"tap invate member");
        [self.tableView reloadData];
    };
    self.tableView.backgroundView = emptyView;
}

- (void)requestTeamList {
    __weak typeof(self) weakSelf = self;
    [[ApiManager manager] getOrganization:[UserSession session].currentUser.token success:^(BaseModel * _Nonnull baseModel) {
        if ([baseModel.data isKindOfClass:[NSArray class]]) {
            weakSelf.teamList = baseModel.data;
            NSDictionary *firstTeam = weakSelf.teamList.firstObject;
            NSString *name = [firstTeam stringForKey:@"name"];
            [weakSelf.navigationItem.leftBarButtonItem setTitle:name];
            [weakSelf.topView fillData:firstTeam];
            [weakSelf requestMemberList];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)requestMemberList {
    NSDictionary *firstTeam = self.teamList.firstObject;
    NSString *teamID = [firstTeam stringForKey:@"id"];
    [[ApiManager manager] memberList:teamID success:^(BaseModel * _Nonnull baseModel) {
        [self parseDataWithDictionary:baseModel.data];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)parseDataWithDictionary:(NSDictionary *)data {
    data = @{
        @"part_list" : @[
                @{@"id" : @"1",
                  @"name":@"书法部门",
                  @"manager_id" : @"1",
                  @"members" : @[@{@"team_id" : @"123",@"part_id":@"1",@"user_id":@"7",@"type":@"1",@"avatar":@"asdasd",@"nickname":@"hahaha"}]
                },
                @{@"id" : @"1",
                  @"name":@"开发部门",
                  @"manager_id" : @"1",
                  @"members" : @[@{@"team_id" : @"123",@"part_id":@"1",@"user_id":@"7",@"type":@"1",@"avatar":@"asdasd",@"nickname":@"hahaha"}]
                },
        ],
        @"members"   : @[
                @{@"team_id" : @"123",@"part_id":@"1",@"user_id":@"7",@"type":@"1",@"avatar":@"asdasd",@"nickname":@"hahaha1"},
                @{@"team_id" : @"123",@"part_id":@"1",@"user_id":@"7",@"type":@"1",@"avatar":@"asdasd",@"nickname":@"hahaha2"},
        ],
        @"students"  : @[
                @{@"team_id" : @"123",@"part_id":@"1",@"user_id":@"7",@"type":@"1",@"avatar":@"asdasd",@"nickname":@"hahaha3"},
                @{@"team_id" : @"123",@"part_id":@"1",@"user_id":@"7",@"type":@"1",@"avatar":@"asdasd",@"nickname":@"hahaha4"},
        ],
    };
    if (!data) {return;}
    NSMutableArray *allData = @[].mutableCopy;
    NSArray *members = [NSArray yy_modelArrayWithClass:[PersonModel class] json:[data arrayForKey:@"members"]];//成员列表
    NSArray *students = [NSArray yy_modelArrayWithClass:[PersonModel class] json:[data arrayForKey:@"students"]];//学员列表
    NSArray *teamList = [NSArray yy_modelArrayWithClass:[TeamModel class] json:[data arrayForKey:@"part_list"]];//部门列表
    [allData yk_addObject:teamList];
    [allData yk_addObject:members];
    [allData yk_addObject:students];
    self.data = allData.copy;
    
    self.tableView.backgroundView = nil;
    [self.tableView reloadData];
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.data yk_objectAtIndex:section];
    if (section == 1) {
        return  self.showFirstSection ? array.count : 0;
    }else if (section == 2){
        return  self.showSecondSection ? array.count : 0;
    }
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.data yk_objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        TeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell"];
        TeamModel *model = [array yk_objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }else{
        PersonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCellTableViewCell" forIndexPath:indexPath];
        PersonModel *model = [array yk_objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;;
    }else{
        __weak typeof(self) weakSelf = self;
        PersonHeaderView *headerView = [PersonHeaderView headerView];
        if (section == 1) {
            headerView.titleLabel.text = @"成员";
            if (self.showFirstSection) {
                headerView.imageView.image = [UIImage imageNamed:@"person_arrow_down"];
            }else{
                headerView.imageView.image = [UIImage imageNamed:@"person_arrow"];
            }
        }else if(section == 2){
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
}

- (void)handleTapHeader:(NSInteger)section isHidden:(BOOL)isHidden {
    if (section == 0) {
        return;
    }else if (section == 1) {
        self.showFirstSection = !self.showFirstSection;
    }else if (section == 2){
        self.showSecondSection = !self.showSecondSection;
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        NSArray *teams = [self.data yk_objectAtIndex:0];
        TeamModel *model = [teams yk_objectAtIndex:indexPath.row];
        
        TeamViewController *teamVc = [[TeamViewController alloc] init];
        teamVc.model = model;
        teamVc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:teamVc animated:YES];
    }
}
#pragma mark - action
- (void)tapLeftItem {
    
}

- (void)tapRightItem {
    if (self.popView.superview) {
        [self.popView removeFromSuperview];
        self.popView = nil;
    }else{
        HomePopView *popView = [HomePopView popView];
        self.popView = popView;
        [self.view addSubview:popView];
        popView.frame = CGRectMake(self.view.width - 143 - 10, 0, 143, 264);
        
        __weak typeof(self) weakSelf = self;
        popView.addMemberBlock = ^{
            AddPersonViewController *addMemberVc = [[AddPersonViewController alloc] init];
            addMemberVc.hidesBottomBarWhenPushed = YES;
            addMemberVc.type = 1;
            [weakSelf.navigationController pushViewController:addMemberVc animated:YES];
        };
        popView.addStudentBlock = ^{
            AddPersonViewController *addStu = [[AddPersonViewController alloc] init];
            addStu.hidesBottomBarWhenPushed = YES;
            addStu.type = 2;
            [weakSelf.navigationController pushViewController:addStu animated:YES];
        };
        popView.addTeamBlock = ^{
            AddTeamViewController *teamVc = [[AddTeamViewController alloc] init];
            teamVc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:teamVc animated:YES];
        };
        popView.addOrigBlock = ^{
            CreateOrizViewController *creatVc = [[CreateOrizViewController alloc] init];
            creatVc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:creatVc animated:YES];
        };
        popView.joinOrigBlock = ^{
            JoinOrizViewController *joinVc = [[JoinOrizViewController alloc] init];
            joinVc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:joinVc animated:YES];
        };
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];
        [_tableView registerClass:[PersonCellTableViewCell class] forCellReuseIdentifier:@"PersonCellTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TeamCell" bundle:nil] forCellReuseIdentifier:@"teamCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchBar *)serchBar {
    if (!_serchBar) {
        _serchBar = [[UISearchBar alloc] init];
        _serchBar.placeholder = @"搜索";
        _serchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _serchBar;
}
@end
