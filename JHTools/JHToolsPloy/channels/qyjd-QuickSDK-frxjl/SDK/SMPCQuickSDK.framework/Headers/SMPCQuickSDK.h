//
//  SMPCQuickSDK.h
//  QuickSDK
//
//
//
#define SMPC_QUICK_SDK_VERSION @"2.3.8" //QuickSDK基础库版本

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMPCQuickSDKDefines.h"
#import "SMPCQuickSDKInitConfigure.h"
#import "SMPCQuickSDKPayOrderInfo.h"
#import "SMPCQuickSDKGameRoleInfo.h"


#pragma mark -
#pragma mark 基本信息

@interface SMPCQuickSDK : NSObject

#pragma mark QuickSDK实例
+ (SMPCQuickSDK *)defaultInstance;

#pragma mark 获取渠道基本信息
//获取渠道唯一标识，与服务器端channelID一致，任何时刻都可调用
- (int)channelType;


@end

#pragma mark - 初始化 接入产品信息

@interface SMPCQuickSDK(Base)

#pragma mark 初始化
/**
 @brief 应用初始化 完成后会发送通知kSmpcQuickSDKNotiInitDidFinished
 @param configure 初始化配置类，SDK会优先使用打包工具上在线配置的productCode
 @result 错误码
 @note 必接
 */
- (int)initWithConfig:(SMPCQuickSDKInitConfigure *)configure application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
/**
 @brief 调用组件功能，参数请看对应组件接入文档
 */
- (int)callPlug:(NSString *)name params:(NSArray *)args;
@end

#pragma mark - 用户部分 登录 注册 登出

@interface SMPCQuickSDK(Account)

/**
 @brief 登录接口 ，登录后会发送kSmpcQuickSDKNotiLogin通知
 @result 错误码
 @note 必接
 */
- (int)login;
/**
 @brief 登出接口 代码调用注销
 @result 错误码
 @note 成功调用该接口后，SDK会发出kSmpcQuickSDKNotiLogout通知
 */
- (int)logout;
// 登录后获取用户uid,这个uid在渠道上唯一，多个渠道的用户uid可能重复
- (NSString *)userId;
// 登录后获取userToken可用于验证用户信息
- (NSString *)userToken;
// 登录后获取用户昵称
- (NSString *)userNick;

#pragma mark - 更新角色信息
// 进入游戏角色，角色信息变更时调用（比如升级）,请使用updateRoleInfoWith:isCreate:
- (void)updateRoleInfoWith:(SMPCQuickSDKGameRoleInfo *)info;
//// 创建角色、进入游戏角色、角色信息变更时调用（比如升级，isCreate表示是否为创建角色
- (void)updateRoleInfoWith:(SMPCQuickSDKGameRoleInfo *)info isCreate:(BOOL)isCreate;

@end
//MARK:- 充值
@interface SMPCQuickSDK(Recharge)
/**
 @brief 商品购买
 *  @param orderInfo
 *  @param roleInfo
 @result 错误码
 */
- (int)payOrderInfo:(SMPCQuickSDKPayOrderInfo *)orderInfo
           roleInfo:(SMPCQuickSDKGameRoleInfo *)roleInfo;


@end

#pragma mark - ####个人中心 BBS 客服 ####

@interface SMPCQuickSDK(Centers)

@end

#pragma mark - 界面控制

@interface SMPCQuickSDK(UISetting)

#pragma mark 浮动条
/**
 @brief showToolBar:
 @brief 浮动工具栏，建议显示在左上角
 @result 错误码
 @note
 */
- (int)showToolBar:(SMPC_QUICK_SDK_TOOLBAR_PLACE)place;
//隐藏浮动工具栏
- (int)hideToolBar;

@end

@interface SMPCQuickSDK(Extend)
// 获取QuicSDK后台为渠道添加的自定义键值，任何时刻都可调用
// 如果没有将返回nil
- (NSString *)getConfigValue:(NSString *)key;
/**
 @brief isFunctionSupported:
 @brief 判断当前渠道是否实现了QuickSDK提供的某个接口
 @brief 如果当前渠道没有实现相应接口，就没有相应接口的回调
 @brief 例如渠道SDK没有实现pausedGame这个接口，即使调用了pausedGame，没有暂停恢复通知，因为pausedGame调用无效
 @result 是否
 @note
 */
- (BOOL)isFunctionTypeSupported:(SMPC_QUICK_SDK_FUNC_TYPE)type;

/**
 @brief 进入用户中心 如用户注销登录会发送kSmpcQPLogoutNotification（可多次触发）
 @result 错误码
 */
- (int)enterUserCenter;
// 进入渠道客服
- (int)enterCustomerCenter;
// 进入BBS
- (int)enterBBS;
//游戏主动暂停时调用。恢复时SDK会发送恢复通知，恢复通知游戏可不处理
//如果渠道没有实现这个接口，返回SMPC_QUICK_SDK_ERROR_UNSUPPORTED
//
- (int) pausedGame;
//***********************应用生命周期的回调*******************//
//在应用对应的生命周期回调中调用
/**
 @brief - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
 @brief - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation 
 @brief - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
 @brief 渠道处理应用跳转
 @result 错误码
 @note 必接
 */

- (int)openURL:(NSURL *)url application:(UIApplication *)application;
- (int)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApp application:(UIApplication *)application annotation:(id)annotation;
- (int)openURL:(NSURL *)url application:(UIApplication *)app options:(NSDictionary <NSString *, id>*)options;
/**
 @brief application:didRegisterForRemoteNotificationsWithDeviceToken:
 @brief 推送消息
 @result 错误码
 @note 必接
 */
- (int)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

/**
 @brief application:didFailToRegisterForRemoteNotificationsWithError:
 @brief 推送消息
 @result 错误码
 @note 必接
 */
- (int)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (int)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (int)applicationWillResignActive:(UIApplication *)application;
- (int)applicationDidEnterBackground:(UIApplication *)application;
- (int)applicationWillEnterForeground:(UIApplication *)application;
- (int)applicationDidBecomeActive:(UIApplication *)application;
- (int)applicationWillTerminate:(UIApplication *)application;
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray *  restorableObjects))restorationHandler;
@end
