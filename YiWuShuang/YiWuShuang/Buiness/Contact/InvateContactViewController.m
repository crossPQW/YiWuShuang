//
//  InvateContactViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/6.
//  Copyright © 2020 huang. All rights reserved.
//

#import "InvateContactViewController.h"
#import "InvateView.h"
#import "YKAddition.h"
#import "ClassApiManager.h"
#import "ContactModel.h"
#import "ContactCell.h"
#import "PersonViewController.h"
@interface InvateContactViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *serchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@end

@implementation InvateContactViewController{
    UILocalizedIndexedCollation *collation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机联系人";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.serchBar];
    self.serchBar.frame = CGRectMake(0, 10, self.view.width, 42);
    
    //tableview
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.serchBar.mas_bottom);
    }];
    
    [self requestFriend];
}

- (void)requestFriend {
    [[ClassApiManager manager] getContactListSuccess:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            if ([baseModel.data isKindOfClass:[NSArray class]]) {
                NSArray *data = baseModel.data;
                NSArray *modes = [NSArray yy_modelArrayWithClass:[ContactModel class] json:data];
                self.friends = modes;
//                [self mock];
                [self prepareIndex];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)prepareIndex {
    collation = [UILocalizedIndexedCollation currentCollation];
    NSArray *titles = collation.sectionTitles;
    
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i = 0; i<titles.count; i++) {
        NSMutableArray *subarray = [NSMutableArray array];
        [sectionArray addObject:subarray];
    }
    
    for (ContactModel *model in self.friends) {
        NSInteger section = [collation sectionForObject:model collationStringSelector:@selector(name)];
        NSMutableArray *subArray = sectionArray[section];
        [subArray addObject:model];
    }
    
    for (NSMutableArray *array in sectionArray) {
        NSArray *sortArray = [collation sortedArrayFromArray:array collationStringSelector:@selector(name)];
        [array removeAllObjects];
        [array addObjectsFromArray:sortArray];
    }
    
    self.sectionArr = sectionArray;
}

- (void)mock {
#ifdef DEBUG
    NSMutableArray *temp = @[].mutableCopy;

    NSArray *nameArray = @[@"许宇翔", @"卫天宇", @"蒋朝海", @"孙效富", @"吕凯军", @"吴高伟", @"周仁波", @"孔轮", @"褚启波", @"郑政", @"尤有", @"赵哲", @"严奇", @"冯胜东", @"陶宏涛", @"钱大发", @"王言", @"蒋翰", @"许克", @"吕绍", @"杨和", @"姜刚", @"魏德元", @"杨慧军", @"尹涛", @"杨柯涵"];
    for (int i = 0; i<nameArray.count; i++) {
        ContactModel *model = [[ContactModel alloc] init];
        model.contacts_id = [NSString stringWithFormat:@"%d",i];
        model.name = nameArray[i];
        if (i%2 == 0) {
            model.avatar = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1657887369,1770329042&fm=26&gp=0.jpg";
        }
        model.status = i % 2;
        model.mobile = @"1239384950";
        [temp addObject:model];
    }
    self.friends = temp.copy;
#endif
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [collation sectionTitles].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sectionArr objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    ContactModel *model = [[self.sectionArr yk_objectAtIndex:indexPath.section] yk_objectAtIndex:indexPath.row];
    __weak typeof(self) ws= self;
    cell.addFriendBlock = ^{
        [[ClassApiManager manager] addFriendWithContactID:model.contacts_id success:^(BaseModel * _Nonnull baseModel) {
            if (baseModel.code == 1) {
                [MBProgressHUD showText:@"发送邀请成功" inView:ws.view];
            }else if (baseModel.code == 300){
                [MBProgressHUD showText:@"好友未注册平台，请先邀请好友注册" inView:ws.view];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    };
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [_sectionArr[section] count] == 0 ? 0 : 30;
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

#pragma mark - getter
- (UISearchBar *)serchBar {
    if (!_serchBar) {
        _serchBar = [[UISearchBar alloc] init];
        _serchBar.placeholder = @"请输入手机号或昵称搜索";
        _serchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _serchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.serchBar.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];
        [_tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"contactCell"];
//        [_tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"contactCell"];
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
