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

@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClassTopView *topView;

@property (nonatomic, strong) NSArray *list;

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
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
