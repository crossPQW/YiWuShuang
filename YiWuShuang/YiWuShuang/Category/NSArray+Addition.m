//
//  NSArray+Addition.m
//  YKiPad
//
//  Created by flexih on 1/9/12.
//  Copyright (c) 2012 优酷. All rights reserved.
//

#import "NSArray+Addition.h"
#import "NSDictionary+Addition.h"
@implementation NSArray (Addition)

- (id)firstObject
{
    if ([self count] > 0) {
        return [self objectAtIndex:0];
    } else {
        return nil;
    }
}

- (void)addObservers:(NSArray *)observers forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context
{
    id object;
    NSEnumerator *enumerator = self.objectEnumerator;
    while (object = [enumerator nextObject]) {
        for (id observe in observers) {
            for (NSString *keyPath in keyPaths) {
                [object addObserver:observe
                         forKeyPath:keyPath
                            options:options
                            context:context];
            }
        }
    }
}

- (void)removeObservers:(NSArray *)observers forKeyPaths:(NSArray *)keyPaths
{
    id object;
    NSEnumerator *enumerator = self.objectEnumerator;
    while (object = [enumerator nextObject]) {
        for (id observe in observers) {
            for (NSString *keyPath in keyPaths) {
                [object removeObserver:observe
                            forKeyPath:keyPath];
            }
        }
    }
}

@end

@implementation NSArray (JsonStringExtention)

- (NSString *)JsonString
{
    if (!self || ![self isKindOfClass:[NSArray class]] || [self count] == 0) {
        return @"";
    }
    
    NSMutableString *jsonString = [NSMutableString string];
    [self serialzeWithJsonString:jsonString];
    
    if ([jsonString length]) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    return jsonString;
}

- (void)serialzeWithJsonString:(NSMutableString *)string
{
    [string appendString:@"["];
    for (id object in self) {
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]){
                [(NSDictionary *)object serialzeWithJsonString:string];
            }
            else if([object isKindOfClass:[NSArray class]]) {
                [self serialzeWithJsonString:string];
            }
            else {
                [string appendFormat:@"\"%@\",", object];
            }
        }
    }
    [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    [string appendString:@"]"];
    [string appendString:@","];
}
@end

@implementation NSArray (YKSafeAccess)

- (id)yk_objectAtIndex:(NSUInteger)index
{
    if (index >=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (YKSafeAccess)

-(void)yk_addObject:(id)anObject
{
    if (!anObject) return;
    [self addObject:anObject];
}

- (void)yk_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (!anObject) return;
    if (index > self.count) return;
    [self insertObject:anObject atIndex:index];
}

- (void)yk_removeObjectAtIndex:(NSUInteger)index
{
    if (index >=self.count) return;
    [self removeObjectAtIndex:index];
}

- (void)yk_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (!anObject) return;
    if (index >=self.count) return;
    [self replaceObjectAtIndex:index withObject:anObject];
}

@end
