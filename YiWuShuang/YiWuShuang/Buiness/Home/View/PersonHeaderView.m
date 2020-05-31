//
//  PersonHeaderView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import "PersonHeaderView.h"
#import "YKAddition.h"
@interface PersonHeaderView()

@property (nonatomic, assign) BOOL isHidden;
@end
@implementation PersonHeaderView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    _isHidden = !_isHidden;
    if (self.block) {
        self.block(_isHidden);
    }
}

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PersonHeaderView" owner:self options:nil] lastObject];
}


@end
