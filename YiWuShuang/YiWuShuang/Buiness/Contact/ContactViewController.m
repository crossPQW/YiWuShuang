//
//  ContactViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/31.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ContactViewController.h"
#import "InvateView.h"
#import "YKAddition.h"
#import "ClassApiManager.h"
#import "PersonModel.h"
#import "PersonCellTableViewCell.h"
#import "InvateContactViewController.h"
#import "PersonViewController.h"
#import "SearchResultViewController.h"

@interface ContactViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *resultVC;

@property (nonatomic, strong) UISearchBar *serchBar;
@property (nonatomic, strong) InvateView *invateView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@end

@implementation ContactViewController{
    UILocalizedIndexedCollation *collation;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"contact_add"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"加好友" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    [self.view addSubview:self.serchBar];
    self.serchBar.frame = CGRectMake(0, 10, self.view.width, 42);
    
    __weak typeof(self) weakSelf = self;
    //邀请按钮
    self.invateView = [InvateView invateView];
    [self.view addSubview:self.invateView];
    [self.invateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.serchBar.mas_bottom);
        make.height.mas_equalTo(69);
    }];
    self.invateView.icon.image = [UIImage imageNamed:@"contact_phone"];
    self.invateView.titleLabel.text = @"邀请新成员";
    self.invateView.block = ^{
        InvateContactViewController *vc = [[InvateContactViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //tableview
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.invateView.mas_bottom);
    }];
    
    [self requestFriend];
    
    //检查通讯录上传情况
    [[ClassApiManager manager] uploadContact];
}

- (void)prepareIndex {
    collation = [UILocalizedIndexedCollation currentCollation];
    NSArray *titles = collation.sectionTitles;
    
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i = 0; i<titles.count; i++) {
        NSMutableArray *subarray = [NSMutableArray array];
        [sectionArray addObject:subarray];
    }
    
    for (PersonModel *model in self.friends) {
        NSInteger section = [collation sectionForObject:model collationStringSelector:@selector(nickname)];
        NSMutableArray *subArray = sectionArray[section];
        [subArray addObject:model];
    }
    
    for (NSMutableArray *array in sectionArray) {
        NSArray *sortArray = [collation sortedArrayFromArray:array collationStringSelector:@selector(nickname)];
        [array removeAllObjects];
        [array addObjectsFromArray:sortArray];
    }
    
    self.sectionArr = sectionArray;
}

- (void)requestFriend {
    [[ClassApiManager manager] getFriendsSuccess:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            if ([baseModel.data isKindOfClass:[NSArray class]]) {
                NSArray *data = baseModel.data;
                NSArray *modes = [NSArray yy_modelArrayWithClass:[PersonModel class] json:data];
                self.friends = modes;
                [self mock];
                [self prepareIndex];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [collation sectionTitles].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sectionArr objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCellTableViewCell"];
    cell.hiddenCheckMark = YES;

    PersonModel *model = [[self.sectionArr yk_objectAtIndex:indexPath.section] yk_objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonModel *model = [[self.sectionArr yk_objectAtIndex:indexPath.section] yk_objectAtIndex:indexPath.row];
    PersonViewController *vc = [[PersonViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.ID = model.friendId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return [_sectionArr[section] count] == 0 ? 0 : 30;
    return 0;
}

//index
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return collation.sectionTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return collation.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.type = 1;
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultVC animated:NO];
}
- (void)mock {
#ifdef DEBUG
    NSMutableArray *temp = @[].mutableCopy;

    NSArray *nameArray = @[@"许宇翔", @"卫天宇", @"蒋朝海", @"孙效富", @"吕凯军", @"吴高伟", @"周仁波", @"孔轮", @"褚启波", @"郑政", @"尤有", @"赵哲", @"严奇", @"冯胜东", @"陶宏涛", @"钱大发", @"王言", @"蒋翰", @"许克", @"吕绍", @"杨和", @"姜刚", @"魏德元", @"杨慧军", @"尹涛", @"杨柯涵"];
    for (int i = 0; i<nameArray.count; i++) {
        PersonModel *model = [[PersonModel alloc] init];
        model.friendId = [NSString stringWithFormat:@"%d",i];
        model.nickname = nameArray[i];
        model.avatar = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1657887369,1770329042&fm=26&gp=0.jpg";
        [temp addObject:model];
    }
    self.friends = temp.copy;
#endif
}


- (void)addFriend {
    
}

#pragma mark - getter
- (UISearchBar *)serchBar {
    if (!_serchBar) {
        _serchBar = [[UISearchBar alloc] init];
        _serchBar.placeholder = @"请输入手机号或昵称搜索";
        _serchBar.searchBarStyle = UISearchBarStyleMinimal;
        _serchBar.delegate = self;
    }
    return _serchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.invateView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];
        [_tableView registerClass:[PersonCellTableViewCell class] forCellReuseIdentifier:@"PersonCellTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.sectionIndexColor = [UIColor colorWithHexRGB:@"#303033"];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexMinimumDisplayRowCount = 1;
    }
    return _tableView;
}

- (NSArray *)friends {
    if (!_friends) {
        _friends = @[];
    }
    return _friends;
}

@end
