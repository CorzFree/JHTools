//
//  LANTsdkManagererCart.h
//  BanLA
//
//  Created byJiaLan on 16/11/22.
//  Copyright © 2016年 LanguageBan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIApplication,LANTRequestModelerCart,LANTRoleModelerCart;

@interface LANTsdkManagererCart : NSObject
+(instancetype)manager;


/**
 * 保存相关信息与版本号，并进行登录或自动登录（注意：如果登录成功后会以通知的形式发送相关信息，注意监听@"login"通知）
 
 @param gid 游戏gid
 @param apiKey 游戏apiKey
 @param secretKey 游戏的secretKey
 @param verstion 游戏版本号
 */
+(void)LANTstartLoginWithGid:(NSString *)gid apiKey:(NSString *)apiKey secretKey:(NSString *)secretKey version:(NSString *)verstion;

/**
 * 支付调用接口（通用接口）
 
 @param requestModel 支付请求模型对象，需要给每一个参数赋值
 */
+(void)LANTstartPayWithRequestModel:(LANTRequestModelerCart *)requestModel;

+(void)LANTWillEnterForeground:(UIApplication *)application;


/**
 * 退出登录接口（通用接口）
 
 @param success 退出登录回调，当返回值为YES表示退出登录成功，返回值为NO表示退出登录失败
 */
+(void)LANTLoginOutDidSuccess:(void(^)(BOOL isSuccess))success;


/**
 * 更新角色信息接口（通用接口）
 
 @param model 角色信息模型，需要给每一个参数赋值
 @param success 更新成功回调，当返回值为YES时表示更新角色信息成功，返回值为NO表示更新角色信息失败
 */
+(void)LANTUpdateRoleInfoWithRoleModel:(LANTRoleModelerCart *)model didSuccess:(void(^)(BOOL isUpdateRoleSuccess))success;


/**
 * 向服务器验证凭证（越狱版本可不调用）
 */
+(void)LANTReVerifyToService;

/**
 * 悬浮球(登录后调用)
 */
+(void)LANTFloatViewForContentTel;

//ios 9以前调用
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
//ios 9以后调用
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


@end
