//
//  StartClassViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/16.
//  Copyright © 2020 huang. All rights reserved.
//

#import "StartClassViewController.h"
#import "ClassSettingCell.h"
#import "ClassSettingModel.h"
#import "YKAddition.h"
#import "ClassApiManager.h"
#import "GradientButton.h"
#import "TeamPickView.h"
#import "ChooseStudentViewController.h"
#import "BaseNavigationController.h"
#import "UserSession.h"
#import "RealAuthViewController.h"
#import "RealAuthView.h"
@interface StartClassViewController ()<UITableViewDelegate,UITableViewDataSource, TeamPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) GradientButton *startClassBtn;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, strong) NSString *classID;
@property (nonatomic, strong) NSString *classType;//1： 1 对 1， 2：1 对 16
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *stuCount;
@property (nonatomic, strong) NSString *stuIds;
@property (nonatomic, strong) NSString *clearly;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, assign) BOOL isOpenMic;
@property (nonatomic, assign) BOOL isOpenCamera;
@property (nonatomic, assign) BOOL isOpenSmartMic;

@property (nonatomic, strong) UIDatePicker *datePikcer;
@property (nonatomic, strong) TeamPickView *pickview;

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *unique_id;

@property (nonatomic, strong) RealAuthView *authView;
@end

@implementation StartClassViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起课程";
    if (self.isOrder) {
        self.title = @"预约课程";
    }
    
    
    //default
    self.clearly = @"超清";
    self.stuCount = @"1";
    self.isOpenSmartMic = YES;

    
    self.startClassBtn.layer.cornerRadius = 4;
    self.startClassBtn.layer.masksToBounds = YES;
    self.startClassBtn = [[GradientButton alloc] initWithFrame:CGRectMake(18, self.view.height - 64 - 50, self.view.width - 36, 50)];
    [self.startClassBtn setTitle:@"开始上课" forState:UIControlStateNormal];
    [self.startClassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startClassBtn addTarget:self action:@selector(startClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startClassBtn];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.startClassBtn.top);
    [self initDataSource];
    [[ClassApiManager manager] getClassIDSuccess:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            if ([baseModel.data isKindOfClass:[NSString class]]) {
                self.classID = baseModel.data;
                [self initDataSource];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseStudent:) name:@"hasChooseStudent" object:nil];
}

- (void)chooseStudent:(NSNotification *)noti {
    int count = [noti.userInfo intForKey:@"count"];
    self.stuIds = [noti.userInfo stringForKey:@"ids"];
    self.stuCount = [NSString stringWithFormat:@"%d",count];
    [self initDataSource];
}

