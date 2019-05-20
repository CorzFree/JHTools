//
//  ReYouGameSDK.h
//  ReYouGameSDK
//
//  Created by ReYouGame on 2018/3/16.
//  Copyright © 2018年 ReYouGame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ASPayOrderInfo;
@class ASRoleInfo;


/**
 登陆失败状态码

 - ASLoginFailureCloseAllWindow: 用户未登陆，关闭所有登陆窗口
 
 - ASLoginFailureShowNotice: 显示公告信息，禁止进入游戏
 
 - ASLoginFailureNoShowNotice: 不显示公告信息，禁止进入游戏
 
 - ASLoginFailureOther: 其他登陆失败状态
 */
typedef NS_ENUM(NSUInteger, ASLoginFailureType)
{
    ASLoginFailureCloseAllWindow, /**< 用户未登陆，关闭所有登陆窗口 */
    ASLoginFailureShowNotice, /**< 显示公告信息，禁止进入游戏 */
    ASLoginFailureNoShowNotice,    /**< 不显示公告信息，禁止进入游戏 */
    ASLoginFailureOther,    /**< 其他登陆失败状态 */
};

/**
 *  登录成功回调函数类型
 *
 * @param token 登录token
 * @param SID 玩家唯一标识
 */
typedef void (^LoginSuccess)(NSString *token, NSString *SID);
/**
 *  登录失败回调函数类型

 * @param loginFailureType 登陆失败状态码
 * @param loginFailureInfo 登陆失败信息
 */
typedef void (^LoginFailure)(ASLoginFailureType loginFailureType,NSString *loginFailureInfo);
/**
 *  注销回调函数类型
 */
typedef void (^LogoutSuccess)(void);
/**
 *  支付结果回调函数类型
 */
typedef void (^PayResult)(void);



@interface ReYouGameSDK : NSObject
/**
 * 兼容以前代码获取SDK实列
 */
+ (instancetype)defaultService;

/**
 *  初始化方法
 *
 *  @param   pid        平台编号
 *  @param   cpid       厂商编号
 *  @param   gid        游戏编号
 *  @param   md5key     参数签名key
 */
+ (void)initSDKWithPID:(NSString *)pid withCPID:(NSString *)cpid withGID:(NSString *)gid withMd5Key:(NSString *)md5key;
/**
 *  登录方法
 *
 *  @param   loginSuccess    登录成功的回调
 *  @param   loginFailure    登录失败的回调
 *  @param   logoutSuccess   登出和注销的回调
 */
+ (void)asLoginWithLoginSuccess:(LoginSuccess)loginSuccess loginFailure:(LoginFailure)loginFailure logoutSuccess:(LogoutSuccess)logoutSuccess;

/**
 *  支付方法
 *
 *  @param   aOrderInfo     订单信息
 *  @param   schemeString   跳转URLschemes，建议填写使用系统方法获取的bundlID，不要写死。
 *  @param   paySuccess     支付成功回调
 *  @param   payFailure     支付失败回调
 */
+ (void)asPayWith:(ASPayOrderInfo *)aOrderInfo
       fromScheme:(NSString *)schemeString
       paySuccess:(PayResult)paySuccess
       payFailure:(PayResult)payFailure;

/**
 *  上传角色信息 (选择角色进入游戏后必须调用，角色信息有较大变化的时候建议调用，比如等级提升，战力提升，vip等级提升等等)
 *
 * 所有参数都是必传，不能为@""，如果没有相关信息，可以默认传0
 */
+ (void)submitRoleInfo:(ASRoleInfo *)aRoleInfo;

/**
 *  必须接入
 */
- (void)processOrderWithPaymentResult:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
/**
 *  必须接入
 */
+ (void)willEnterForeground;
@end


/**
 * 角色提交信息类
 */
@interface ASRoleInfo : NSObject

