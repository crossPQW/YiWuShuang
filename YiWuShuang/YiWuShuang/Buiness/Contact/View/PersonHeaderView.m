//
//  PersonHeaderView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/7.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PersonHeaderView.h"
#import "YKAddition.h"
#import <UIImageView+WebCache.h>

@interface PersonHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@end
@implementation PersonHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = self.avatarImage.width * 0.5;
    self.avatarImage.layer.masksToBounds = YES;
}

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PersonHeaderView" owner:self options:nil] lastObject];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:avatar]];
}
@end
