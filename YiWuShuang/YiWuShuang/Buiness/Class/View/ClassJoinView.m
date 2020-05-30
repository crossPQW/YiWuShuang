//
//  ClassJoinView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassJoinView.h"

@interface ClassJoinView()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@end
@implementation ClassJoinView

+ (instancetype)joinView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ClassJoinView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.joinBtn.bounds;
    [self.joinBtn.layer insertSublayer:layer atIndex:0];
    self.joinBtn.layer.cornerRadius = 4;
    self.joinBtn.layer.masksToBounds = YES;
    
}
- (IBAction)join:(id)sender {
    if (self.block) {
        self.block(self.textField.text);
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