/** 角色ID (必传，默认传@"1")*/
@property (nonatomic, copy)  NSString *roleID;
/** 角色名称 (必传，默认传@"1")*/
@property (nonatomic, copy)  NSString *roleName;
/** 角色等级 (必传，默认传@"1")*/
@property (nonatomic, copy)  NSString *roleLevel;
/** 区服ID (必传，默认传@"1")*/
@property (nonatomic, copy)  NSString *serverId;
/** 区服名称 (必传，默认传@"1")*/
@property (nonatomic, copy)  NSString *serverName;
/** 游戏币数量 (默认传@"0")*/
@property (nonatomic, copy)  NSString *moneyNum;
/** 角色创建时间，从1970年到现在的时间，单位秒 (默认传@"1")*/
@property (nonatomic, copy)  NSString *roleCreateTime;
/** 角色等级升级时间，角色等级变化时间，从1970年到现在的时间，单位秒 (默认传@"1")*/
@property (nonatomic, copy)  NSString *roleLevelUpTime;
/** Vip等级 (默认传@"0")*/
@property (nonatomic, copy)  NSString *vip;
/** 角色性别 (@"0":女，@"1"：男，@"9":未设置 默认传@"9")*/
@property (nonatomic, copy)  NSString *roleGender;
/** 职业ID (默认传@"0")*/
@property (nonatomic, copy)  NSString *professionID;
/** 职业名称 (默认传@"无")*/
@property (nonatomic, copy)  NSString *professionName;
/** 战力 (默认传@"0")*/
@property (nonatomic, copy)  NSString *power;
/** 公会名 (默认传@"无")*/
@property (nonatomic, copy)  NSString *partyName;
/** 公会ID (默认传@"0")*/
@property (nonatomic, copy)  NSString *partyID;
/** 会长ID (默认传@"0")*/
@property (nonatomic, copy)  NSString *partyMasterID;
/** 会长名 (默认传@"无")*/
@property (nonatomic, copy)  NSString *partyMasterName;


/**
 *  上传角色信息 (选择角色进入游戏后必须调用，角色信息有较大变化的时候建议调用，比如等级提升，战力提升，vip等级提升等等)
 *
 * 所有参数都是必传，不能为@""，如果没有相关信息，可以默认传0
 *  @param  roleID  角色ID    (必传，默认传@"1")
 *  @param  roleName  角色名   (必传，默认传@"1")
 *  @param  roleLevel   等级  (必传，默认传@"1")
 *  @param  serverId    服务器ID   (必传，默认传@"1")
 *  @param  serverName  服务器名    (必传，默认传@"1")
 *  @param  moneyNum    游戏币数量   (默认传@"0")
 *  @param  roleCreateTime  角色创建时间，从1970年到现在的时间，单位秒 (默认传@"1")
 *  @param  roleLevelUpTime 当前等级升级时间，角色等级变化时间，从1970年到现在的时间，单位秒  (默认传@"1")
 *  @param  vip             vip等级   (默认传@"0")
 *  @param  roleGender      角色性别    (@"0":女，@"1"：男，@"9":未设置 默认传@"9")
 *  @param  professionID    职业id    (默认传@"0")
 *  @param  professionName  职业名称     (默认传@"无")
 *  @param  power           战力      (默认传@"0")
 *  @param  partyID         工会ID    (默认传@"0")
 *  @param  partyName       工会名     (默认传@"无")
 *  @param  partyMasterID   会长ID     (默认传@"0")
 *  @param  partyMasterName 会长名     (默认传@"无")
 */
+ (instancetype)roleInfoWithRoleID:(NSString *)roleID
                          roleName:(NSString *)roleName
                         roleLevel:(NSString *)roleLevel
                          serverId:(NSString *)serverId
                        serverName:(NSString *)serverName
                          moneyNum:(NSString *)moneyNum
                    roleCreateTime:(NSString *)roleCreateTime
                   roleLevelUpTime:(NSString *)roleLevelUpTime
                               vip:(NSString *)vip
                        roleGender:(NSString *)roleGender
                      professionID:(NSString *)professionID
                    professionName:(NSString *)professionName
                             power:(NSString *)power
                           partyID:(NSString *)partyID
                         partyName:(NSString *)partyName
                     partyMasterID:(NSString *)partyMasterID
                   partyMasterName:(NSString *)partyMasterName;
