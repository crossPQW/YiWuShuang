//
//  AddPersonViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import "AddPersonViewController.h"
#import "CommonCellModel.h"
#import "YKAddition.h"
#import "CommonCell.h"
#import "TeamPickView.h"
#import "MBProgressHUD+helper.h"
#import "ApiManager.h"
@interface AddPersonViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TeamPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *weChatImage;
@property (nonatomic, strong) UILabel *weChatLabel;

@property (nonatomic, strong) NSArray *parts;
@property (nonatomic, strong) NSArray *procys;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *partID;
@property (nonatomic, assign) BOOL isManager;

@property (nonatomic, strong) TeamPickView *pickView;
@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type == 1 ? @"添加成员":@"添加学员";
    self.dataSources = @[];
    [self setupSubviews];
    [self initDataSource];
    [self requestParts];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.addBtn = [self createBtnWithTitle:@"添加" action:@selector(add)];
    [self.view addSubview:self.addBtn];
    self.weChatImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wechat44"]];
    [self.view addSubview:self.weChatImage];
    self.weChatLabel = [[UILabel alloc] init];
    self.weChatLabel.text = @"微信邀请";
    self.weChatLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.weChatLabel];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-45);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (self.type == 1) {
            make.height.mas_equalTo(380);
        }else{
            make.height.mas_equalTo(300);
        }
    }];
    
    [self.weChatImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(self.tableView.mas_bottom).offset(80);
    }];
    
    [self.weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.weChatImage.mas_bottom).offset(3);
    }];
}

- (void)add {
    if (!self.name || !self.mobile || !self.teamID) {
        [MBProgressHUD showText:@"请填写完整信息" inView:self.view];
        return;
    }
    NSString *type;
    if (self.type == 1) {
        type = @"1";
    }else{
        type = @"2";
    }
    self.partID = @"12";
    [[ApiManager manager] addMemberWithTeamId:self.teamID partId:self.partID name:self.name mobild:self.mobile type:type isManager:self.isManager success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    if (self.type == 1) {
        CommonCellModel *name = [[CommonCellModel alloc] init];
        name.height = 65;
        name.style = CellStyleInput;
        name.title = @"姓名";
        name.subtitle = @"请输入成员名称";
        name.bgColor = [UIColor whiteColor];
        name.tag = 1;
        [dataSources addObject:name];
        [dataSources addObject:[self lineModel]];
        
        CommonCellModel *xingzhi = [[CommonCellModel alloc] init];
        xingzhi.height = 65;
        xingzhi.style = CellStyleInput;
        xingzhi.title = @"手机";
        xingzhi.subtitle = @"请输入学员手机";
        xingzhi.tag = 2;
        [dataSources addObject:xingzhi];
        [dataSources addObject:[self lineModel]];

        CommonCellModel *content = [[CommonCellModel alloc] init];
        content.height = 65;
        content.style = CellStyleSelectView;
        content.title = @"部门";
        content.tag = 3;
        [dataSources addObject:content];
        [dataSources addObject:[self lineModel]];
        
        CommonCellModel *privacy = [[CommonCellModel alloc] init];
        privacy.height = 65;
        privacy.style = CellStyleSelectView;
        privacy.title = @"权限";
        privacy.tag = 4;
        [dataSources addObject:privacy];
        [dataSources addObject:[self lineModel]];
    }else{
        CommonCellModel *name = [[CommonCellModel alloc] init];
        name.height = 65;
        name.style = CellStyleInput;
        name.title = @"学员姓名";
        name.subtitle = @"请输入学员名称";
        name.bgColor = [UIColor whiteColor];
        name.tag = 1;
        [dataSources addObject:name];
        [dataSources addObject:[self lineModel]];
        
        CommonCellModel *xingzhi = [[CommonCellModel alloc] init];
        xingzhi.height = 65;
        xingzhi.style = CellStyleInput;
        xingzhi.title = @"学员手机";
        xingzhi.subtitle = @"请输入学员手机";
        xingzhi.tag = 2;
        [dataSources addObject:xingzhi];
        [dataSources addObject:[self lineModel]];

        CommonCellModel *content = [[CommonCellModel alloc] init];
        content.height = 65;
        content.style = CellStyleSelectView;
        content.title = @"所属部门";
        content.tag = 3;
        [dataSources addObject:content];
        [dataSources addObject:[self lineModel]];
    }
    
    self.dataSources = dataSources.copy;
    [self.tableView reloadData];
}

- (void)requestParts {
    self.parts = @[@{@"name":@"部门 1"},@{@"name":@" 部门 2"},@{@"name":@" 部门 3"}];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
    if (model.tag == 3) {//部门
        TeamPickView *pickView = [[TeamPickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, self.view.width, 320)];
        pickView.tag = 3;
        self.pickView = pickView;
        pickView.delegate = self;
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        bgView.frame = [UIScreen mainScreen].bounds;
        [bgView addSubview:pickView];
        [[UIApplication sharedApplication].delegate.window addSubview:bgView];
        [pickView setData:self.parts];
    }else if (model.tag == 4){
        
        TeamPickView *pickView = [[TeamPickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, self.view.width, 320)];
        pickView.tag = 4;
        self.pickView = pickView;
        pickView.delegate = self;
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        bgView.frame = [UIScreen mainScreen].bounds;
        [bgView addSubview:pickView];
        [[UIApplication sharedApplication].delegate.window addSubview:bgView];
        [pickView setData:self.procys];
    }
}

#pragma mark - TeamPickerViewDelegate
- (void)didSelectedTeamWithIndex:(NSInteger)index {
    if (self.pickView.tag == 3) {
        NSDictionary *dict = [self.parts yk_objectAtIndex:index];
        NSString *name = [dict stringForKey:@"name"];
        for (CommonCellModel *model in self.dataSources) {
            if (model.tag == 3) {
                model.subtitle = name;
                [self.tableView reloadData];
            }
        }
    }else if (self.pickView.tag == 4){
        if (index == 0) {
            self.isManager = NO;
        }else{
            self.isManager = YES;
        }
        NSDictionary *dict = [self.procys yk_objectAtIndex:index];
        NSString *name = [dict stringForKey:@"name"];
        for (CommonCellModel *model in self.dataSources) {
            if (model.tag == 4) {
                model.subtitle = name;
                [self.tableView reloadData];
            }
        }
    }
    
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
    switch (textField.tag) {
        case 1:
            self.name = textField.text;
            break;
        case 2:
            self.mobile = textField.text;
            break;
        default:
            break;
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

- (NSArray *)parts {
    if (!_parts) {
        _parts = @[];
    }
    return _parts;
}

- (NSArray *)procys {
    return @[@{@"name":@"无管理权限"},@{@"name":@"有管理权限"}];
}
@end
