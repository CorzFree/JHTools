//
//  ChannelSDK_SocialHandler.h
//  ChannelSDK
//
//  Created by YuLing on 2018/5/10.
//  Copyright © 2018年 YuLing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//typedef void(^UJHSDKSocialHandlerLoginSuccessBack)(NSString * paramToken,NSString * openID);//--登录成功返回token和用户的唯一标示--/
//typedef void(^UJHSDKSocialHandlerFailure)(NSError * code);//---网络失败原因---//
@interface ChannelSDK_SocialHandler : NSObject
#pragma mark  必须实现的方法////////////////////////////////////////////////////////////////////////
    /**
     初始化
     @param gamekey 游戏Key
     */
+(void)commonSdk_InitWithGameID:(NSString*)gameID andGamekey:(NSString *)gamekey andSubChannel:(NSString*)subchannel;

    ///**
    // * 登入
    // */
    //-(void)commonSdkaddLogin:(BOOL)isLogin;
    /**
     登录
     */
+(void)commonSdk_ShowLogin:(id)LoginSuccessBlock;
    /**
     注销或退出应用
     */
+(void)commonSdk_ShowLogout;
#pragma mark - 登出回调
    /**
     登出成功的回调
     此方法需要viewDidLoad此处调用（必须在点击支付之前调用，保证它的生命周期）

     @param loginOutSucceed 在block中做登出后的操作
     {
     loginOutSucceed为YES是登出成功。
     loginOutSucceed为NO是登出失败。
     正常情况下都是登出成功
     }
     */
+(void)commonSdk_OutLoginSuccess:(void(^)(BOOL boolSucceed)) loginOutSucceed;
    /**
     提交玩家数据
     @param playerInfo 玩家数据
     */
+(void)commonSdk_SetPlayerInfo:(NSDictionary *)playerInfo;

    /**
     支付
     @param nyPayModel 支付信息
     */
+(void)commonSdk_StartPay:(NSDictionary *)nyPayModel;


    /*浮点,在登录成功左后调用，如果是浮点已经存在，调用此方法是再次显示，参数为nil即可。
     默认是在左侧中间，超出边界会默认在边上
     @key_centerY;//浮点初始化的中心y轴位置
     @key_isLeft;//浮点初始化在屏幕左边还是右边
     */
+(void)showFloatView:(NSDictionary *)floatViewInfo;

    //如果在某些场景有必要隐藏浮点，可以调用这个方法。
+ (void)hiddenFloat;

    //外部应用跳转到本应用的时候触发,url为必传参数。
+ (void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

    /**
     切换应用运行模式，采集登陆数据
     @param isForeground 当isForeground = YES, 应用前台运行；
     当isForeground = NO, 应用后台运行或退出程序；
     @param application  当前应用
     */
+(void)commonSdk_IsWillEnterForeground:(BOOL)isForeground OtherWiseEnterBackgroundOrExitApplication:(UIApplication *)application;
@end
