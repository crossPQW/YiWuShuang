//
//  NSArray+Addition.h
//  YKiPad
//
//  Created by flexih on 1/9/12.
//  Copyright (c) 2012 优酷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Addition)
- (id)firstObject;
- (void)addObservers:(NSArray *)observers forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)removeObservers:(NSArray *)observers forKeyPaths:(NSArray *)keyPaths;
@end

@interface NSArray (JsonStringExtention)

- (NSString *)JsonString;   //将数组转化为json类型的字符串，只支持数组中元素是字典类型的数据
- (void)serialzeWithJsonString:(NSMutableString *)jsonString;   // 将数组进行json转换时使用
@end

@interface NSArray (YKSafeAccess)
- (id)yk_objectAtIndex:(NSUInteger)index;//安全地取值，做了数组越界的判断
@end

@interface NSMutableArray(YKSafeAccess)
-(void)yk_addObject:(id)anObject;//安全地增加元素，做了是否为nil的判断
- (void)yk_insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)yk_removeObjectAtIndex:(NSUInteger)index;
- (void)yk_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end
