//
//  SwiftFintechClientConstFintechType.h
//  SwiftFintechSDK
//
//  Created by qiuqiu on 2017/6/16.
//  Copyright © 2017年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwiftFintechClientConstAppFintechConfig : NSObject

/**
 *  微信app支付
 */
+ (NSString *)getType1appKey;


/**
 *  支付宝app支付
 */
+ (NSString *)getType2appKey;

@end
