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

@interface StartClassViewController ()<UITableViewDelegate,UITableViewDataSource, TeamPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) GradientButton *startClassBtn;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, strong) NSString *classID;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *stuCount;
@property (nonatomic, strong) NSString *clearly;
@property (nonatomic, assign) BOOL isOpenMic;
@property (nonatomic, assign) BOOL isOpenCamera;
@property (nonatomic, assign) BOOL isOpenSmartMic;

@property (nonatomic, strong) TeamPickView *pickview;
@property (nonatomic, strong) NSArray *countList;
@end

@implementation StartClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起课程";
    [self.navigationController setNavigationBarHidden:NO];
    
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
    
    //default
    self.clearly = @"超清";
    self.stuCount = @"1";
    self.isOpenSmartMic = YES;
}

- (void)startClass {
    if (!self.classID) {
        [MBProgressHUD showText:@"未找到课程ID" inView:self.view];
        return;
    }
    if (!self.className) {
        [MBProgressHUD showText:@"请输入课程名称" inView:self.view];
        return;
    }
    [[ClassApiManager manager] creatClassWithID:self.classID name:self.className number:self.stuCount ratio:self.clearly type:1 start_at:nil isCamera:self.isOpenCamera isMic:self.isOpenMic isSmartMic:self.isOpenSmartMic success:^(BaseModel * _Nonnull baseModel) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
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
    title.title = @"课程名称";
    [dataSources addObject:title];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *stuCount = [[ClassSettingModel alloc] init];
    stuCount.height = 60;
    stuCount.style = ClassSettingModelSelect;
    stuCount.title = @"上课人员";
    stuCount.subtitle = @"1人";
    stuCount.tag = 1;
    [dataSources addObject:stuCount];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *classID = [[ClassSettingModel alloc] init];
    classID.height = 60;
    classID.style = ClassSettingModelCopy;
    classID.title = @"课程ID";
    classID.subtitle = self.classID;
    [dataSources addObject:classID];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *video = [[ClassSettingModel alloc] init];
    video.height = 60;
    video.style = ClassSettingModelSelect;
    video.title = @"视频分辨率";
    video.subtitle = @"1080P";
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
    smartMic.btnImg = @"class_notice";
    smartMic.switchOn = self.isOpenSmartMic;
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
        case 1:
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
            [pickview setData:self.countList];
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
            break;
        default:
            break;
    }
}

- (void)didSelectedTeamWithIndex:(NSInteger)index {
    if (self.pickview.tag == 1) {
        NSDictionary *dict = [self.countList yk_objectAtIndex:index];
        NSString *count = [dict stringForKey:@"data"];
        self.stuCount = count;
    }else if (self.pickview.tag == 2){
        NSDictionary *dict = [[self clearlyList] yk_objectAtIndex:index];
        NSString *clearly = [dict stringForKey:@"data"];
        self.clearly = clearly;
    }
    [self.pickview.superview removeFromSuperview];
}

- (void)didDismiss {
    [self.pickview.superview removeFromSuperview];
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


- (NSArray *)countList {
    if (!_countList) {
        NSMutableArray *array = @[].mutableCopy;
        for (int i = 0; i<100; i++) {
            NSString *name = [NSString stringWithFormat:@"%d人",i+1];
            NSString *count = [NSString stringWithFormat:@"%d",i+1];
            NSDictionary *data = @{@"name":name,@"data":count};
            [array yk_addObject:data];
        }
        _countList = array;
    }
    return _countList;
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
@end