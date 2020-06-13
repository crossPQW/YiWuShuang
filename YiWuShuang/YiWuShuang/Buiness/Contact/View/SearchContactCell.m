//
//  SearchContactCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/13.
//  Copyright © 2020 huang. All rights reserved.
//

#import "SearchContactCell.h"
#import "YKAddition.h"
#import "GradientButton.h"
@interface SearchContactCell()
@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GradientButton *btn;
@end
@implementation SearchContactCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatarImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.btn];
        self.data = @{};
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    NSString *mobile = [data stringForKey:@"mobile"];
    self.titleLabel.text = mobile;
    NSInteger status = [data integerForKey:@"status"];
    if (status == 0) {
        [self.btn setTitle:@"邀请" forState:UIControlStateNormal];
    }else if (status == 1){
        [self.btn setTitle:@"添加" forState:UIControlStateNormal];
    }else{
        [self.btn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor grayColor]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarImage.size = CGSizeMake(40, 40);
    self.avatarImage.image = [UIImage imageNamed:@"avatar_default"];
    self.avatarImage.left = 18;
    self.avatarImage.centerY = self.contentView.height/2;
    
    self.btn.size = CGSizeMake(60, 28);
    self.btn.right = self.contentView.width - 18;
    self.btn.centerY = self.avatarImage.centerY;
    
    self.titleLabel.left = self.avatarImage.right + 10;
    self.titleLabel.width = self.btn.left - self.titleLabel.left;
    self.titleLabel.height = self.contentView.height;
    self.titleLabel.centerY = self.avatarImage.centerY;
}

- (void)tapBtn {
    if (self.block) {
        self.block();
    }
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.layer.cornerRadius = 20;
    }
    return _avatarImage;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexRGB:@"#303033"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (GradientButton *)btn {
    if (!_btn) {
        _btn = [[GradientButton alloc] init];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.layer.cornerRadius = 14;
        [_btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _btn.layer.masksToBounds = YES;
        [_btn addTarget:self action:@selector(tapBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end
