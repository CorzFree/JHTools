//
//  XiaomoToolsApi.h

//
//  Created by 小默手游 .
//  Copyright © 小默手游. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"
#import "PlayerInfo.h"

@protocol XiaomoToolsApiDelegate;

typedef void(^CompletionBlock)(NSDictionary *resultDic);


@protocol XiaomoToolsApiDelegate <NSObject>

@optional
//悬浮窗点击事件
- (void)clickLoginoutBtn:(NSDictionary *)exitDic;

@end


@interface XiaomoToolsApi : NSObject

@property(nonatomic,unsafe_unretained)id<XiaomoToolsApiDelegate> assistiveDelegate;

/**
 *  创建单例服务
 *
 *  @return 返回单例对象
 */
+ (XiaomoToolsApi *)sharedInstance;
/**
 *  初始化方法,在应用didFinishLaunchingWithOptions中调用
 */
- (BOOL)initApi:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
/**
 *  登录接口
 *  @param completion     登录结果回调Block
 */
- (void)showLoginView:(CompletionBlock)completion;

/**
 *  注销
 *
 *  @param exitBlock     退出回调Block
 */
- (void)moExitLogin:(CompletionBlock)exitBlock;

- (void)moClickLoginOut;

/**
 *  交换接口
 *
 *  @param orderStr        订单信息
 *  @param completionBlock 交换结果回调Block
 */
- (void)moPushExchange:(OrderInfo *)orderStr completionBlock:(CompletionBlock)completionBlock;

/**
 *  上传角色信息接口
 *  @param playerInfo 玩家信息
 *  @param resultDict 上传结果回调Block
 */
- (void)moAddPlayerInfo:(PlayerInfo *)playerInfo completionBlock:(void(^)(NSDictionary *resultDict))resultDict;

/**
 *  悬浮窗
 *  @param completionBlock 悬浮窗退出按钮结果回调Block
 */
- (void)moAddFloatingView;
/**
 *  移除悬浮窗
 */
- (void)removeFloatingView;
/**
 *      修改玩家等级
 *  @param NSString  玩家等级
 *  @param resultDict  返回修改结果
 */
- (void)changePlayerLevel:(NSString *)playerLevel completionBlock:(CompletionBlock)completionBlock;
/**
 *  修改角色名称
 *
 *@param NSString  角色名称
 *@param resultDict  返回修改结果
 */
- (void)changeRoleName:(NSString *)roleName completionBlock:(CompletionBlock)completionBlock;

/**
 *  游戏参数
 */
- (void)gameDetailView;

/**
 * 防沉迷回调
 *@param resultDict  返回修改结果
 */
- (void)getUserType:(CompletionBlock)typeBlock;
/**
 *  当前版本号
 *@param NSString  返回版本号
 */
- (NSString *)versionStr;
/*
 * @return UUID（不涉及私有API）
 **/
- (NSString *)deviceUUID;
/*
 * @return 屏幕分辨率
 **/
- (NSString *)deviceSize;
/*
 * @return 设备操作系统 (例：iPhone OS9.3.2)
 **/
- (NSString *)deviceSystemName;
/*
 * @return 当前网络状态 （当前网络状态不可达、Wifi、2G、3G、4G、WWAN、未知）
 **/
- (NSString *)currentNetWork;
/*
 * @return 设备运营商
 **/
- (NSString *)currentOperator;
/*
 * @return 手机型号 iPhone 系列、iPod 系列、iPad 系列、火星（火星代表未知）
 **/
- (NSString *)deviceModel;

/**
 *  用于入口类文件处理第三方回调
 *
 */
- (void)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

- (void)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

-(void)lumoCpsTagGet;

@end




