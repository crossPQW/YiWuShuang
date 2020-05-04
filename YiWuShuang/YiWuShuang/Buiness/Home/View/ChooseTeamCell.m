//
//  ChooseTeamCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/4.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChooseTeamCell.h"
#import "YKAddition.h"
@interface ChooseTeamCell()
@property (weak, nonatomic) IBOutlet UILabel *partName;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
@implementation ChooseTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMode:(ChooseTeamModel *)mode {
    _mode = mode;
    if (mode.isChecked) {
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

@end
