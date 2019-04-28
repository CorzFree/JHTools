
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import "NSString+SPUtilsExtras.h"
#import "NSData+SPUtilsExtras.h"

@implementation NSString (SPUtilsExtras)

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Calculate the md5 hash using CC_MD5.
 *
 * @returns md5 hash of this string.
 */
- (NSString*)md5Hash
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}


/**
 *  生成测试需要的随机字符串
 *
 *  @return <#return value description#>
 */
+ (NSString*)sp_nonce_str{

    return [self randomString:32];
}

/**
 *  生成测试商户订单号；
 *
 *  @return <#return value description#>
 */
+ (NSString*)sp_out_trade_no{
    return [self randomString:32];
}


/**
 *  生成随机字符串
 *
 *  @param randomLeng <#randomLeng description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)randomString:(NSInteger)randomLeng{
    
    
    NSInteger leng = randomLeng;
    
    NSTimeInterval timeStamp =  [[NSDate date] timeIntervalSince1970];
    NSInteger second = timeStamp;
    
    //时间戳精确到秒
    NSString *secondString = [NSString stringWithFormat:@"%ld",(long)second];
    
    //随机长度必须要大于时间戳长度
    if (randomLeng > secondString.length) {
        leng = randomLeng - secondString.length;
    }else{
        secondString = @"";
    }
    char data[leng];
    
    
    for (NSInteger x = 0; x<leng; x++) {
        
        NSInteger v = arc4random() % 3;
        switch (v) {
            case 0:
            {
                data[x] = (char)('A' + (arc4random_uniform(26)));
            }
                break;
            case 2:
            {
                data[x] = (char)('a' + (arc4random_uniform(26)));
            }
                break;
                
            default:{
                data[x] = (char)('0' + (arc4random_uniform(9)));
            }
                break;
        }
    }
    
    return [secondString  stringByAppendingString:[[NSString alloc] initWithBytes:data length:leng encoding:NSASCIIStringEncoding]];
}


/**
 *  解析HTTP Get参数
 *
 *  @return <#return value description#>
 */
-(NSDictionary*)parseHTTGetParameter{
    
    NSArray *hTTPGETParameterArray = [self componentsSeparatedByString:@"&"];
    //是否分割出来了参数
    if (hTTPGETParameterArray &&
        hTTPGETParameterArray.count) {
        
        
        NSMutableDictionary *parameterDicy = [[NSMutableDictionary alloc] init];
        for (NSString *parameterItemString in hTTPGETParameterArray) {
            
            NSArray *itemArray = [parameterItemString componentsSeparatedByString:@"="];
            //判断参数格式是否合法
            if (itemArray &&
                itemArray.count == 2) {
                
                [parameterDicy setValue:itemArray[1] forKey:itemArray[0]];
            }else{
                return nil;
            }
        }
        
        return parameterDicy;
    }
    
    return nil;
}


@end
