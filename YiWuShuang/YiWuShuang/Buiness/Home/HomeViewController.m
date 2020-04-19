//
//  ViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/3/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "HomeViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "HomeTopView.h"
#import "UIView+DYKIOS.h"
#import "PersonCellTableViewCell.h"
@interface HomeViewController ()
@property (nonatomic, strong) NSArray *teamList;
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"锐听音乐培训学校" style:UIBarButtonItemStylePlain target:self action:@selector(tapLeftItem)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"person_add"] style:UIBarButtonItemStylePlain target:self action:@selector(tapRightItem)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupSubviews];
}


- (void)setupSubviews {
    HomeTopView *topView = [[HomeTopView alloc] init];
    topView.frame = CGRectMake(0, 0, self.view.width, 136);
    topView.backgroundColor = [UIColor linkColor];
    self.topView = topView;
    [self.view addSubview:topView];
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
