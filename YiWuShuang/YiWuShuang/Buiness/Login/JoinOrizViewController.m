//
//  JoinOrizViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/12.
//  Copyright © 2020 huang. All rights reserved.
//

#import "JoinOrizViewController.h"
#import "CommonCellModel.h"
#import "YKAddition.h"
#import "CommonCell.h"
#import "ApiManager.h"
#import "UserSession.h"
#import "MBProgressHUD+helper.h"
#import "HomeViewController.h"

@interface JoinOrizViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (nonatomic, strong) NSArray *dataSources;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamID;
@end

@implementation JoinOrizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishBtn.layer.cornerRadius = 4;
    self.finishBtn.layer.masksToBounds = YES;
    self.title = @"创建组织";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [self initTableView];
    [self initDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.finishBtn.top);
}

- (IBAction)finishBtnClick:(id)sender {
    User *user =[[UserSession session] currentUser];
    if (!user.token || !self.teamID || !self.teamName) {
        [MBProgressHUD showText:@"请填写完整信息" inView:self.view];
        return;
    }
    [[ApiManager manager] joinTeam:[[UserSession session] currentUser].token
                            teamId:self.teamID
                              name:self.teamName
                           success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            [self jumpToMain];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

- (void)jumpToMain {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    HomeViewController *rootVc = [[HomeViewController alloc] init];
    [window setRootViewController:rootVc];
    [window makeKeyAndVisible];
}

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    
    CommonCellModel *topLine = [[CommonCellModel alloc] init];
    topLine.height = 7;
    topLine.style = CellStyleSpace;
    topLine.bgColor = [UIColor colorWithHexRGB:@"#F5F7FA"];
    [dataSources addObject:topLine];
    
    CommonCellModel *name = [[CommonCellModel alloc] init];
    name.height = 65;
    name.style = CellStyleInput;
    name.title = @"组织名称";
    name.subtitle = @"请输入组织名称";
    name.bgColor = [UIColor whiteColor];
    name.tag = 1;
    [dataSources addObject:name];
    CommonCellModel *line1 = [self lineModel];
    [dataSources addObject:line1];
    
   CommonCellModel *teamId = [[CommonCellModel alloc] init];
   teamId.height = 65;
   teamId.style = CellStyleInput;
   teamId.title = @"请输入组织ID";
   teamId.subtitle = @"请输入组织ID";
   teamId.bgColor = [UIColor whiteColor];
   teamId.tag = 2;
   [dataSources addObject:teamId];
   [dataSources addObject:[self lineModel]];

    
    self.dataSources = dataSources.copy;
    [self.tableView reloadData];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCellModel *model = self.dataSources[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
    cell.inputTextField.delegate = self;
    CommonCellModel *model = self.dataSources[indexPath.row];
    cell.model = model;
    return cell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    [self handleReturnWithTextField:textField];
    return YES;;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self handleReturnWithTextField:textField];
    return YES;;
}

- (void)handleReturnWithTextField:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            self.teamName = textField.text;
            break;
        case 2:
            self.teamID = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - getter
- (CommonCellModel *)lineModel {
    CommonCellModel *line = [[CommonCellModel alloc] init];
    line.height = 1;
    line.style = CellStyleLine;
    line.bgColor = [UIColor colorWithHexRGB:@"##EDEFF2"];
    return line;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[CommonCell class] forCellReuseIdentifier:@"commonCell"];
        _tableView.delegate =self;
        _tableView.dataSource =self;
//        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
