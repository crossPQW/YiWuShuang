//
//  AddTeamViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/2.
//  Copyright © 2020 huang. All rights reserved.
//

#import "AddTeamViewController.h"
#import "TeamPickView.h"
#import "CommonCell.h"
#import "CommonCellModel.h"
#import "Masonry.h"
#import "YKAddition.h"
#import "ApiManager.h"
#import "UserSession.h"
#import "PersonModel.h"
@interface AddTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TeamPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, strong) TeamPickView *pickView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSArray *teams;

@property (nonatomic, strong) NSString *name;//部门名
@property (nonatomic, strong) NSString *managerID;//管理员 ID
@property (nonatomic, strong) NSString *teamID;//组织 ID
@end

@implementation AddTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建部门";
    self.teams = @[];
    [self setupSubviews];
    [self initDataSource];
    [self requestTeams];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.addBtn = [self createBtnWithTitle:@"完成" action:@selector(add)];
    [self.view addSubview:self.addBtn];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-45);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.addBtn.mas_top);
    }];
}

- (void)add {
    if (!self.teamID || !self.name || !self.managerID) {
        [MBProgressHUD showText:@"请填写完整信息" inView:self.view];
        return;
    }
    [[ApiManager manager] createPartWithTeamID:self.teamID teamName:self.name managerID:self.managerID success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    CommonCellModel *name = [[CommonCellModel alloc] init];
    name.height = 65;
    name.style = CellStyleInput;
    name.title = @"部门名称";
    name.subtitle = @"请输入部门名称";
    name.bgColor = [UIColor whiteColor];
    name.tag = 1;
    [dataSources addObject:name];
    [dataSources addObject:[self lineModel]];
    
    CommonCellModel *xingzhi = [[CommonCellModel alloc] init];
    xingzhi.height = 65;
    xingzhi.style = CellStyleSelectView;
    xingzhi.title = @"部门主管";
    xingzhi.subtitle = @"请选择";
    xingzhi.tag = 2;
    [dataSources addObject:xingzhi];
    [dataSources addObject:[self lineModel]];

    CommonCellModel *content = [[CommonCellModel alloc] init];
    content.height = 65;
    content.style = CellStyleSelectView;
    content.title = @"选择组织";
    content.subtitle = @"请选择";
    content.tag = 3;
    [dataSources addObject:content];
    [dataSources addObject:[self lineModel]];
    
    self.dataSources = dataSources.copy;
    [self.tableView reloadData];
}

- (void)requestTeams {
    [[ApiManager manager] getOrganization:[UserSession session].currentUser.token success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            self.teams = baseModel.data;
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    [self.pickView removeFromSuperview];
    CommonCellModel *model = self.dataSources[indexPath.row];
    if (model.tag == 2) {//主管
        if (self.members.count == 0) {
            self.managerID = nil;
        }else{
            TeamPickView *pickView = [[TeamPickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, self.view.width, 320)];
            pickView.tag = 1;
            self.pickView = pickView;
            pickView.delegate = self;
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            bgView.frame = [UIScreen mainScreen].bounds;
            [bgView addSubview:pickView];
            [[UIApplication sharedApplication].delegate.window addSubview:bgView];
            [pickView setData:self.members];
        }
    }else if (model.tag == 3){
        if (self.teams.count == 0) {
            [MBProgressHUD showText:@"找不到组织" inView:self.view];
            return;
        }
        TeamPickView *pickView = [[TeamPickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, self.view.width, 320)];
        pickView.tag = 2;
        self.pickView = pickView;
        pickView.delegate = self;
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        bgView.frame = [UIScreen mainScreen].bounds;
        [bgView addSubview:pickView];
        [[UIApplication sharedApplication].delegate.window addSubview:bgView];
        [pickView setData:self.teams];
    }
}

- (void)didSelectedTeamWithIndex:(NSInteger)index {
    if (self.pickView.tag == 1) {
        PersonModel *model = [self.members yk_objectAtIndex:index];
        NSString *name = model.nickname;
        self.managerID = model.userID;
        for (CommonCellModel *model in self.dataSources) {
            if (model.tag == 2) {
                model.subtitle = name;
                [self.tableView reloadData];
            }
        }
    }else if (self.pickView.tag == 2){
        NSDictionary *dict = [self.teams yk_objectAtIndex:index];
        NSString *name = [dict stringForKey:@"name"];
        NSString *ID = [dict stringForKey:@"id"];
        self.teamID = ID;
        for (CommonCellModel *model in self.dataSources) {
            if (model.tag == 3) {
                model.subtitle = name;
                [self.tableView reloadData];
            }
        }
    }
    [self.pickView.superview removeFromSuperview];
}

- (void)didDismiss {
    [self.pickView.superview removeFromSuperview];
}

#pragma mark - UITextFiled
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
    if (textField.tag == 1) {
        self.name = textField.text;
    }
}

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
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)createBtnWithTitle:(NSString *)title action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    btn.adjustsImageWhenHighlighted = NO;
    btn.layer.cornerRadius = 4;
    [btn setBackgroundColor:[UIColor colorWithHexRGB:@"#03C1AD"]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (NSArray *)members {
    if (!_members) {
        _members = @[];
    }
    return _members;
}
@end
