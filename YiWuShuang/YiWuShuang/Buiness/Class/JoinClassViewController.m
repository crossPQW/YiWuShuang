//
//  JoinClassViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "JoinClassViewController.h"
#import "ClassSettingCell.h"
#import "ClassSettingModel.h"
#import "YKAddition.h"
#import "ClassApiManager.h"
#import "GradientButton.h"
#import "TeamPickView.h"
#import "UserSession.h"
#import "RealAuthViewController.h"
#import "RealAuthView.h"
@interface JoinClassViewController ()<UITableViewDelegate,UITableViewDataSource, TeamPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;

@property (nonatomic, assign) BOOL isOpenMic;
@property (nonatomic, assign) BOOL isOpenCamera;
@property (nonatomic, assign) BOOL isOpenSmartMic;
@property (nonatomic, strong) NSString *classID;

@property (nonatomic, strong) RealAuthView *authView;
@end

@implementation JoinClassViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入课程";
    self.isOpenSmartMic = YES;
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self initDataSource];
}

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    
    ClassSettingModel *notice = [[ClassSettingModel alloc] init];
    notice.height = 155;
    notice.tag = 1;
    notice.style = ClassSettingModelJoin;
    [dataSources addObject:notice];
    
    ClassSettingModel *space = [[ClassSettingModel alloc] init];
    space.height = 7;
    space.style = ClassSettingModelStyleSpace;
    [dataSources addObject:space];
    
    ClassSettingModel *mic = [[ClassSettingModel alloc] init];
    mic.height = 60;
    mic.style = ClassSettingModelSwitch;
    mic.title = @"开启麦克风";
    mic.tag = 3;
    [dataSources addObject:mic];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *camera = [[ClassSettingModel alloc] init];
    camera.height = 60;
    camera.style = ClassSettingModelSwitch;
    camera.title = @"开启摄像头";
    camera.tag = 4;
    [dataSources addObject: camera];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *smartMic = [[ClassSettingModel alloc] init];
    smartMic.height = 60;
    smartMic.style = ClassSettingModelButton;
    smartMic.title = @"智麦";
    smartMic.tag = 5;
    smartMic.switchOn = self.isOpenSmartMic;
    NSString *img = self.isOpenSmartMic ? @"class_smartMic_able" : @"class_smartMic_enable";
    smartMic.btnImg = img;
    [dataSources addObject: smartMic];
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
    ClassSettingModel *model = self.dataSources[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ClassSettingModel *model = self.dataSources[indexPath.row];
    cell.model = model;
    cell.clickBlock = ^(ClassSettingModel * _Nonnull model) {
        [self handleCellClick:model indexPath:indexPath];
    };
    return cell;;
}

- (void)handleCellClick:(ClassSettingModel *)model indexPath:(NSIndexPath *)indexPath
{
    switch (model.tag) {
        case 1:
        {
            self.classID = model.title;
            [self joinClass];
        }
            break;
        case 3:
        {
            self.isOpenMic = model.switchOn;
        }
            break;
        case 4:
        {
            self.isOpenCamera = model.switchOn;
        }
            break;
        case 5:
        {
            self.isOpenSmartMic = model.switchOn;
            [self initDataSource];
        }
            break;
        default:
            break;
    }
}

- (void)joinClass {
    User *user = [[UserSession session] currentUser];
    if (!user.is_realauth) {
        [self showAuth];
        return;
    }
    
    if (!self.classID) {
        [MBProgressHUD showText:@"请输入课程ID" inView:self.view];
        return;
    }
    [[ClassApiManager manager] joinClassWithID:self.classID success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            [MBProgressHUD showText:@"加入成功" inView:self.view];
        }else{
            NSString *errorMsg = baseModel.msg;
            [MBProgressHUD showText:errorMsg inView:self.view];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)showAuth {
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
#pragma mark - getter
- (ClassSettingModel *)lineModel {
    ClassSettingModel *line = [[ClassSettingModel alloc] init];
    line.height = 1;
    line.style = ClassSettingModelStyleLine;
    return line;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ClassSettingCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate =self;
        _tableView.dataSource =self;
//        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
