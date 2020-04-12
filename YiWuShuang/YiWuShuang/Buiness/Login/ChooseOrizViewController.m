//
//  ChooseOrizViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/6.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChooseOrizViewController.h"
#import "CreateOrizViewController.h"
#import "JoinOrizViewController.h"

@interface ChooseOrizViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

@implementation ChooseOrizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createBtn.layer.cornerRadius = 4;
    self.createBtn.layer.masksToBounds = YES;
    
    self.joinBtn.layer.cornerRadius = 4;
    self.joinBtn.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)createBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CreateOrizViewController *chooseVc = [sb instantiateViewControllerWithIdentifier:@"createOri"];
    [self.navigationController pushViewController:chooseVc animated:YES];
}
- (IBAction)joinBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    JoinOrizViewController *chooseVc = [sb instantiateViewControllerWithIdentifier:@"joinOriz"];
    [self.navigationController pushViewController:chooseVc animated:YES];
}

@end
