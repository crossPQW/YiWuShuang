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

@interface AddPersonViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *weChatImage;
@property (nonatomic, strong) UILabel *weChatLabel;
@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type == 1 ? @"添加成员":@"添加学员";
    self.dataSources = @[];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self setupSubviews];
    [self initDataSource];
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
        xingzhi.tag = 100;
        [dataSources addObject:xingzhi];
        [dataSources addObject:[self lineModel]];

        CommonCellModel *content = [[CommonCellModel alloc] init];
        content.height = 65;
        content.style = CellStyleSelectView;
        content.title = @"部门";
        content.tag = 2;
        [dataSources addObject:content];
        [dataSources addObject:[self lineModel]];
        
        CommonCellModel *privacy = [[CommonCellModel alloc] init];
        privacy.height = 65;
        privacy.style = CellStyleSelectView;
        privacy.title = @"权限";
        privacy.tag = 3;
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
        xingzhi.tag = 100;
        [dataSources addObject:xingzhi];
        [dataSources addObject:[self lineModel]];

        CommonCellModel *content = [[CommonCellModel alloc] init];
        content.height = 65;
        content.style = CellStyleSelectView;
        content.title = @"所属部门";
        content.tag = 2;
        [dataSources addObject:content];
        [dataSources addObject:[self lineModel]];
    }
    
    self.dataSources = dataSources.copy;
    [self.tableView reloadData];
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
    [self.view endEditing:YES];
    CommonCellModel *model = self.dataSources[indexPath.row];
    
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
//    switch (textField.tag) {
//        case 1:
//            self.teamName = textField.text;
//            break;
//        case 2:
//            self.content = textField.text;
//            break;
//        case 3:
//            self.userName = textField.text;
//            break;
//        default:
//            break;
//    }
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
@end
