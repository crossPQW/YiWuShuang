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
@interface HomeViewController ()
@property (nonatomic, strong) NSArray *teamList;//组织列表
@property (nonatomic, strong) NSArray *students;//学员列表
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexRGB:@"#F5F7FA"];
    self.teamList = @[];
    self.students = @[];
    [self setupSubviews];
    [self requestTeamList];
}


- (void)setupSubviews {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"锐听音乐培训学校" style:UIBarButtonItemStylePlain target:self action:@selector(tapLeftItem)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"person_add"] style:UIBarButtonItemStylePlain target:self action:@selector(tapRightItem)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    HomeTopView *topView = [[HomeTopView alloc] init];
    self.topView = topView;
    [self.view addSubview:topView];
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
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
        
    } failure:^(NSError * _Nonnull error) {
        
    }];

}
#pragma mark - action
- (void)tapLeftItem {
    
}

- (void)tapRightItem {
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];
        [_tableView registerClass:[PersonCellTableViewCell class] forCellReuseIdentifier:@"PersonCellTableViewCell"];
    }
    return _tableView;
}
@end
