
//
//  NavHeadTitleView.m
//  京师杏林
//
//  Created by sjt on 15/11/12.
//  Copyright © 2015年 MaNingbo. All rights reserved.
//

#import "NavHeadTitleView.h"
@interface NavHeadTitleView()

@end
@implementation NavHeadTitleView
+ (instancetype)navView {
    return [[[NSBundle mainBundle] loadNibNamed:@"NavHeadTitleView" owner:self options:nil] lastObject];
}
- (IBAction)tapSetting:(id)sender {
    if (self.settingBlock) {
        self.settingBlock();
    }
}

- (IBAction)tapMessage:(id)sender {
    if (self.messageBlock) {
        self.messageBlock();
    }
}

@end
