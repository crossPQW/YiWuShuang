//
//  ContactCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/6/6.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ContactCell.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "YKAddition.h"
#import "GradientButton.h"
@interface ContactCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) GradientButton *avatarBtn;
@property (nonatomic, strong) CAGradientLayer *btnLayer;
@end
@implementation ContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnLayer = [self gLayer];
    self.btnLayer.frame = self.addBtn.bounds;
    [self.addBtn.layer insertSublayer:self.btnLayer atIndex:0];
    self.btnLayer.hidden = YES;
    self.addBtn.layer.cornerRadius = 14;
    self.addBtn.layer.masksToBounds = YES;
    
    self.avatarBtn = [[GradientButton alloc] init];
    [self.avatarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.avatarBtn.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
    self.avatarBtn.layer.cornerRadius = 20;
    self.avatarBtn.layer.masksToBounds = YES;
    self.avatarBtn.hidden = YES;
    self.avatarBtn.frame = self.avatar.frame;
    self.avatar.layer.cornerRadius = 20;
    self.avatar.clipsToBounds = YES;
    [self.contentView addSubview:self.avatarBtn];
}


- (void)setModel:(ContactModel *)model {
    _model = model;
    if (model.avatar.length > 0) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        self.avatarBtn.hidden = YES;
    }else{
        self.avatarBtn.hidden = NO;
        if (model.name.length == 1) {
            [self.avatarBtn setTitle:model.name forState:UIControlStateNormal];
        }else{
            [self.avatarBtn setTitle:[model.name substringFromIndex:(model.name.length - 2)] forState:UIControlStateNormal];
        }
    }
    
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.mobile;
    if (model.status == 1) {
        [self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor colorWithHexRGB:@"#707277"] forState:UIControlStateNormal];
        [self.addBtn setBackgroundColor:[UIColor colorWithHexRGB:@"#F5F7FA"]];
        self.btnLayer.hidden = YES;
    }else{
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnLayer.hidden = NO;
    }
}
- (IBAction)add:(id)sender {
    if (self.addFriendBlock) {
        self.addFriendBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CAGradientLayer *)gLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:239/255.0 blue:162/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:20/255.0 green:193/255.0 blue:215/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    return gl;
}


@end
