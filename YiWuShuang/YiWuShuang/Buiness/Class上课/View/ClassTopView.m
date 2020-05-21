//
//  ClassTopView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/16.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassTopView.h"

@interface ClassTopView()
@property (weak, nonatomic) IBOutlet UIButton *startClassBtn;

@property (weak, nonatomic) IBOutlet UIButton *joinClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
@implementation ClassTopView

+ (instancetype)topView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ClassTopView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *img = [[UIImage imageNamed:@"nav_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.messageBtn setImage:img forState:UIControlStateNormal];
    self.messageBtn.tintColor = [UIColor whiteColor];
    
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.topView.bounds;
    [self.topView.layer insertSublayer:layer atIndex:0];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0,2);
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 5;
    
    [self bringSubviewToFront:self.contentView];
}

- (IBAction)startClass:(id)sender {
    if (self.tapStartClassBlock) {
        self.tapStartClassBlock();
    }
}

- (IBAction)joinClass:(id)sender {
    if (self.tapJoinClassBlock) {
        self.tapJoinClassBlock();
    }
}
- (IBAction)orderClass:(id)sender {
    if (self.tapOrderClassBlock) {
        self.tapOrderClassBlock();
    }
}

- (IBAction)messageClick:(id)sender {
    if (self.tapMessageBlock) {
        self.tapMessageBlock();
    }
}
- (IBAction)addBtnClick:(id)sender {
    if (self.tapAddPersonBlock) {
        self.tapAddPersonBlock();
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