- (void)startClass {
    User *user = [[UserSession session] currentUser];
    if (!user.is_realauth) {
        [self showAuth];
        return;
    }
    
    if (!self.classID) {
        [MBProgressHUD showText:@"未找到课程ID" inView:self.view];
        return;
    }
    if (!self.className) {
        [MBProgressHUD showText:@"请输入课程名称" inView:self.view];
        return;
    }
    int type = 1;
    if (self.isOrder) {
        type = 2;
    }
    [[ClassApiManager manager] creatClassWithID:self.classID name:self.className number:self.stuIds ratio:self.clearly type:type playType:self.classType.intValue start_at:self.orderTime isCamera:self.isOpenCamera isMic:self.isOpenMic isSmartMic:self.isOpenSmartMic success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)baseModel.data;
                self.course_id = [data stringForKey:@"course_id"];
                self.unique_id = [data stringForKey:@"unique_id"];
                [MBProgressHUD showText:@"创建课程成功" inView:self.view];
            }
        }else{
            NSString *errstr = baseModel.msg;
            [MBProgressHUD showText:errstr inView:self.view];
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

- (void)initDataSource {
    NSMutableArray *dataSources = @[].mutableCopy;
    
    ClassSettingModel *notice = [[ClassSettingModel alloc] init];
    notice.height = 42;
    notice.style = ClassSettingModelStyleNotice;
    [dataSources addObject:notice];
    
    ClassSettingModel *title = [[ClassSettingModel alloc] init];
    title.height = 100;
    title.style = ClassSettingModelTitle;
    title.tag = -1;
    title.title = @"课程名称";
    [dataSources addObject:title];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *classType = [[ClassSettingModel alloc] init];
    classType.height = 60;
    classType.style = ClassSettingModelSelect;
    classType.title = @"课程类型";
    NSString *type;
    if ([self.classType isEqualToString:@"1"]) {
        type = @"1对16人以内(互动直播)";
    }else if ([self.classType isEqualToString:@"2"]){
        type = @"1对16人以上(普通直播)";
    }
    classType.subtitle = type ?: @"请选择";
    classType.tag = 66;
    [dataSources addObject:classType];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *stuCount = [[ClassSettingModel alloc] init];
    stuCount.height = 60;
    stuCount.style = ClassSettingModelSelect;
    stuCount.title = @"上课人员";
    stuCount.subtitle = self.stuCount ?: @"请选择";
    stuCount.tag = 1;
    [dataSources addObject:stuCount];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *classID = [[ClassSettingModel alloc] init];
    classID.height = 60;
    classID.style = ClassSettingModelCopy;
    classID.title = @"课程ID";
    classID.subtitle = self.classID;
    [dataSources addObject:classID];
    
    ClassSettingModel *space = [[ClassSettingModel alloc] init];
    space.height = 7;
    space.style = ClassSettingModelStyleSpace;
    [dataSources addObject:space];
    
    if (self.isOrder) {
        ClassSettingModel *time = [[ClassSettingModel alloc] init];
        time.height = 60;
        time.style = ClassSettingModelSelect;
        time.title = @"开始时间";
        time.subtitle = @"请选择时间";
        if (self.orderTime) {
            time.subtitle = self.orderTime;
        }
        time.tag = 10;
        [dataSources addObject:time];
        
        ClassSettingModel *space2 = [[ClassSettingModel alloc] init];
        space2.height = 7;
        space2.style = ClassSettingModelStyleSpace;
        [dataSources addObject:space2];
    }
    
    ClassSettingModel *video = [[ClassSettingModel alloc] init];
    video.height = 60;
    video.style = ClassSettingModelSelect;
    video.title = @"视频分辨率";
    video.subtitle = self.clearly ?: @"请选择";
    video.tag = 2;
    [dataSources addObject:video];
    [dataSources addObject:[self lineModel]];
    
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

- (void)handleCellClick:(ClassSettingModel *)model indexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    switch (model.style) {
        case ClassSettingModelStyleNotice:
        {
            NSMutableArray *tempSource = self.dataSources.mutableCopy;
            for (ClassSettingModel *model in tempSource) {
                if (model.style == ClassSettingModelStyleNotice) {
                    [tempSource removeObject:model];
                    break;
                }
            }
            self.dataSources = [tempSource copy];
            [self.tableView reloadData];
        }
            break;
        case ClassSettingModelTitle:
        {
            self.className = model.subtitle;
        }
            break;
        default:
            break;
    }
    
    switch (model.tag) {
        case 66:{
            TeamPickView *pickview = [[TeamPickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, self.view.width, 320)];
            pickview.tag = model.tag;
            self.pickview = pickview;
            pickview.delegate = self;
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            bgView.frame = [UIScreen mainScreen].bounds;
            [bgView addSubview:pickview];
            [[UIApplication sharedApplication].delegate.window addSubview:bgView];
            [pickview setData:[self classTypeList]];

        }
            break;
        case 1:
        {
            ChooseStudentViewController *chooseVc = [[ChooseStudentViewController alloc] init];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:chooseVc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            TeamPickView *pickview = [[TeamPickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, self.view.width, 320)];
            pickview.tag = model.tag;
            self.pickview = pickview;
            pickview.delegate = self;
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            bgView.frame = [UIScreen mainScreen].bounds;
            [bgView addSubview:pickview];
            [[UIApplication sharedApplication].delegate.window addSubview:bgView];
            [pickview setData:[self clearlyList]];
        }
            break;
        case 3:
            self.isOpenMic = model.switchOn;
            break;
        case 4:
            self.isOpenCamera = model.switchOn;
            break;
        case 5:
            self.isOpenSmartMic = model.switchOn;
            [self initDataSource];
            break;
        case 10:
            [self handleSelectTimeWithModel:model];
            break;
        default:
            break;
    }
}

- (void)didSelectedTeamWithIndex:(NSInteger)index {
    if (self.pickview.tag == 2){
        NSDictionary *dict = [[self clearlyList] yk_objectAtIndex:index];
        NSString *clearly = [dict stringForKey:@"data"];
        self.clearly = clearly;
    }else if (self.pickview.tag == 66){
        NSDictionary *dict = [[self classTypeList] yk_objectAtIndex:index];
        NSString *classType = [dict stringForKey:@"data"];
        self.classType = classType;
    }
    [self initDataSource];
    [self.pickview.superview removeFromSuperview];
}

- (void)didDismiss {
    [self.pickview.superview removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)handleSelectTimeWithModel:(ClassSettingModel *)model {
    self.datePikcer = [[UIDatePicker alloc] init];
    self.datePikcer.frame = CGRectMake(0, self.view.height - 300, self.view.width, 300);
    self.datePikcer.backgroundColor = [UIColor whiteColor];
    self.datePikcer.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePikcer.datePickerMode = UIDatePickerModeDateAndTime;
    [self.datePikcer setDate:[NSDate date] animated:YES];
    [self.datePikcer addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.frame = CGRectMake(0, self.view.height - 300 - 47, self.view.width, 47);
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 52, 47);
    [btnView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] init];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(self.view.width - 52, 0, 52, 47);
    [doneBtn setTitleColor:[UIColor colorWithHexRGB:@"#03C1AD"] forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [doneBtn addTarget:self action:@selector(didClickDonelBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:doneBtn];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    bgView.frame = [UIScreen mainScreen].bounds;
    [bgView addSubview:btnView];
    [bgView addSubview:self.datePikcer];
    [[UIApplication sharedApplication].delegate.window addSubview:bgView];
}

- (void)dateChange:(UIDatePicker *)picker {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年/MM月/dd日 HH:mm";
    NSString *dataStr = [format stringFromDate:picker.date];
    self.orderTime = dataStr;
}

- (void)didClickCancelBtn {
    [self.datePikcer.superview removeFromSuperview];
}
- (void)didClickDonelBtn {
    [self initDataSource];
    [self.datePikcer.superview removeFromSuperview];
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

- (NSArray *)clearlyList {
    return @[@{@"name":@"超清1080P",
               @"data":@"超清",},
             @{@"name":@"高清720P",
               @"data":@"高清",},
             @{@"name":@"标清480P",
               @"data":@"标清",},
    ];
}

- (NSArray *)classTypeList {
    return @[@{@"name":@"1对16人以内(互动直播)",
               @"data":@"1",},
             @{@"name":@"1对16人以上(普通直播)",
               @"data":@"2",},
    ];
}
@end
