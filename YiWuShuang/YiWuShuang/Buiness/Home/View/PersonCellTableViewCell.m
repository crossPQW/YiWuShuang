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

@property (nonatomic, strong) UIButton *checkBtn;
@end
@implementation PersonCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.avatar = [[UIImageView alloc] init];
        self.avatar.layer.cornerRadius = 20;
        self.avatar.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatar];
        self.name = [[UILabel alloc] init];
        self.name.textColor = [UIColor colorWithHexRGB:@"#303033"];
        self.name.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.name];
        
        [self.contentView addSubview:self.checkBtn];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setModel:(PersonModel *)model {
    _model = model;
    self.name.text = model.nickname;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    if (model.isChecked) {
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"home_person_checked"] forState:UIControlStateNormal];
        _checkBtn.layer.borderColor = [UIColor clearColor].CGColor;
        _checkBtn.layer.borderWidth = 0;
        _checkBtn.layer.cornerRadius = 10;
    }else{
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _checkBtn.layer.borderColor = [UIColor colorWithHexRGB:@"#DADCE1"].CGColor;
        _checkBtn.layer.borderWidth = 1;
        _checkBtn.layer.cornerRadius = 10;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [[UIButton alloc] init];
        _checkBtn.layer.borderColor = [UIColor colorWithHexRGB:@"#DADCE1"].CGColor;
        _checkBtn.layer.borderWidth = 1;
        _checkBtn.layer.cornerRadius = 10;
        _checkBtn.userInteractionEnabled = NO;
    }
    return _checkBtn;
}
@end
