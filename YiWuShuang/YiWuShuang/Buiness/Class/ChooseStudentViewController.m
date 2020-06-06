//
//  ChooseStudentViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/31.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChooseStudentViewController.h"
#import "YKAddition.h"
#import "InvateView.h"
#import "PersonCellTableViewCell.h"
#import "ChooseBottomView.h"
#import "ClassApiManager.h"
#import "PersonModel.h"

@interface ChooseStudentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *serchBar;
@property (nonatomic, strong) InvateView *invateView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChooseBottomView *bottomView;

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *choosedFriends;
@end

@implementation ChooseStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择上课人员";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
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
        
    };
    
    //tableview
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.invateView.mas_bottom);
    }];
    
    self.bottomView = [ChooseBottomView bottomView];
    [self.view addSubview:self.bottomView];
    self.bottomView.block = ^{
        NSString *ids = [weakSelf chooseIds];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hasChooseStudent" object:nil userInfo:@{@"count":@(weakSelf.choosedFriends.count),@"ids":ids}];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(109);
    }];
    
    [self requestFriend];
}

- (NSString *)chooseIds {
    NSString *ids = @"";
    for (PersonModel *model in self.choosedFriends) {
        ids = [ids stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@,",model.friendId]];
    }
    return ids;
}

- (void)requestFriend {
    [[ClassApiManager manager] getFriendsSuccess:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            if ([baseModel.data isKindOfClass:[NSArray class]]) {
                NSArray *data = baseModel.data;
                NSArray *modes = [NSArray yy_modelArrayWithClass:[PersonModel class] json:data];
                self.friends = modes;
                [self mock];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)mock {
#ifdef DEBUG
    NSMutableArray *temp = @[].mutableCopy;
    for (int i = 0; i<10; i++) {
        PersonModel *model = [[PersonModel alloc] init];
        model.friendId = [NSString stringWithFormat:@"%d",i];
        model.nickname = [NSString stringWithFormat:@"mock 名字%d",i];
        model.avatar = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1657887369,1770329042&fm=26&gp=0.jpg";
        [temp addObject:model];
    }
    self.friends = temp.copy;
#endif
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCellTableViewCell"];
    PersonModel *model = [self.friends yk_objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PersonModel *model = [self.friends yk_objectAtIndex:indexPath.row];
    model.isChecked = !model.isChecked;
    [tableView reloadData];
    
    [self configBottomView];
}

- (void)configBottomView {
    if (self.friends.count == 0) {
        return;
    }
    //记录选中的
    NSMutableArray *checked = @[].mutableCopy;
    for (int i = 0; i<self.friends.count; i++) {
        PersonModel *p = [self.friends yk_objectAtIndex:i];
        if (p.isChecked) {
            [checked yk_addObject:p];
        }
    }
    self.choosedFriends = checked.copy;
    if (checked.count > 0) {
        self.bottomView.hidden = NO;
        self.bottomView.countLabel.text = [NSString stringWithFormat:@"已选%lu人",(unsigned long)checked.count];
    }else{
        self.bottomView.hidden = YES;
    }
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
        CGFloat y = self.invateView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];
        [_tableView registerClass:[PersonCellTableViewCell class] forCellReuseIdentifier:@"PersonCellTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
