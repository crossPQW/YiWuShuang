//
//  ChooseBottomView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/31.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChooseBottomView.h"

@interface ChooseBottomView()
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end
@implementation ChooseBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.doneBtn.bounds;
    [self.doneBtn.layer insertSublayer:layer atIndex:0];
    self.doneBtn.layer.cornerRadius = 4;
    self.doneBtn.layer.masksToBounds = YES;
    
}

+ (instancetype)bottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ChooseBottomView" owner:self options:nil] lastObject];
}

- (IBAction)done:(id)sender {
    if (self.block) {
        self.block();
    }
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
