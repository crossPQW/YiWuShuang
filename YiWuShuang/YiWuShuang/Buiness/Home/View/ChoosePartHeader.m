//
//  ChoosePartHeader.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/3.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ChoosePartHeader.h"

@implementation ChoosePartHeader

+ (instancetype)partHeader {
    return [[[NSBundle mainBundle] loadNibNamed:@"ChoosePartHeader" owner:self options:nil] lastObject];
}

@end
