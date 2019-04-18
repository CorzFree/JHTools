//
//  BoRanSDKManager.h
//  boRanSDK
//
//  Created by jx on 16/11/8.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BoRanSDKManager : NSObject
@property(nonatomic,assign)BOOL allowRotation;
@property(strong,nonatomic)NSString *lastTime;

/**
 * 获取泊然工具类对象;
 */
+(BoRanSDKManager*)share6lsdk;


/*支付
 *@param1:money 商品价格;
 *@param2:roleId 角色ID;
 *@param3:roleName 角色名称;
 *@param4:extInfo 扩展参数
 *@param5:serverId serverName 服务器id;
 */
+(void)PayWithMoney:(NSString*)money RoleId:(NSString*)roleId RoleName:(NSString*)roleName ExtInfo:(NSString*)extInfo ServerId:(NSString*)serverId Product:(NSString*)product;




/*初始化泊然sdk
 *@param:  appId    唯一标示符
 *@param:  appKey   唯一标示符
 *@param:  appScheme  应用唯一标示，用于应用间的跳转
 *@param:  direction 当前游戏的横竖屏, NO:竖屏  YES:横屏;
 */
+(void)initializeBoRanSDKWithAppId:(NSString *)appId appKey:(NSString *)appKey appScheme:(NSString *)appScheme direction:(int)direction;



/*角色上报
 *@param1:serverId 服务器ID;
 *@param2:serverName 服务器名称;
 *@param3:roleId 角色ID;
 *@param4:roleName 角色名称;
 *@param4:roleLevel 角色等级;
 */
+(void)sendFforRoleWithServerId:(NSString*)serverId ServerName:(NSString*)serverName wRoleId:(NSString*)roleId roleName:(NSString*)roleName roleLevel:(NSString*)roleLevel;



/*添加公告
 *@param:  view 需要加公告的父视图;
 */
+(BOOL)addAnnounceViewWithView:(UIView*)view;


/*添加登录界面
 *@param:  view 需要加登录界面的父视图;
 */
+(void)addLoginView:(UIViewController *)controller;


/*添加悬浮窗界面
 *@param:  view 需要加悬浮窗的父视图;
 */
+(void)addAssistiveView:(UIView *)view;


/*
 *注销登录
 */
+(void)logout;


/*
 *切换登录
 */
+ (void) switchAccount;


/*
 *进入用户中心
 */
+(void)showAccountCenter;


@end
