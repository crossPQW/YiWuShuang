//
//  InvateView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/31.
//  Copyright © 2020 huang. All rights reserved.
//

#import "InvateView.h"

@implementation InvateView

+ (instancetype)invateView {
    return [[[NSBundle mainBundle] loadNibNamed:@"InvateView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.block) {
        self.block();
    }
}
@end
