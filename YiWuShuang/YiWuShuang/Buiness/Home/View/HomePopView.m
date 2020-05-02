//
//  HomePopView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/2.
//  Copyright © 2020 huang. All rights reserved.
//

#import "HomePopView.h"

@implementation HomePopView

+ (instancetype)popView {
    return [[[NSBundle mainBundle] loadNibNamed:@"HomePopView" owner:self options:nil] lastObject];
}
- (IBAction)tapBtn0:(id)sender {
    if (self.addMemberBlock) {
        self.addMemberBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)tapBtn1:(id)sender {
    if (self.addStudentBlock) {
        self.addStudentBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)tapBtn2:(id)sender {
    if (self.addTeamBlock) {
        self.addTeamBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)tapBtn3:(id)sender {
    if (self.addOrigBlock) {
        self.addOrigBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)tapBtn4:(id)sender {
    if (self.joinOrigBlock) {
        self.joinOrigBlock();
    }
    [self removeFromSuperview];
}

@end
