//
//  PersonCellTableViewCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PersonCellTableViewCell.h"
#import "YKAddition.h"
@interface PersonCellTableViewCell()
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *name;

@end
@implementation PersonCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.avatar = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatar];
        self.name = [[UILabel alloc] init];
        self.name.textColor = [UIColor colorWithHexRGB:@"#303033"];
        self.name.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.name];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(3);
        make.centerY.equalTo(self.avatar.mas_centerY);
    }];
}

- (void)setModel:(PersonModel *)model {
    _model = model;
    self.name.text = model.nickname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
