//
//  YYSDK.h
//  YYMobileGame
//
//  Created by wrc on 17/6/18.
//  Copyright © 2017年 Fate. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YYSDKInstance [YYSDK sharedInstance]

@protocol YYSDKDelegate <NSObject>
@optional
/**
 登录成功回调
 
 @param resultDic 回调信息
 */
- (void)loginSuccessCallBack:(NSDictionary*)resultDic;

/**
 退出登录回调
 
 @param resultDic 回调信息
 */
- (void)loginOutSuccessCallBack:(NSDictionary*)resultDic;

/**
 支付完成回调
 
 @param resultStr 成功：success 失败：失败详情或failure
 @param payType 使用的支付类型
 */
- (void)paySuccessCallBack:(NSString*)resultStr  withPaytype:(NSString*)payType;

/**
 手机绑定成功回调
 */
- (void)bindPhoneSuccess;

/**
 实名绑定成功回调
 */
- (void)bindIdentityCardSuccess;

@end

@interface YYSDK : NSObject

@property (nonatomic,strong) UIWindow *myKeyWindow;

@property (nonatomic,weak) id<YYSDKDelegate> delegate;

/**
 *单例方法
 */
+ (YYSDK *)sharedInstance;

/**
 初始化SDK
 */
- (void)initYYSDK;

/**
 应用间跳转访问（包括支付宝原生、汇付宝、盒子跳转）
 */
+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url;

/**
 * 判断是否有登录记录（如果有“快速登录”页面否则“账号登录界面”）
 */
- (void)loginMarkOrAccountlogin;

/**
 * 切换账号(进入选择登录方式界面，有登出回调)
 */
- (void)showChangeAccount;

/**
 调起支付页面
 
 @param order 订单号
 @param info 订单描述（比如：10元宝）
 @param money 金额
 @param myServer 区服id
 @param ext 透传参数(如未指定，使用nil)
 */
- (void)showPayControllerViewWithOrder:(NSString*)order info:(NSString*)info money:(NSString*)money server:(NSString*)myServer ext:(nullable NSString *)ext;

/**
 角色上传
 
 @param server 区服id
 @param role 角色名称
 @param level 角色等级
 @param gid 角色id
 @param area 区服名称
 */
- (void)uploadRoleServer:(NSString*)server andRole:(NSString*)role andLevel:(NSString*)level andGid:(NSString*)gid andArea:(NSString*)area;

/**
 手机绑定界面
 */
- (void)showPhoneBindView;

/**
 实名绑定界面
 */
- (void)showIdentityCardView;

/**
  显示开通悠钻
 */
- (void)showUDiamondView:(NSString *)type;

/**
 显示客服界面
 */
- (void)showCustomerService;

/**
 显示礼包界面
 */
- (void)showGiftPackage;

/**
 显示兑换礼包界面
 */
- (void)showConvertGiftPackage;
/**
 * 悬浮按钮消失
 */
- (void)dissYYRobotMainView;

//*************************以下方法为内部使用，如有必要可自行调用************************
/**
 保存用户信息
 */
- (void)userNameInfo:(NSString *)userName useridInfo:(NSString *)userid tokenInfo:(NSString*)token;

/**
 * 检测是否注册支付宝和微信(url scheme),init时会自动检测
 */
+(void)dwq_registerApp;

/**
 * 弹出“有登录记录”的“登录界面”
 */
- (void)showLoginMarkViews;

/**
 * “账号登录界面“
 */
- (void)showAccountloginViews;

/**
 * 悬浮按钮展示
 */
- (void)showYYRobotMainView;

/**
 * 调用“用户进入游戏提示标语”
 */
- (void)showUserEnterGameTipsMark;

/**
 登录方式选择界面(无退出回调)
 */
- (void)showLoginMethodSeletedView;
/**
 * 支付包原生跳转回调（使用application: openURL:替代）
 */
+(BOOL)dwq_handleUrl:(NSURL*)url;

@end

