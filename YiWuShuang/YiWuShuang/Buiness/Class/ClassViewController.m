//
//  ClassViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassTopView.h"
#import "YKAddition.h"
#import "EmptyView.h"
#import "OrderClassCell.h"
#import "StartClassViewController.h"
#import "UserSession.h"
#import "RealAuthView.h"
#import "RealAuthViewController.h"
#import "JoinClassViewController.h"
#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <MessageUI/MessageUI.h>

@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClassTopView *topView;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) RealAuthView *authView;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    ClassTopView *topView = [ClassTopView topView];
    self.topView = topView;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    topView.frame = CGRectMake(0, 0, self.view.width, 110 + statusRect.size.height + 50);
    [self.view addSubview:topView];
    
    topView.tapMessageBlock = ^{
        
    };
    topView.tapAddPersonBlock = ^{
        [weakSelf openShareView];
    };
    topView.tapStartClassBlock = ^{
        StartClassViewController *startVc = [[StartClassViewController alloc] init];
        startVc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:startVc animated:YES];
    };
    topView.tapJoinClassBlock = ^{
        JoinClassViewController *joinVc = [[JoinClassViewController alloc] init];
        joinVc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:joinVc animated:YES];
    };
    topView.tapOrderClassBlock = ^{
        StartClassViewController *startVc = [[StartClassViewController alloc] init];
        startVc.hidesBottomBarWhenPushed = YES;
        startVc.isOrder = YES;
        [weakSelf.navigationController pushViewController:startVc animated:YES];
    };
    
    EmptyView *emptyView = [EmptyView emptyView];
    self.tableView.backgroundView = emptyView;

    [self.view addSubview:self.tableView];
    
}

- (void)openShareView {
    ShareView *shareView = [ShareView shareView];
    self.shareView = shareView;
    shareView.userInteractionEnabled = YES;
    shareView.block = ^(int type) {
        [self shareWithType:type];
    };
    shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 184, self.view.width, 184);
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    bgView.frame = [UIScreen mainScreen].bounds;
    [bgView addSubview:shareView];
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShareBg:)];
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:tapBg];
    [[UIApplication sharedApplication].delegate.window addSubview:bgView];
}

- (void)tapShareBg:(UITapGestureRecognizer *)ges {
    [ges.view removeFromSuperview];
}

- (void)shareWithType:(int)type {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"test"
                                images:@"http://download.sdk.mob.com/web/images/2019/07/30/14/1564468183056/750_750_65.12.png"
                                   url:[NSURL URLWithString:@"http://www.mob.com/"]
                                 title:@"title"
                        type:SSDKContentTypeAuto];
    SSDKPlatformType sharetype;
    if (type == 0) {
        sharetype = SSDKPlatformTypeWechat;
    }else if (type == 1){
        sharetype = SSDKPlatformTypeQQ;
    }else if (type == 2){
        sharetype = SSDKPlatformTypeDingTalk;
    }else if (type == 3){
        //短信
        if ([MFMessageComposeViewController canSendText]) {
            //  判断一下是否支持发送短信，比如模拟器
            MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
            messageVC.body = @"HI，给您推荐一款全景声音视频互动教育 APP， 再送您20分钟高清视频互动流量，双向 48Khz 的音效，无限接近面对面教学体验，赶快来领取吧！https://test.yiwushuang.cn/share/ZWOus2dqbItfXFtoZZmc";
            messageVC.messageComposeDelegate = self;
            [self presentViewController:messageVC animated:YES completion:nil];
        }else{
            [MBProgressHUD showText:@"您的设备不支持发送短信" inView:self.view];
        }
        return;
    }
    
    [ShareSDK share:sharetype parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [self.shareView.superview removeFromSuperview];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //实名认证
//    [self checkAuth];
}

- (void)checkAuth {
    User *user = [[UserSession session] currentUser];
    if (!user.is_realauth) {
        
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
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
//    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [self.list yk_objectAtIndex:indexPath.row];
    OrderClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderClassCell" forIndexPath:indexPath];
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topView.bottom + 10;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, self.view.height - y)];

        [_tableView registerNib:[UINib nibWithNibName:@"OrderClassCell" bundle:nil] forCellReuseIdentifier:@"orderClassCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSArray *)list {
    if (!_list) {
        _list = @[];
    }
    return _list;
}
@end
