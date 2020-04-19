//
//  CreateOrizViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/12.
//  Copyright © 2020 huang. All rights reserved.
//

#import "CreateOrizViewController.h"
#import "MBProgressHUD+helper.h"
#import "ApiManager.h"
#import "User.h"
#import "UserSession.h"
#import "YKAddition.h"
#import "CommonCellModel.h"
#import "UIView+DYKIOS.h"
#import "CommonCell.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
@interface CreateOrizViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (nonatomic, strong) NSString *oriID;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;

//组织名
@property (nonatomic, strong) NSString *teamName;
//组织性质
@property (nonatomic, strong) NSString *teamNature;
//培训内容
@property (nonatomic, strong) NSString *content;
//联系人姓名
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSArray *natureList;
@property (nonatomic, strong) NSArray *dataSources;
@end

@implementation CreateOrizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishBtn.layer.cornerRadius = 4;
    self.finishBtn.layer.masksToBounds = YES;
    
    self.title = @"创建组织";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self getOrgId];
    [self getNatureList];
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)finishBtnClick:(id)sender {
    User *user =[[UserSession session] currentUser];
    if (!user.token || !self.oriID || !self.teamNature || !self.content || !self.userName || !self.teamName) {
        [MBProgressHUD showText:@"请填写完整信息" inView:self.view];
        return;
    }
    [[ApiManager manager] fillOrganizationInfo:user.token
                                        teamId:self.oriID
                                         catId:self.teamNature
                                       educate:self.content
                                       manager:self.userName
                                          name:self.teamName
                                       success:^(BaseModel * _Nonnull baseModel) {
        NSDictionary *dict = baseModel.data;
        if (dict) {
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getOrgId {
    User *user =[[UserSession session] currentUser];
    [[ApiManager manager] getOrganizationID:user.token success:^(BaseModel * _Nonnull baseModel) {
        NSDictionary *data = baseModel.data;
        NSString *ID = [data stringForKey:@"team_id"];
        if (ID) {
            self.oriID = ID;
            [self initDataSource];
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)getNatureList {
    [[ApiManager manager] getNatureList:[[UserSession session] currentUser].token success:^(BaseModel * _Nonnull baseModel) {
        NSArray *list = baseModel.data;
        if ([list isKindOfClass:[NSArray class]]) {
            self.natureList = [NSArray arrayWithArray:list];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)initTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.finishBtn.top);
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
    
    CommonCellModel *xingzhi = [[CommonCellModel alloc] init];
    xingzhi.height = 65;
    xingzhi.style = CellStyleSelectView;
    xingzhi.title = @"组织性质";
    xingzhi.subtitle = @"高等院校";
    xingzhi.tag = 100;
    [dataSources addObject:xingzhi];
    [dataSources addObject:[self lineModel]];

    CommonCellModel *content = [[CommonCellModel alloc] init];
    content.height = 65;
    content.style = CellStyleInput;
    content.title = @"培训内容";
    content.tag = 2;
    content.subtitle = @"例如钢琴";
    [dataSources addObject:content];
    [dataSources addObject:[self lineModel]];
    
    CommonCellModel *ID = [[CommonCellModel alloc] init];
    ID.height = 65;
    ID.style = CellStyleOriz;
    ID.title = @"组织ID";
    ID.subtitle = self.oriID;
    [dataSources addObject:ID];
    
    CommonCellModel *line = [[CommonCellModel alloc] init];
    line.height = 7;
    line.style = CellStyleSpace;
    line.bgColor = [UIColor colorWithHexRGB:@"#F5F7FA"];
    [dataSources addObject:line];
    
    CommonCellModel *userName = [[CommonCellModel alloc] init];
    userName.height = 65;
    userName.style = CellStyleInput;
    userName.title = @"联系人姓名";
    userName.subtitle = @"请输入您的姓名";
    userName.tag = 3;
    userName.bgColor = [UIColor whiteColor];
    [dataSources addObject:userName];
    [dataSources addObject:[self lineModel]];
    
    CommonCellModel *phone = [[CommonCellModel alloc] init];
    phone.height = 65;
    phone.style = CellStyleInput;
    phone.title = @"联系人手机";
    phone.subtitle = [[UserSession session] currentUser].nickname;
    phone.bgColor = [UIColor whiteColor];
    phone.tag = 4;
    [dataSources addObject:phone];
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
    CommonCellModel *model = self.dataSources[indexPath.row];
    if (model.tag == 100) {
        [self.view endEditing:YES];
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.height - 300, self.view.width, 300)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.view addSubview:self.pickerView];
    }
}

#pragma mark - pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.natureList.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dict = self.natureList[row];
    NSString *name = [dict stringForKey:@"name"];
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *dict = self.natureList[row];
    NSString *ID = [dict stringForKey:@"id"];
    NSString *name = [dict stringForKey:@"name"];
    self.teamNature = ID;
    [pickerView removeFromSuperview];
    
    for (CommonCellModel *model in self.dataSources) {
        if (model.tag == 100) {
            model.subtitle = name;
            [self.tableView reloadData];
        }
    }
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
            self.content = textField.text;
            break;
        case 3:
            self.userName = textField.text;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pickerView removeFromSuperview];
    [self.view endEditing:YES];
}
@end
