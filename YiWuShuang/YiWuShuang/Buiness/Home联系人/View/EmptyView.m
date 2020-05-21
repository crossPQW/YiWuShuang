//
//  EmptyView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import "EmptyView.h"
#import "YKAddition.h"
@interface EmptyView()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation EmptyView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.borderColor = [UIColor colorWithHexRGB:@"#00C2AD"].CGColor;
}
+ (instancetype)emptyView {
    return [[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil] lastObject];
}

- (IBAction)tapBtn:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
