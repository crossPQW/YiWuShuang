//
//  OrderClassCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/16.
//  Copyright © 2020 huang. All rights reserved.
//

#import "OrderClassCell.h"
#import "YKAddition.h"
@interface OrderClassCell()
@property (weak, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end
@implementation OrderClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stateBtn.layer.cornerRadius = 2;
    self.stateBtn.layer.masksToBounds = YES;
    
    self.cView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.cView.layer.cornerRadius = 4;
    self.cView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.cView.layer.shadowOffset = CGSizeMake(0,0);
    self.cView.layer.shadowOpacity = 1;
    self.cView.layer.shadowRadius = 3;
    
    self.joinBtn.layer.borderColor = [UIColor colorWithHexRGB:@"#15C3D6"].CGColor;
    self.joinBtn.layer.cornerRadius = 2;
    self.joinBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
