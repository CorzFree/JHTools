//
//  JNetManager.h

//
//  Created by 降瑞雪 on 2017/4/5.
//  Copyright © 2017年 HuiYuan.NET. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JNetRequest.h"
#import "JNetResponse.h"

#define DEPRECATED(_version) __attribute__((deprecated))

@interface JNetManager : NSObject

//唤起支付钱包关键方法，
+ (void)sendRequest:(JNetRequest *)requset responseBlock:(void(^)(JNetResponse *response))resultBlock;

//获取当前SDK版本号。
+(NSString *)getApiVersion;

//设置隐藏跳到第三方APP时的中间页。默认是不隐藏。
+ (void)hiddenJumpPage:(BOOL)hidden DEPRECATED(4.0.2);

//取消订单
+(void)cancelOrderWithRequest:(JNetRequest *)pModel cancelOrderBlock:(void(^)(BOOL isSuccess))cancelOrderBlock;


//支付宝APP和商户应用间通讯方法。
+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url;

//需要在AppDelegate 的applicationWillEnterForeground:方法中调用.
+(void)applicationWillEnterForeground DEPRECATED(4.0.1); //该方法在4.0.1版本中作废。

//遮挡页面maskView的背景色和label内容设置方法
+(void)maskViewBackgroundColor:(UIColor *)color maskViewLabelString:(NSString *)string;

@end
