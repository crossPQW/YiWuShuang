
#import "NSDictionary+Addition.h"
#import "NSDateFormatter+Addition.h"
#ifndef EXTENSION

#import "NSArray+Addition.h"
#endif

@implementation NSDictionary (Addition)

- (id)valueForKey:(NSString *)key withClass:(Class)aClass
{
    id value = [self objectForKey:key];
    return [value isKindOfClass:aClass] ? value : nil;
}

- (NSInteger)integerForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    }
    return 0;
}

- (int)intForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(intValue)]) {
        return [value intValue];
    }
    return 0;
}

- (float)floatForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(floatValue)]) {
        return [value floatValue];
    }
    return 0.0;
}

- (double)doubleForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(doubleValue)]) {
        return [value doubleValue];
    }
    return 0.0;
}

- (BOOL)boolForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    }
    return NO;
}

- (NSString *)stringForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    } else {
        return nil;
    }
}

/*非nil字符串*/
- (NSString *)safeStringForKey:(NSString *)key
{
    NSString *stringValue = [self stringForKey:key];
    return stringValue ? stringValue : @"";
}

/*内容为整型值的字符串*/
- (NSString *)intStringForKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%d", [self intForKey:key]];
}

- (NSURL *)urlForKey:(NSString *)key
{
    return [NSURL URLWithString:[self stringForKey:key]];
}

/*日期(可处理NSDate对象、秒数或毫秒数、“yyyy-MM-dd HH:mm:ss”格式字符串)*/
- (NSDate *)dateForKey:(NSString *)key isMS:(BOOL)isMS
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDate class]]) {
        return value;
    }
    
    //判断日期格式
    if ([value isKindOfClass:[NSString class]]) {
        NSDate *date = [[NSDateFormatter defaultDateFormatter] dateFromString:value];
        if (date) {//非规范日期格式直接进行间隔转换
            return date;
        }
    }
    
    //转换时间间隔
    if ([value respondsToSelector:@selector(doubleValue)]) {
        double doubleValue = [value doubleValue];
        doubleValue = isMS ? doubleValue / 1000.0 : doubleValue;
        return [NSDate dateWithTimeIntervalSince1970:doubleValue];
    }
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key
{
    return [self dateForKey:key isMS:NO];
}

- (NSDate *)dateForMSKey:(NSString *)key
{
    return [self dateForKey:key isMS:YES];
}

- (NSArray *)arrayForKey:(NSString *)key
{
    return [self valueForKey:key withClass:[NSArray class]];
}

- (NSMutableArray *)mutableArrayForKey:(NSString *)key
{
    NSArray *array = [self arrayForKey:key];
    return array ? [NSMutableArray arrayWithArray:array] : nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [self valueForKey:key withClass:[NSDictionary class]];
}

- (NSMutableDictionary *)mutableDictionaryForKey:(NSString *)key
{
    NSDictionary *dictionary = [self dictionaryForKey:key];
    return dictionary ? [NSMutableDictionary dictionaryWithDictionary:dictionary] : nil;
}

- (NSString *)jsonString
{
    if (!self || ![self isKindOfClass:[NSDictionary class]] || [self count] == 0) {
        return @"";
    }

    NSMutableString *jsonString = [NSMutableString string];
    [self serialzeWithJsonString:jsonString];
    if ([jsonString length]) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    
    return jsonString;
}

- (void)serialzeWithJsonString:(NSMutableString *)jsonString
{
    [jsonString appendString:@"{"];
    NSArray *allKeys = [self allKeys];
    for (NSString *key in allKeys) {
        id value = self[key];
        if (value) {
            if ([value isKindOfClass:[NSArray class]]) {
                [jsonString appendFormat:@"\"%@\":", key];
#ifndef EXTENSION

                [(NSArray *)value serialzeWithJsonString:jsonString];
#endif

            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [jsonString appendFormat:@"\"%@\":", key];
                [value serialzeWithJsonString:jsonString];
            }
            else {
                [jsonString appendFormat:@"\"%@\":\"%@\",", key, [value description]];
            }
        }
    }
    [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    [jsonString appendString:@"}"];
    [jsonString appendString:@","];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    NSDictionary *dic;
    if ([jsonString isKindOfClass:[NSString class]]) {
        if (jsonString.length > 0) {
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            if ([jsonData isKindOfClass:[NSData class]]) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error];
                if (!error) {//转换成功
                    dic = dictionary;
                }
            }
        }
    }
    return dic;
}

@end
@implementation NSMutableDictionary (YKSafeAccess)

-(void)yk_setObject:(id)anObject forKey:(id)aKey
{
    if(!aKey) return;
    if(!anObject) return;
    [self setObject:anObject forKey:aKey];
}

-(void)yk_setValue:(id)value forKey:(NSString*)key
{
    if(![key isKindOfClass:[NSString class]]) return;
    [self setValue:value forKey:key];
}

@end
