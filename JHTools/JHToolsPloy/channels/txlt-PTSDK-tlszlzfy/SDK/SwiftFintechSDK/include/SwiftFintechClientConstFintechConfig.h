//
//  SwiftFintechClientConstFintechType.h
//  SwiftFintechSDK
//
//  Created by qiuqiu on 2017/6/16.
//  Copyright © 2017年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwiftFintechClientConstFintechConfig : NSObject

/**
 *  微信Wap支付
 */
+ (NSString *)getType1WapKey;

/**
 *  微信Wap支付
 */
+ (NSString *)getType1Wapv2Key;

/**
 *  支付宝Wap支付
 */
+ (NSString *)getType2SDKWapKey;

/**
 *  QQ钱包Wap支付
 */
+ (NSString *)getType3WapKey;

/**
 *  QQ钱包Wap支付v2
 */
+ (NSString *)getType3Wapv2Key;

/**
 *  京东钱包Wap支付方式
 */
+ (NSString *)getType4WapKey;

@end
