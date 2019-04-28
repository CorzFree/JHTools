
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import "NSDictionary+SPUtilsExtras.h"
#import "NSString+SPUtilsExtras.h"

@implementation NSDictionary (SPUtilsExtras)


/**
 *  安全的对字典赋值
 *
 *  @param key <#key description#>
 *  @param val <#val description#>
 */
- (void)safeSetValue:(NSString*)key
                  val:(id)val{
    if (val) {
        [self setValue:val forKey:key];
    }
}

/**
 *  通过字典的key，以ASCII排序
 *
 *  @return <#return value description#>
 */
- (NSArray*)orderForKeyAscii{
    NSArray *array = self.allKeys;
    
    //将表单内容的字段按照ASCII排序，排序规则为ASCII从小到大排序
    NSArray *orderArray =  [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return ([obj2 compare:obj1] == NSOrderedAscending);
    }];
    return orderArray;
}


/**
 *  获取请求签名
 *
 *  @param commercialTenantKeyValString 商户密钥值
 *
 *  @return <#return value description#>
 */
- (NSString*)spRequestSign:(NSString*)commercialTenantKeyValString{
    
    //将表单内容的字段按照ASCII排序，排序规则为ASCII从小到大排序
    NSArray *orderArray = [self orderForKeyAscii];
    __block NSString *soureString = @"";
    [orderArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        soureString = [NSString stringWithFormat:@"%@%@=%@&",soureString,obj,self[obj]];
    }];
    
    
    soureString = [NSString stringWithFormat:@"%@%@=%@",soureString,@"key",commercialTenantKeyValString];
    return [soureString md5Hash].uppercaseString;
}

/**
 *  判断字典中某个key是否存在
 *
 *  @param keyName 存在返回YES
 *
 *  @return <#return value description#>
 */
- (BOOL)isForKeyExists:(NSString*)keyName{
    if ([[self allKeys] containsObject:keyName]) {
        return YES;
    }
    return NO;
}

/**
 *  安全获取字典里面的值
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
- (id)safeObjectForKey:(NSString*)key{
    
    id val = [self objectForKey:key];
    
    if ([val isEqual:[NSNull null]]) {
        
        return nil;
    }
    return val;
}


@end
