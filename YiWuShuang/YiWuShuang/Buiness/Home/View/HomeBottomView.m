//
//  HomeBottomView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/3.
//  Copyright © 2020 huang. All rights reserved.
//

#import "HomeBottomView.h"

@implementation HomeBottomView


+ (instancetype)bottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeBottomView" owner:self options:nil] lastObject];
}
- (IBAction)delete:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)move:(id)sender {
    if (self.moveBlock) {
        self.moveBlock();
    }
    [self removeFromSuperview];
}

@end
