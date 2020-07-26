//
//  MineViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "MineViewController.h"
#import "NavHeadTitleView.h"
#import "MineCell.h"
#import "MineModel.h"
#import "YKAddition.h"
#import "NormalMineHeader.h"
#import "UserSession.h"
#import "PartnerMineHeader.h"
#import "HistoryViewController.h"
#import "GetTrafficViewController.h"
#import "HelpViewController.h"
#import "CustomServiceViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"
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

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIImageView *backgroundImgV;//背景图
@property(nonatomic,strong)NavHeadTitleView *NavView;//导航栏
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *targetVc;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTopBg];
    //初始化数据源
    [self loadData];
    //创建TableView
    [self createTableView];
    [self createHeader];
    [self createNav];
}

- (void)setTopBg {
    self.backgroundImgV = [[UIImageView alloc] init];
    self.backgroundImgV.image = [UIImage imageNamed:@"usercenter_bg"];
    CGFloat ratio = 414./371.;
    CGFloat height = self.view.width / ratio;
    self.backgroundImgV.frame = CGRectMake(0, 0, self.view.width, height);
    [self.view addSubview:self.backgroundImgV];
}
//创建数据源
-(void)loadData{
    MineModel *record = [[MineModel alloc] initWithIcon:@"setting_record" title:@"我的上课记录"];
    MineModel *invate = [[MineModel alloc] initWithIcon:@"setting_invate" title:@"邀请好友赚无双币"];
//    MineModel *help = [[MineModel alloc] initWithIcon:@"setting_help" title:@"使用帮助"];
    MineModel *kefu = [[MineModel alloc] initWithIcon:@"setting_message" title:@"联系客服"];
    MineModel *feedback = [[MineModel alloc] initWithIcon:@"setting_feedback" title:@"意见反馈"];
    NSArray *datas = @[record,invate,kefu,feedback];
    self.dataSources = datas.mutableCopy;
    [self.tableView reloadData];
}

//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
}

- (void)createHeader {
//    if ([UserSession session].currentUser.level == 1) {//非合伙人
        NormalMineHeader *header = [NormalMineHeader headerView];
        header.frame = CGRectMake(0, 0, self.view.width, 230);
        self.tableView.tableHeaderView = header;
//    }else if ([UserSession session].currentUser.level > 1){
//        PartnerMineHeader *header = [PartnerMineHeader headerView];
//        header.frame = CGRectMake(0, 0, self.view.width, 230);
//        self.tableView.tableHeaderView = header;
//    }
}


-(void)createNav{
    self.NavView= [NavHeadTitleView navView];
    __weak typeof(self) ws = self;
    self.NavView.settingBlock = ^{
        SettingViewController *vc = [[SettingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [ws.navigationController pushViewController:vc animated:YES];
    };
    CGFloat staturBar = 20;
    if (isIphoneX) {
        staturBar = 40;
    }
    self.NavView.frame = CGRectMake(0, 0, self.view.width, 44 + staturBar);
    [self.view addSubview:self.NavView];
}

#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataSources[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = self.targetVc[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        
    if (scrollView.contentOffset.y<=100) {
        CGFloat alpha =scrollView.contentOffset.y/100;
        self.NavView.backgroundColor= [[UIColor whiteColor] colorWithAlphaComponent:alpha];
        //状态栏字体白色
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }else{
        self.NavView.backgroundColor=[UIColor whiteColor];
    }
    
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = @[].mutableCopy;
    }
    return _dataSources;
}

- (NSMutableArray *)targetVc {
    if (!_targetVc) {
        HistoryViewController *historyVc = [[HistoryViewController alloc] init];
        GetTrafficViewController *tfVc = [[GetTrafficViewController alloc] init];
//        HelpViewController *helpVc = [[HelpViewController alloc] init];
        CustomServiceViewController *csVc = [[CustomServiceViewController alloc] init];
        FeedbackViewController *feedbackVc = [[FeedbackViewController alloc] init];
        NSArray *array = @[historyVc,tfVc,csVc,feedbackVc];
        _targetVc = array.mutableCopy;
    }
    return _targetVc;
}

@end
