//
//  JHToolsUtils.m
//  JHToolsSDK_91WanSY
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsUtils.h"

@implementation JHToolsUtils

+(NSString *)getResponseCodeWithDict:(NSDictionary *)dict{
    if (![self isDictionaryEmpty:dict] && ![self isDictionaryEmpty:dict[@"state"]]) {
        return [self stringValue:dict[@"state"][@"code"]];
    }else{
        return nil;
    }
}

+(NSString *)getResponseUidWithDict:(NSDictionary *)dict{
    if (![self isDictionaryEmpty:dict] && ![self isDictionaryEmpty:dict[@"data"]] && ![self isDictionaryEmpty:dict[@"data"][@"user"]]) {
        return [self stringValue:dict[@"data"][@"user"][@"id"]];
    }else{
        return nil;
    }
}

+(NSString *)stringValue:(NSString *)str {
    if (!str) {
        return @"";
    }
    
    if ([str isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)str;
        return [number stringValue];
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return str;
}

+(BOOL)isDictionaryEmpty:(NSDictionary *)dict{
    return dict == nil || ![dict isKindOfClass:[NSDictionary class]] || dict.count == 0 || [dict isKindOfClass:[NSNull class]];
}

+(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
