//
//  NSObject+YKRuntime.m
//  YoukuCore
//
//  Created by liusx on 15/9/14.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "NSObject+YKRuntime.h"
#import <objc/runtime.h>

@implementation NSObject(YKRuntime)

//添加方法
bool ykRuntimeAddMethod(Class toClass, SEL selector, Class impClass, SEL impSelector)
{
    Method impMethod = class_getInstanceMethod(impClass, impSelector);
    return class_addMethod(toClass, selector, method_getImplementation(impMethod), method_getTypeEncoding(impMethod));
}

//交换方法的IMP实现
bool ykRuntimeSwizzleMethod(Class class1, SEL selector1, Class class2, SEL selector2)
{
    Method method1 = class_getInstanceMethod(class1, selector1);
    Method method2 = class_getInstanceMethod(class2, selector2);
    if (!method1 || !method2) {
        return false;
    }
    
    //为class添加方法，否则有可能交换父类IMP
    class_addMethod(class1, selector1, method_getImplementation(method1), method_getTypeEncoding(method1));
    class_addMethod(class2, selector2, method_getImplementation(method2), method_getTypeEncoding(method2));
    
    //重新获取添加后的method，并交换IMP
    method_exchangeImplementations(class_getInstanceMethod(class1, selector1), class_getInstanceMethod(class2, selector2));
    
    return true;
}

//交换方法的IMP实现
+ (BOOL)ykRuntimeSwizzleSelector:(SEL)selector1 withSelector:(SEL)selector2
{
    return ykRuntimeSwizzleMethod(self, selector1, self, selector2);
}

@end
