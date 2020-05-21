//
//  HomeTopView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "HomeTopView.h"
#import "UIColor+Addition.h"
#import "Masonry.h"
#import "UIImageView+YYWebImage.h"
#import "NSDictionary+Addition.h"
#import "UserSession.h"

@interface HomeTopView()
@property (strong, nonatomic)  UIImageView *avatarImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *flowLabel;

@end
@implementation HomeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.avatarImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.managericon];
        [self addSubview:self.flowLabel];
        
        User *user = [UserSession session].currentUser;
        [self.avatarImage setImageWithURL:[NSURL URLWithString:user.avatar] placeholder:[UIImage imageNamed:@"avatar_default"]];
        self.nameLabel.text = user.nickname;
        self.flowLabel.text = @"剩余流量45,433分钟";
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.mas_left).offset(15);
    }];
  
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImage.mas_right).offset(3);
        make.centerY.equalTo(self.mas_centerY);
    }];
  
    [self.managericon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(3);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(55, 20));
    }];
      
    [self.flowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.left.greaterThanOrEqualTo(self.managericon.mas_right).offset(10);
    }];
}

- (void)fillData:(NSDictionary *)data {
    BOOL ismanager = [data boolForKey:@"is_manager"];
    self.managericon.hidden = !ismanager;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] init];
    }
    return _avatarImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textColor = [UIColor colorWithHexRGB:@"#303033"];
    }
    return _nameLabel;
}

- (UIButton *)managericon {
    if (!_managericon) {
        _managericon = [[UIButton alloc] init];
        [_managericon setTitle:@"管理员" forState:UIControlStateNormal];
        [_managericon setTitleColor:[UIColor colorWithHexRGB:@"#03C1AD"] forState:UIControlStateNormal];
        [_managericon.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _managericon.layer.borderColor = [UIColor colorWithHexRGB:@"#03C1AD"].CGColor;
        _managericon.layer.borderWidth = 1;
        _managericon.layer.cornerRadius = 10;
    }
    return _managericon;
}

- (UILabel *)flowLabel {
    if (!_flowLabel) {
        _flowLabel = [[UILabel alloc] init];
        _flowLabel.textAlignment = NSTextAlignmentRight;
    }
    return _flowLabel;
}
@end
