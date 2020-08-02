//
//  ShareView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/8/2.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ShareView.h"

@interface ShareView()
@property (weak, nonatomic) IBOutlet UIImageView *wechatIcon;
@property (weak, nonatomic) IBOutlet UIImageView *QQIcon;
@property (weak, nonatomic) IBOutlet UIImageView *dingdingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *messageIcon;

@end
@implementation ShareView

+ (instancetype)shareView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *wechatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWechat)];
    self.wechatIcon.userInteractionEnabled = YES;
    [self.wechatIcon addGestureRecognizer:wechatTap];
    
    UITapGestureRecognizer *qqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQQ)];
    self.QQIcon.userInteractionEnabled = YES;
    [self.QQIcon addGestureRecognizer:qqTap];
    
    UITapGestureRecognizer *dingdingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDingding)];
    self.dingdingIcon.userInteractionEnabled = YES;
    [self.dingdingIcon addGestureRecognizer:dingdingTap];
    
    UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage)];
    self.messageIcon.userInteractionEnabled = YES;
    [self.messageIcon addGestureRecognizer:messageTap];
    
}

- (void)tapWechat {
    if (self.block) {
        self.block(0);
    }
}

- (void)tapQQ {
    if (self.block) {
        self.block(1);
    }
}

- (void)tapDingding {
    if (self.block) {
        self.block(2);
    }
}

- (void)tapMessage {
    if (self.block) {
        self.block(3);
    }
}

@end
