//
//  PolymerizeSDK_kit.h
//  PolymerizeSDK
//
//  Created by ylwl on 2017/11/1.
//  Copyright © 2017年 com.youguu.h5gameCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYPayModel.h"
#import "JHRoleModel.h"
#pragma mark  block 申明
typedef void(^ylLoginSuccessBack)(NSString * paramToken);
typedef void (^ylPayResultCallBack)(BOOL state);

@interface PolymerizeSDK_kit : NSObject
/**
  *  聚合SDK  用户账号
  */
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * subUserName;
@property(nonatomic,copy)NSString * JH_Token;

#pragma mark  一次设置好，永久使用
@property(nonatomic,assign)BOOL  JHstate;//默认为NO，即通过游戏PC，代码传入pid和key，统一（聚合层和渠道层一致）；yes 表示，已plist数据为准
@property(nonatomic,assign)BOOL JHskipState;//是否跳过聚合，直接到渠道成
@property(nonatomic,copy)NSString * JHMainChannel;
@property(nonatomic,copy)NSString * JH_PID;
@property(nonatomic,copy)NSString * JH_APPKey;
@property(nonatomic,copy)NSString * JH_Version;
@property(nonatomic,copy)NSString * channel;//渠道标记 //LBWan-萝卜玩/xhgame-红蟹/deep425-425/deep19196-19196
@property(nonatomic,copy)NSDictionary *subChannel;//子渠道基本信息
/**
 * @brief 充值成功状态   充值回调
 */
@property (nonatomic, copy) ylPayResultCallBack  ylPayBlock;



+ (PolymerizeSDK_kit *)sharedInstance;
#pragma mark  必须实现的方法////////////////////////////////////////////////////////////////////////
/**
 初始化
 @param gamekey 游戏Key
 */
+ (void)commonSdk_InitWithGameID:(NSString*)gameID andGamekey:(NSString *)gamekey andChannel:(NSString*)channel;
/**
 登录成功block返回
 */
+ (void)commonSdk_ShowLogin:(ylLoginSuccessBack)ylLoginSuccessBlock;

/**
 注销或退出应用
 */
+ (void)commonSdk_ShowLogout;

#pragma mark - 登出回调
+ (void)commonSdk_OutLoginSuccess:(void(^)(BOOL boolSucceed_1)) loginOutSucceed;

/**
 提交玩家数据
 @param playerInfo 玩家数据
 */
+ (void)commonSdk_SetPlayerInfo:(JHRoleModel *)playerInfo;

/**
 支付
 @param payInfo 支付信息
 */
+ (void)commonSdk_StartPay:(NYPayModel *)payInfo;


#if _IPAD_OS_VERSION_MAX_ALLOWED >= _IPAD_6_0
+(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window;
#endif

//外部应用跳转到本应用的时候触发,url为必传参数。
+(void)application:(UIApplication *_Nullable)application openURL:(NSURL *_Nullable)url sourceApplication:(NSString *_Nullable)sourceApplication annotation:(id _Nonnull )annotation;
/**
 切换应用运行模式，采集登陆数据
 @param isForeground 当isForeground = YES, 应用前台运行；
 当isForeground = NO, 应用后台运行或退出程序；
 @param application  当前应用
 */
+ (void)commonSdk_IsWillEnterForeground:(BOOL)isForeground OtherWiseEnterBackgroundOrExitApplication:(UIApplication *_Nullable)application;
#pragma mark  非必须实现扩展接口//////////////////////////////////////////////////////////////////////
/**
 配置客户端返回url处理    跳app外部链接
 @param url URL Schemes
 */
+ (void)commonSdk_OpenUrl:(NSURL *_Nullable)url;
/**
 获取本地渠道的配置信息
 @return 配置信息
 */
+ (NSString *_Nullable)commonSdk_GetPlatformData;

#pragma mark /////////////////////////////////////////////
#pragma *****
#pragma mark 隐藏悬浮球，和显示悬浮球，只有部分渠道，有这块功能；
#pragma *****
#pragma mark /////////////////////////////////////////////
/*浮点,在登录成功左后调用，如果是浮点已经存在，调用此方法是再次显示，参数为nil即可。
 默认是在左侧中间，超出边界会默认在边上
 @key_centerY;//浮点初始化的中心y轴位置
 @key_isLeft;//浮点初始化在屏幕左边还是右边
 */
+(void)showFloatView:(NSDictionary *_Nullable)floatViewInfo;
//如果在某些场景有必要隐藏浮点，可以调用这个方法。
+(void)hiddenFloat;
@end
