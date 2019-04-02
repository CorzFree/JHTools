//
//  TQWSDKDefines.h
//  tao7wan
//
//  Created by wanggp on 2018/8/8.
//  Copyright © 2018年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Notification Name

extern NSString* const tqwSDKNotiLogin;             //登录成功
extern NSString* const tqwSDKNotiRegist;            //注册成功
extern NSString* const tqwSDKNotiLogout;            //用户注销
extern NSString* const tqwSDKNotiRecharge;          //充值结果

#pragma mark - 通知userInfo中的重要key 错误和信息

extern NSString* const tqwSDKKeyCode;    /*Notification userinfo code Key */
extern NSString* const tqwSDKKeyMsg;      /*Notification userinfo msg   Key */

// 开发商生成的订单号
#define tqwSDKKeyTradeId              @"trade_id"

#pragma mark - 错误码

typedef enum {
    TQW_SDK_ERROR_NONE                      = 0,    /* 没有错误 */
    TQW_SDK_ERROR_UNKNOWN                   = -1,    /* 未知错误 */
    TQW_SDK_ERROR_NETWORK                   = -2,    /* 网络连接错误 */
    TQW_SDK_ERROR_CHECKFAILED               = -3,    /* 登录校验失败 */
    TQW_SDK_ERROR_CHECKLOGINING             = -4,    /* 正在校验登录 */
    TQW_SDK_ERROR_PARAM                     = -10,   /* 参数错误 */
    TQW_SDK_ERROR_NOT_INIT                  = -20,   /* 还没有初始化 */
    TQW_SDK_ERROR_INIT_FAILED               = -21,   /* 初始化失败*/
    TQW_SDK_ERROR_UNSUPPORTED               = -100,  /* 功能不被支持 */
    
    TQW_SDK_ERROR_NOT_LOGIN                 = -301,  /* 没有登录用户 */
    TQW_SDK_ERROR_HAD_LOGIN                 = -302,  /* 已有登录用户 */
    TQW_SDK_ERROR_LOGOUT_FAIL               = -303,  /* 用户登出失败 */
    
    TQW_SDK_ERROR_RECHARGE_FAILED           = -400,  /* 充值失败 */
    TQW_SDK_ERROR_RECHARGE_CANCELLED        = -401,  /* 用户充值取消 */
    
    
}TQW_SDK_ERROR_CODE;

#pragma mark - 支付状态码
typedef enum {
    TQW_SDK_ORDER_STATAS_CODE_FAIL = -1,    /*生成订单错误 */
    TQW_SDK_PAY_STATAS_CODE_SUCCESS = 0,    /*支付成功 */
    TQW_SDK_PAY_STATAS_CODE_PAYING = 1,     /*等待支付*/
    TQW_SDK_PAY_STATAS_CODE_PADING = 2,     /*支付中*/
    TQW_SDK_PAY_STATAS_CODE_FAIL = 3,      /*支付失败*/
    TQW_SDK_PAY_STATAS_CODE_CANCEL = 4,     /*支付取消*/
}TQW_SDK_PAY_STATAS_CODE;

#pragma mark - 浮动条位置 Enum
typedef enum {
    TQW_SDK_TOOLBAR_TOP_LEFT  = 1,           /* 左上 */
    TQW_SDK_TOOLBAR_TOP_RIGHT = 2,           /* 右上 */
    TQW_SDK_TOOLBAR_MID_LEFT  = 3,           /* 左中 */
    TQW_SDK_TOOLBAR_MID_RIGHT = 4,           /* 右中 */
    TQW_SDK_TOOLBAR_BOT_LEFT  = 5,           /* 左下 */
    TQW_SDK_TOOLBAR_BOT_RIGHT = 6,           /* 右下 */
}TQW_SDK_TOOLBAR_PLACE;


#pragma mark - 统计
/**
 统计的场景类别，默认为普通统计；若使用游戏统计API，则需选择游戏场景类别，如E_UM_GAME。
 */
typedef enum
{
    OPEN =0 ,//添加游戏打开日志
    REG,    //成功创建新的游戏角色时调用
    LOGIN,  //成功登入游戏时调用
    LEVEL,  //添加游戏用户升级日志
    ORDERS, //创建订单日志
    FISISHORDERS,//添加订单完成
    UPORDERS //添加订单完成日志
}AppgameCollectAction;

extern NSString *const  CONTINENT;     //洲 比如:AS(亚洲)
extern NSString *const  COUNTRY;     //国家 比如:CHN(中国)
extern NSString *const  REGION;     //省份
extern NSString *const  CITY;     //城市
extern NSString *const  IP;     //客户端ip地址

extern NSString * const  SERVERID ;  //服务器标识
extern NSString * const  ACCOUNT ;     //账号
extern NSString * const  ROLEID ;        //角色编号
extern NSString * const  LEVEL_NUM ;        //等级
extern NSString * const MOBILE ;// 电话


//添加创建订单日志
///////////////////////////////
extern NSString * const  TRADE_ID ;        //交易id
extern NSString * const  APPGAME_ORDER_ID ;        //订单id
extern NSString * const  CURRENCY ;        //币种单位
extern NSString * const  PRODUCT_NAME ;        //商品名称
extern NSString * const  AMOUNT ;        //订单金额
extern NSString * const  AMOUNT_IN_CURRENCY ;        //币种金额
extern NSString * const  CREATED_AT ;        //创建时间

//添加订单完成日志
///////////////////////////////
extern NSString * const  STATUS ;//   订单状态
extern NSString * const  COMPLETED_AT ;    //   完成时间
extern NSString * const  CANCELED_AT ;    //   取消时间
extern NSString * const  SANDBOX  ;  // 否



@interface TQWSDKDefines : NSObject

+(NSString *) getActionString:(AppgameCollectAction)collectAction;

@end
