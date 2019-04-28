//
//  SwiftFintechClient.h
//  SwiftFintechSDK
//
//  Created by wongfish on 2017/4/24.
//  Copyright © 2017年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  支付回调
 */
typedef void(^SPFintechFinishBlock) (NSDictionary *fintechStateDic);

/**
 *  支付失败回调
 *
 *  @param message 支付失败原因
 */
typedef void(^SPFintechFailureBlock) (NSString *message);



@interface SwiftFintechClient : NSObject

+ (SwiftFintechClient*)sharedInstance;


/**
 SDK版本号
 
 @return 版本号
 */
- (NSString*)SwiftFintechSDKVersion;

/**
 SDK类型
 @return 类型
 */
- (NSString*)SwiftFintechSDKType;

/**
 *  SP支付
 *
 *  @param spTokenIDString 支付授权码（必填）
 *  @param fintechServicesString 支付类型(必填)(例如:pay.weixin.app)
 *  @param finish            SDK支付完成回调
 */
- (void)fintech:(NSString*)spTokenIDString
fintechServicesString:(NSString*)fintechServicesString
         finish:(SPFintechFinishBlock)finish ;



/**
 是否加安装判断
 @param isJudgeInstall YES（判断） NO（不判断）
 */
- (void)isJudgeInstall:(BOOL)isJudgeInstall;


/**
 微信支付配置参数
 @param type1ConfigModel SwiftFintechClientType1ConfigModel模型
 */
- (void)type1FintechConfig:(id)type1ConfigModel;


/**
 支付宝支付配置参数
 @param type2ConfigModel SwiftFintechClientType1ConfigModel模型
 */
- (void)type2FintechConfig:(id)type2ConfigModel;


/**
 手Qwap支付配置参数
 @param type3ConfigModel SwiftFintechClientType3ConfigModel模型
 */
- (void)type3FintechConfig:(id)type3ConfigModel;



#pragma mark - 使用微信APP支付和支付宝APP支付，必须实现以下三个UIApplicationDelegate代理方法

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url;

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0); // no equiv. notification. return NO if the application can't open for some reason


/**
 *   进入前台————查单
 */
- (void)applicationWillEnterForeground:(UIApplication *)application;


@end
