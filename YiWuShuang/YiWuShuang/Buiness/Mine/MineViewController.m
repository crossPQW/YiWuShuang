//
//  MineViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "MineViewController.h"
#import "NavHeadTitleView.h"
#import "YKAddition.h"
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

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBg];
    //初始化数据源
    [self loadData];
    //创建TableView
    [self createTableView];
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

}

//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
}


-(void)createNav{
    self.NavView= [NavHeadTitleView navView];
    CGFloat staturBar = 20;
    if (isIphoneX) {
        staturBar = 40;
    }
    self.NavView.frame = CGRectMake(0, 0, self.view.width, 44 + staturBar);
    [self.view addSubview:self.NavView];
}

#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusID];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y<=170) {
        CGFloat alpha =scrollView.contentOffset.y/170;
        self.NavView.backgroundColor= [[UIColor whiteColor] colorWithAlphaComponent:alpha];
        //状态栏字体白色
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }else{
        self.NavView.backgroundColor=[UIColor whiteColor];
        //隐藏黑线
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//        //状态栏字体黑色
//        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    }
    
}

@end
