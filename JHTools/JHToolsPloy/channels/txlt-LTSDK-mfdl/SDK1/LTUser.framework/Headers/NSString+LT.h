//
//  NSString+LT.h
//  LTSDK
//
//  Created by casic on 2018/11/8.
//  Copyright © 2018年 LT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LT)

/**
 转成MD5格式（小写字母）
 */
+ (NSString *)md5_32bit:(NSString *)input;
/**
 生成指定长度的随机字符串
 
 @param len 指定长度
 */
+ (NSString *)randomStringWithLength:(NSInteger)len;
/**
 字典转成key=value&key=value格式
 */
+ (NSString *)stringWithDic:(NSDictionary *)dic;

/**
 字典转json字符串
 */
+ (NSString *)jsonStringWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
