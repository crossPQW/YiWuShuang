//
//  NormalMineHeader.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import "NormalMineHeader.h"
#import "YKAddition.h"
#import "UserSession.h"

@interface NormalMineHeader()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *partnerBtn;
@property (weak, nonatomic) IBOutlet UIView *trafficView;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;

@property (nonatomic, strong) CAGradientLayer *bgLayer;

@end
@implementation NormalMineHeader

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"NormalMineHeader" owner:self options:nil] lastObject];
}

- (IBAction)tapPartner:(id)sender {
    if (self.clickTrafficBlock) {
        self.clickTrafficBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *avatar = [UserSession session].currentUser.avatar;
//    [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatar]];
    self.nameLabel.text = [UserSession session].currentUser.nickname;
    [self.partnerBtn.layer insertSublayer:self.bgLayer below:self.partnerBtn.imageView.layer];
    self.bgLayer.frame = self.partnerBtn.bounds;
    
    self.partnerBtn.layer.cornerRadius = 15;
    self.partnerBtn.clipsToBounds = YES;
    
    self.avatar.layer.cornerRadius = 33;
    self.avatar.layer.masksToBounds = YES;
    
    self.trafficView.layer.cornerRadius = 5;
    self.trafficView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTraffic)];
    self.trafficView.userInteractionEnabled = YES;
    [self.trafficView addGestureRecognizer:tap];
}

- (void)tapTraffic {
    if (self.requestPartnerBlock) {
        self.requestPartnerBlock();
    }
}
- (CAGradientLayer *)bgLayer {
    if (!_bgLayer) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:253/255.0 green:228/255.0 blue:183/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:242/255.0 green:184/255.0 blue:96/255.0 alpha:1.0].CGColor];        gl.locations = @[@(0), @(1.0f)];
        _bgLayer = gl;
    }
    return _bgLayer;
}
@end
