//
//  ChoosePartViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/3.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChoosePartViewController.h"
#import "ChoosePartHeader.h"
#import "YKAddition.h"
#import "ChooseTeamCell.h"
#import "ApiManager.h"
#import "ChooseTeamModel.h"
#import "AddTeamViewController.h"

@interface ChoosePartViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ChoosePartHeader *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *parts;//部门列表

@end

@implementation ChoosePartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择部门";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupSubviews];
    [self requestParts];
}

- (void)setupSubviews {
    self.headerView = [ChoosePartHeader partHeader];
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    [self.headerView.actionView addGestureRecognizer:tapHeader];
    self.headerView.userInteractionEnabled = YES;
    self.headerView.teamName.text = self.teamName;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(108);
    }];
    
    UIButton *doneBtn = [self createBtnWithTitle:@"完成" action:@selector(done)];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(doneBtn.mas_top).offset(-10);
    }];
}

- (void)requestParts {
    [[ApiManager manager] getPartsWithTeamID:self.teamID success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            baseModel.data = @[@{@"part_id" : @"1",@"name":@"书法部门"},@{@"part_id" : @"2",@"name":@"舞蹈部门"}];
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[ChooseTeamModel class] json:baseModel.data];
            self.parts = tempArr;
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)tapHeader:(UITapGestureRecognizer *)ges {
    AddTeamViewController *addTeamVc = [[AddTeamViewController alloc] init];
    [self.navigationController pushViewController:addTeamVc animated:YES];
    
}
- (void)done {
    NSString *partID;
    for (ChooseTeamModel *model in self.parts) {
        if (model.isChecked) {
            partID = model.ID;
            break;
        }
    }
    if (!partID) {
        [MBProgressHUD showText:@"请选择要移动的部门" inView:self.view];
        return;
    }
    NSString *type = @"1";//1.成员 2.学员
    [[ApiManager manager] moveMemberWithIDs:self.ids fromTeamID:self.teamID fromPartID:self.partID fromType:type toTeamID:self.teamID toPartID:partID toType:type success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showText:@"操作失败" inView:self.view];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTeamModel *model = [self.parts yk_objectAtIndex:indexPath.row];
    ChooseTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTeamCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mode = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChooseTeamModel *model = [self.parts yk_objectAtIndex:indexPath.row];
    model.isChecked = !model.isChecked;
    if (model.isChecked) {
        for (int i = 0; i < self.parts.count; i++) {
            if (i == indexPath.row) {
                continue;
            }else{
                ChooseTeamModel *model = [self.parts yk_objectAtIndex:i];
                model.isChecked = NO;
            }
        }
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"ChooseTeamCell" bundle:nil] forCellReuseIdentifier:@"ChooseTeamCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)parts {
    if (!_parts) {
        _parts = @[];
    }
    return _parts;
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

- (NSArray *)ids {
    if (!_ids) {
        _ids = @[];
    }
    return _ids;
}
@end
