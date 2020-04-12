//
//  NSDictionary+TIXACategory.h
//  Lianxi
//
//  Created by Liusx on 13-2-3.
//  Copyright (c) 2013年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Addition)

- (id)valueForKey:(NSString *)key withClass:(Class)aClass;  //指定key和class的value，默认为nil

- (NSInteger)integerForKey:(NSString *)key;                 //返回对象integerValue，默认为0
- (int)intForKey:(NSString *)key;                           //返回对象intValue，默认为0
- (float)floatForKey:(NSString *)key;                       //返回对象floatValue，默认为0.0
- (double)doubleForKey:(NSString *)key;                     //返回对象doubleValue，默认为0.0
- (BOOL)boolForKey:(NSString *)key;                         //返回对象boolValue，默认为NO

- (NSString *)stringForKey:(NSString *)key;                 //若非NSString类型，返回对象stringValue或description，默认为nil
- (NSString *)safeStringForKey:(NSString *)key;             //返回非nil字符串，默认为@""
- (NSString *)intStringForKey:(NSString *)key;              //返回内容为整型值的字符串，默认为@"0"

- (NSURL *)urlForKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key;                     //返回日期，默认为nil(可处理NSDate对象、秒数、“yyyy-MM-dd HH:mm:ss”格式字符串)
- (NSDate *)dateForMSKey:(NSString *)key;                   //返回日期，默认为nil(可处理NSDate对象、毫秒数、“yyyy-MM-dd HH:mm:ss”格式字符串)

- (NSArray *)arrayForKey:(NSString *)key;                           //默认为nil
- (NSMutableArray *)mutableArrayForKey:(NSString *)key;             //默认为nil

- (NSDictionary *)dictionaryForKey:(NSString *)key;                 //默认为nil
- (NSMutableDictionary *)mutableDictionaryForKey:(NSString *)key;   //默认为nil
- (NSString *)jsonString;                                           //将字典转换为json格式的字符串
- (void)serialzeWithJsonString:(NSMutableString *)jsonString;       //将字典进行json转换时使用

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;  //json字符串转字典
@end

@interface NSMutableDictionary(YKSafeAccess)
-(void)yk_setObject:(id)anObject forKey:(id)aKey;//安全地设值，做了object以及key是否为nil的判断
-(void)yk_setValue:(id)value forKey:(NSString*)key;//安全地设值，做了key是否为NSString的判断
@end
