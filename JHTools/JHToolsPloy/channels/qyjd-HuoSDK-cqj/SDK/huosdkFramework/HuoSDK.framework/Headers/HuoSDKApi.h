//
//  HuoSDKApi.h
//  huosdkProject
//
//  Created by huosdk on 16/6/12.
//  Copyright © 2016年 huosdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//支付所需参数
extern NSString * const key_productID;//商品id
extern NSString * const key_productName;//商品名字
extern NSString * const key_productdesc;//商品描述
extern NSString * const key_ext;//扩展参数，可选
extern NSString * const key_productPrice;//商品金额
extern NSString * const key_cpOrderid; //研发订单号
//浮点可选参数
extern NSString * const key_centerY;//浮点初始化的中心y轴位置
extern NSString * const key_isLeft;//浮点初始化在屏幕左边还是右边

//roleInfo
extern NSString * const key_serverID;//角色所在的serverid 
extern NSString * const key_serverName;//服务器名
extern NSString * const key_roleID;//角色id
extern NSString * const key_roleName;//角色名
extern NSString * const key_roleLevel;//角色等级
extern NSString * const key_partyName; //公会名
extern NSString * const key_roleVip; //角色vip等级
extern NSString * const key_roleBalence; //角色游戏币余额
extern NSString * const key_dataType; //数据类型，1为进入游戏，2为创建角色，3为角色升级，4为退出
extern NSString * const key_rolelevelCtime; //创建角色的时间 时间戳
extern NSString * const key_rolelevelMtime; //角色等级变化时间 时间戳
extern NSString * const key_currencyName; //货币名

typedef void (^HuoSDKMainThreadCallBack)(NSDictionary *responseDic);

@interface HuoSDKApi : NSObject


//外部应用跳转到本应用的时候触发,url为必传参数。
+ (void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

//SDK登录接口，只有在登录成功的时候才会激活回调，登录失败则由sdk处理
+ (void)showLoginWithCallBack:(HuoSDKMainThreadCallBack)receiverBlock;

//登出接口，当用户在游戏菜单登出成功的时候请调用该方法
+ (void)logout;


//登出回调接口，有两种情况会激活该block，1.用户在游戏内进行登出，2.用户在SDK的菜单进行登出成功
+ (void)addLogoutCallBack:(HuoSDKMainThreadCallBack)receiverBlock;
//支付接口
+ (void)buy:(NSDictionary *)info failedBlock:(void (^)())failedBlock;

+ (void)addPaySuccessedCallback:(HuoSDKMainThreadCallBack)receiverBlock;

/*浮点,在登录成功左后调用，如果是浮点已经存在，调用此方法是再次显示，参数为nil即可。
 默认是在左侧中间，超出边界会默认在边上
 @key_centerY;//浮点初始化的中心y轴位置
 @key_isLeft;//浮点初始化在屏幕左边还是右边
 */
+ (void)showFloatView:(NSDictionary *)floatViewInfo;

//如果在某些场景有必要隐藏浮点，可以调用这个方法。
+ (void)hiddenFloat;

//设置角色信息
+ (void)setRoleInfo:(NSDictionary *)roleInfo;


@end