@end

/**
 * 支付订单信息类
 */
@interface ASPayOrderInfo : NSObject <NSCopying>

/** 用户ID，登录回调获取*/
@property (nonatomic, copy) NSString *userId;
/** 用户名，登录回调获取*/
@property (nonatomic, copy) NSString *userName;

/** 支付金额*/
@property (nonatomic, copy) NSString *payMoney;
/** 商品名*/
@property (nonatomic, copy) NSString *goodsName;
/** 商品描述*/
@property (nonatomic, copy) NSString *goodsBody;
/** 商品ID*/
@property (nonatomic, copy) NSString *productId; /**< 商品ID(appstore上架游戏需要与productID配置表相同，越狱没有要求) */
/** 游戏名称*/
@property (nonatomic, copy) NSString *gameName;
/** 游戏大区*/
@property (nonatomic, copy) NSString *gameArea;
/** 订单备注信息*/
@property (nonatomic, copy) NSString *memo;
/** 角色ID*/
@property (nonatomic, copy)  NSString *roleID;
/** 角色名*/
@property (nonatomic, copy)  NSString *roleName;
/** 服务器ID*/
@property (nonatomic, copy)  NSString *serverId;
/** 服务器名称*/
@property (nonatomic, copy)  NSString *serverName;
/** 游戏透传信息 (请填写透传信息) 旧memo改为备注*/
@property (nonatomic, copy)NSString *extension;
/** 游戏发货回调地址,可选,如若填写,为第一优先回调地址*/
@property (nonatomic, copy)NSString *gameCallbackUrl;

/**
 *  订单信息构造方法
 *
 *  @param   userId         用户ID，登录回调获取 (必传)
 *  @param   userName       用户名，登录回调获取 (默认传@"无")
 *  @param   payMoney       支付金额 (单位：元，必传)
 *  @param   goodsName      商品名称，比如100元宝，500钻石... (必传，默认传@"无")
 *  @param   goodsBody      商品描述，比如 充值100元宝，赠送20元宝  (必传，默认传@"无")
 *  @param   productId      商品ID(appstore上架游戏需要与productID配置表相同，越狱没有要求)
 *  @param   gameName       游戏名称    (必传，默认传@"无")
 *  @param   gameArea       游戏大区    (必传，默认传@"1")
 *  @param   memo           订单备注信息  (默认传@"无")
 *  @param   roleID         角色ID    (必传，默认传@"1")
 *  @param   roleName       角色名     (必传，默认传@"1")
 *  @param   serverId       服务器ID (必传，默认传@"1")
 *  @param   serverName     服务器名称 (必传，默认传@"1")
 *  @param   extension      游戏透传信息  (必传，请填写透传信息,可传入订单号码，默认传@"1")
 *  @param   gameCallbackUrl 游戏发货回调地址  (可选,默认填@"",如若填写,为第一优先回调地址)
 */
+ (instancetype)payOrderInfoWithUserId:(NSString *)userId
                              username:(NSString *)userName
                              payMoney:(NSString *)payMoney
                             goodsName:(NSString *)goodsName
                             goodsBody:(NSString *)goodsBody
                             productId:(NSString *)productId
                              gameName:(NSString *)gameName
                              gameArea:(NSString *)gameArea
                                  memo:(NSString *)memo
                                roleID:(NSString *)roleID
                              roleName:(NSString *)roleName
                              serverId:(NSString *)serverId
                            serverName:(NSString *)serverName
                             extension:(NSString *)extension
                       gameCallbackUrl:(NSString *)gameCallbackUrl;
@end
