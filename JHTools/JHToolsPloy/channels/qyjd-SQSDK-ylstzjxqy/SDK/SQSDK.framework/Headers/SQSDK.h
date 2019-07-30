//
//  SQSDK.h
//  SQSDK
//
//  Created by Kaymin on 2017/6/13.
//  Copyright © 2017年 SQSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SQSDKConstants.h"
#import "SQSDKConfig.h"
#import "SQSDKUserInfo.h"
#import "SQSDKRoleInfo.h"
#import "SQSDKPayInfo.h"

@interface SQSDK : NSObject

/**
 * 调试模式
 */
+ (void)setDebug:(BOOL)isDebug;

/**
 * 屏幕方向
 */
+ (void)setScreenOrientation:(SQSDKScreenOrientation)screenOrientation;

+ (void)initWithConfig:(SQSDKConfig *)config application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (void)login;
+ (void)logout;
+ (void)switchAccount;
+ (void)report:(SQSDKRoleInfo *)roleInfo;
+ (void)pay:(SQSDKPayInfo *)payInfo;
+ (void)recharge;
+ (void)exit;



+ (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;


+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
