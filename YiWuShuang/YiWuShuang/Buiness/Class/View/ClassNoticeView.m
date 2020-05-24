//
//  ClassNoticeView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassNoticeView.h"

@implementation ClassNoticeView

+ (instancetype)noticeView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ClassNoticeView" owner:self options:nil] lastObject];
}
- (IBAction)close:(id)sender {
    if (self.block) {
        self.block();
    }
}
@end
