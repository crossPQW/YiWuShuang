//
//  ClassViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassTopView.h"
#import "YKAddition.h"
#import "EmptyView.h"
#import "OrderClassCell.h"
#import "StartClassViewController.h"
#import "UserSession.h"
#import "RealAuthView.h"
#import "RealAuthViewController.h"
@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClassTopView *topView;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) RealAuthView *authView;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    ClassTopView *topView = [ClassTopView topView];
    self.topView = topView;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    topView.frame = CGRectMake(0, 0, self.view.width, 110 + statusRect.size.height + 50);
    [self.view addSubview:topView];
    
    topView.tapMessageBlock = ^{
        
    };
    topView.tapAddPersonBlock = ^{
        
    };
    topView.tapStartClassBlock = ^{
        StartClassViewController *startVc = [[StartClassViewController alloc] init];
        startVc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:startVc animated:YES];
    };
    topView.tapJoinClassBlock = ^{
        
    };
    topView.tapOrderClassBlock = ^{
        
    };
    
    EmptyView *emptyView = [EmptyView emptyView];
    self.tableView.backgroundView = emptyView;

    [self.view addSubview:self.tableView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //实名认证
    [self checkAuth];
}

- (void)checkAuth {
    User *user = [[UserSession session] currentUser];
    if (!user.is_realauth) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.authView = [RealAuthView authView];
        self.authView.frame = CGRectMake(0, 0, 300, 366);
        self.authView.center = CGPointMake(self.view.width/2, self.view.height/2);
        self.authView.layer.cornerRadius = 8;
        self.authView.layer.masksToBounds = YES;
        __weak typeof(self) ws = self;
        self.authView.block = ^{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            RealAuthViewController *authVc = [sb instantiateViewControllerWithIdentifier:@"RealAuthVc"];
            authVc.hidesBottomBarWhenPushed = YES;
            [ws.navigationController pushViewController:authVc animated:YES];
            
            [bgView removeFromSuperview];
        };

        [bgView addSubview:self.authView];
        [[UIApplication sharedApplication].delegate.window addSubview:bgView];
    }
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.list.count;
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *data = [self.list yk_objectAtIndex:indexPath.row];
    OrderClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderClassCell" forIndexPath:indexPath];
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];

        [_tableView registerNib:[UINib nibWithNibName:@"OrderClassCell" bundle:nil] forCellReuseIdentifier:@"orderClassCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSArray *)list {
    if (!_list) {
        _list = @[];
    }
    return _list;
}
@end
