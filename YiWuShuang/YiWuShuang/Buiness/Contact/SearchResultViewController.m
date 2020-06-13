//
//  SearchResultViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/13.
//  Copyright © 2020 huang. All rights reserved.
//

#import "SearchResultViewController.h"
#import "YKAddition.h"
#import "SearchContactCell.h"
#import "ClassApiManager.h"
#import "EmptyView.h"
#import "PersonCellTableViewCell.h"
#import "PersonViewController.h"
@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *serchBar;
@property (strong, nonatomic) NSArray *dataListArry;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 49 - 15, 44)];
    [view addSubview:self.serchBar];
    self.serchBar.frame = view.bounds;
    self.serchBar.delegate = self;
    self.navigationItem.titleView = view;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - searchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    NSString *keyword = searchBar.text;
    if (keyword.length == 0) {
        [MBProgressHUD showText:@"请输入手机号" inView:self.view];
        return;
    }
    if (self.type == 1) {
        [[ClassApiManager manager] searchFriendsWithkeyword:keyword success:^(BaseModel * _Nonnull baseModel) {
            if (baseModel.code == 1) {
                if ([baseModel.data isKindOfClass:[NSArray class]]) {
                    NSArray *array = [NSArray yy_modelArrayWithClass:[PersonModel class] json:baseModel.data];
                    self.dataListArry = array;
                    [self.tableView reloadData];
                }else{
                    [self showErrorView];
                }
            }else{
                [self mock];
                [self showErrorView];
            }
        } failure:^(NSError * _Nonnull error) {
            [self showErrorView];
        }];
    }else{
        [[ClassApiManager manager] searchContactWithMobile:keyword success:^(BaseModel * _Nonnull baseModel) {
            if (baseModel.code == 1) {
                if ([baseModel.data isKindOfClass:[NSArray class]]) {
                    NSArray *array = baseModel.data;
                    self.dataListArry = array;
                    [self.tableView reloadData];
                }else if([baseModel.data isKindOfClass:[NSDictionary class]]){
                    NSMutableArray *temp = @[].mutableCopy;
                    NSDictionary *data = baseModel.data;
                    [temp yk_addObject:data];
                    self.dataListArry = temp.copy;
                    [self.tableView reloadData];
                }else{
                    [self showErrorView];
                }
            }else{
                [self showErrorView];
            }
        } failure:^(NSError * _Nonnull error) {
            [self showErrorView];
        }];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {

}

- (void)showErrorView {
    EmptyView *emptyView = [EmptyView emptyView];
    emptyView.image = @"search_empty";
    emptyView.text = @"没有符合条件的搜索结果";
    self.tableView.backgroundView = emptyView;
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataListArry.count > 0) {
        tableView.backgroundView = nil;
    }
    return self.dataListArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        PersonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCellTableViewCell"];
        cell.hiddenCheckMark = YES;
        PersonModel *model = [self.dataListArry yk_objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }else{
        SearchContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchContactCell"];
        NSDictionary *data = [self.dataListArry yk_objectAtIndex:indexPath.row];
        cell.data = data;
        return cell;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchController.searchResultsController.view.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        PersonModel *model = [self.dataListArry yk_objectAtIndex:indexPath.row];
        PersonViewController *vc = [[PersonViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.ID = model.friendId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    self.dataListArry = temp.copy;
    [self.tableView reloadData];
#endif
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SearchContactCell class] forCellReuseIdentifier:@"SearchContactCell"];
        [_tableView registerClass:[PersonCellTableViewCell class] forCellReuseIdentifier:@"PersonCellTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchBar *)serchBar {
    if (!_serchBar) {
        _serchBar = [[UISearchBar alloc] init];
        if (self.type == 1) {
            _serchBar.placeholder = @"请输入手机号或昵称搜索";
        }else{
            _serchBar.placeholder = @"请输入手机号搜索";
        }
        _serchBar.searchBarStyle = UISearchBarStyleMinimal;
        _serchBar.delegate = self;
    }
    return _serchBar;
}

- (NSArray *)dataListArry {
    if (!_dataListArry) {
        _dataListArry = @[];
    }
    return _dataListArry;
}
@end
