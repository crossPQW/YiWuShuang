//
//  PartnerMineHeader.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/14.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PartnerMineHeader.h"
#import "YKAddition.h"
#import "UserSession.h"

@interface PartnerMineHeader()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UIView *trafficviEW;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@end
@implementation PartnerMineHeader

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PartnerMineHeader" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.trafficviEW.layer.cornerRadius = 5;
    self.trafficviEW.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTraffic)];
    self.trafficviEW.userInteractionEnabled = YES;
    [self.trafficviEW addGestureRecognizer:tap1];
    
    self.accountView.layer.cornerRadius = 5;
    self.accountView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAccount)];
    self.accountView.userInteractionEnabled = YES;
    [self.accountView addGestureRecognizer:tap2];
    
    NSString *avatar = [UserSession session].currentUser.avatar;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatar_defalut"]];
    self.namelabel.text = [UserSession session].currentUser.nickname;
    
    NSInteger level = [UserSession session].currentUser.level;
    NSString *iconName = [NSString stringWithFormat:@"partner_level%ld",level + 1];
    [self.iconImage setImage:[UIImage imageNamed:iconName]];
}

- (void)tapTraffic {
    if (self.tapTrafficBlock) {
        self.tapTrafficBlock();
    }
}

- (void)tapAccount {
    if (self.tapAccountBlock) {
        self.tapAccountBlock();
    }
}
@end
