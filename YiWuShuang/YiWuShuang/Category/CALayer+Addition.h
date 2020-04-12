//
//  CALayer+Addition.h
//  Youku
//
//  Created by 光 李 on 4/17/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Addition)
//contentsScale 属性4.0后才能执行
- (void)autoSetContentsScale;
@end