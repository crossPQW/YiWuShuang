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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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

- (void)setImage:(NSString *)image {
    self.imageView.image = [UIImage imageNamed:image];
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
}

- (IBAction)tapBtn:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
