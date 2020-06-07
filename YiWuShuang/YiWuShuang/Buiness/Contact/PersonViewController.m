//
//  PersonViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PersonViewController.h"
#import "YKAddition.h"
#import "ClassSettingCell.h"
#import "ClassSettingModel.h"
#import "ClassApiManager.h"
#import "GradientButton.h"
#import "SetNoteViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define isIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
    if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
    isPhoneX = YES;\
    }\
}\
isPhoneX;\
})
@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *note;//备注名
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *source;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasSetNote:) name:@"userHasSetNote" object:nil];
    //创建TableView
    [self createTableView];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[self imageWithImageName:@"autu_back" imageColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.left = 10;
    CGFloat staturBar = 20;
    if (isIphoneX) {
        staturBar = 40;
    }
    backBtn.top = staturBar;
    backBtn.size = CGSizeMake(44, 44);
    [self.view addSubview:backBtn];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setImage:[UIImage imageNamed:@"person_more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.left = self.view.width - 44 - 10;
    moreBtn.top = staturBar;
    moreBtn.size = CGSizeMake(44, 44);
    [self.view addSubview:moreBtn];
    
    GradientButton *bottomBtn = [[GradientButton alloc] init];
    bottomBtn.frame = CGRectMake(18, self.view.height - 64 - 50, self.view.width - 18 * 2, 50);
    [bottomBtn setTitle:@"发起视频" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(startVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    //初始化数据源
    [self loadData];
    [self fetchData];
}

#pragma mark - privite
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)more {
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除联系人" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[ClassApiManager manager] deleteFriendWithID:self.ID success:^(BaseModel * _Nonnull baseModel) {
            if (baseModel.code == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:delete];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)startVideo {
    
}

- (void)fetchData {
    [[ClassApiManager manager] getFriendDetailWithID:self.ID success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = baseModel.data;
                self.avatar = [dict stringForKey:@"avatar"];
                self.phoneNumber = [dict stringForKey:@"mobile"];
                self.nickName = [dict stringForKey:@"nickname"];
                self.note = [dict stringForKey:@"note"];
                self.addTime = [dict stringForKey:@"create_at"];
                self.source = [dict stringForKey:@"source"];
                
                [self loadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)userHasSetNote:(NSNotification *)noti {
    NSString *note = [noti.userInfo stringForKey:@"name"];
    self.note = note;
    [self loadData];
}

//创建数据源
-(void)loadData{
    NSMutableArray *dataSources = @[].mutableCopy;

    ClassSettingModel *header = [[ClassSettingModel alloc] init];
    header.title = self.nickName;
    header.subtitle = self.avatar;
    header.height = 234;
    header.style = ClassSettingModelPersonHeader;
    [dataSources addObject:header];
    
    ClassSettingModel *phone = [[ClassSettingModel alloc] init];
    phone.height = 61;
    phone.style = ClassSettingModelSubtitle;
    phone.title = @"手机号码";
    phone.subtitle = self.phoneNumber;
    phone.subtitleColor = [UIColor colorWithHexRGB:@"#15C3D6"];
    [dataSources addObject:phone];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *nickName = [[ClassSettingModel alloc] init];
    nickName.height = 61;
    nickName.tag = 3;
    nickName.style = ClassSettingModelSelect;
    nickName.title = @"设置昵称";
    nickName.subtitle = self.note;
    [dataSources addObject:nickName];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *date = [[ClassSettingModel alloc] init];
    date.height = 61;
    date.style = ClassSettingModelSubtitle;
    date.title = @"添加时间";
    date.subtitle = self.addTime;
    [dataSources addObject:date];
    [dataSources addObject:[self lineModel]];
    
    ClassSettingModel *source = [[ClassSettingModel alloc] init];
    source.height = 61;
    source.style = ClassSettingModelSubtitle;
    source.title = @"来源";
    source.subtitle = self.source;
    [dataSources addObject:source];
    [dataSources addObject:[self lineModel]];
    
    self.dataSources = dataSources.copy;
    [self.tableView reloadData];
}

//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ClassSettingCell class] forCellReuseIdentifier:@"cell"];
        _tableView.scrollEnabled = NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
}


#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassSettingModel *model = self.dataSources[indexPath.row];
    return model.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ClassSettingModel *model = self.dataSources[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassSettingModel *model = self.dataSources[indexPath.row];
    if (model.tag == 3) {
        SetNoteViewController *vc = [[SetNoteViewController alloc] init];
        vc.ID = self.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (ClassSettingModel *)lineModel {
    ClassSettingModel *line = [[ClassSettingModel alloc] init];
    line.height = 1;
    line.style = ClassSettingModelStyleLine;
    return line;
}

- (UIImage *)imageWithImageName:(NSString *)name imageColor:(UIColor *)imageColor {
    UIImage *image = [UIImage imageNamed:name];;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [imageColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end
