//
//  NSObject+YKRuntime.h
//  YoukuCore
//
//  Created by liusx on 15/9/14.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(YKRuntime)

///交换方法的IMP实现
bool ykRuntimeSwizzleMethod(Class class1, SEL selector1, Class class2, SEL selector2);

///添加方法
bool ykRuntimeAddMethod(Class toClass, SEL selector, Class impClass, SEL impSelector);

///交换当前Class指定方法的IMP实现。建议在+load方法中调用。
+ (BOOL)ykRuntimeSwizzleSelector:(SEL)selector1 withSelector:(SEL)selector2;

@end
