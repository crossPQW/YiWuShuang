//
//  MineCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/5.
//  Copyright © 2020 huang. All rights reserved.
//

#import "MineCell.h"

@interface MineCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@end
@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
