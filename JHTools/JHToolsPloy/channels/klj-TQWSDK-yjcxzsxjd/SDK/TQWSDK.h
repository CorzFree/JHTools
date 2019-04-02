//
//  TQWSDK.h
//  tao7wan
//
//  Created by wanggp on 2018/8/8.
//  Copyright © 2018年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TQWSDKDefines.h"
#import "TQWSDKPayOrderInfo.h"


@interface TQWSDK : NSObject

+ (TQWSDK *)defaultInstance;

#pragma mark - 初始化

/**
 @brief 初始化
 *  @param appId  id
 *  @param appSecret 密钥
 *  @param channel 渠道
 @note 必接
 */
+ (void)initWithAppId:(NSString *)appId secret:(NSString*)appSecret  channel:(NSString *)channel;

/**
 @brief 设置游戏版本号
 *  @param versionName 游戏版本号
 @note 传入游戏版本号
 */
+ (void)setGameVersionName:(NSString *)versionName;

/**
 @brief 设置工会渠道id
 *  @param cpsId 工会渠道id
 */
+ (void)setAppgameCpsId:(NSString *)cpsId;

/**
 @brief 显示SDK日志
 *  @param bFlag true/faslse
 */
+ (void)setLogEnabled:(BOOL)bFlag;

/**
 @brief 是否包含用户注册功能，默认有用户注册功能
 *  @param rFlag true/faslse 默认值为：true
 */
+ (void)setIncludeUserRegistrationEnabled:(BOOL)rFlag;


#pragma mark - 用户
/**
 @brief 登录接口 ，登录后会发送tqwSDKNotiLogin通知
 @note 无返回
 */
- (void)login;

// 登录后获取accessToken可用于验证用户信息
- (NSString *)accessToken;
// 登录后获取用户登录名
- (NSString *)userName;
// 登录后获取用户昵称
- (NSString *)userNick;

/**
 @brief 登出接口 代码调用注销
 @note 成功调用该接口后，SDK会发出tqwSDKNotiLogout通知
 */
- (void)logout;

#pragma mark - 订单和支付
/**
 @brief 商品购买
 *  @param orderInfo  订单信息
 @note 成功调用该接口后，SDK会发出tqwSDKNotiRecharge通知
 */
- (void)payOrderInfo:(TQWSDKPayOrderInfo *)orderInfo;

#pragma mark - 浮动按钮

/**
 @brief 浮动按钮，建议显示在左上角
 */
- (void)showFloatingButton:(UIWindow *)window place: (TQW_SDK_TOOLBAR_PLACE)place;

//隐藏浮动按钮
- (void)hideFloatingButton;



#pragma mark - 统计
/**
 @brief 统计
 *  @param actionId 统计类型
 *  @param attributes 参数
 @note 接口没有返回值
 */
+ (void)collectData:(AppgameCollectAction)actionId attributes:(NSDictionary *)attributes;

@end
