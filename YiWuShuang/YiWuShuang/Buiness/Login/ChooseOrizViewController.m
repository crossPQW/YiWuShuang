//
//  ChooseOrizViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/6.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChooseOrizViewController.h"

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

- (IBAction)createBtnClick:(id)sender {
}
- (IBAction)joinBtnClick:(id)sender {
}

@end
