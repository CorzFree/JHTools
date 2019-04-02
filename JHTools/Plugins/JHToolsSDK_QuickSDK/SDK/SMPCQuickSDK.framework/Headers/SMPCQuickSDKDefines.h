//
//  SMPCQuickSDKDefines.h
//  QuickSDKs
//
//
//

#ifndef QuickSDKs_SMPCQuickSDKDefines_h
#define QuickSDKs_SMPCQuickSDKDefines_h

#pragma mark - Notification Name

extern NSString* const kSmpcQuickSDKNotiInitDidFinished;   //初始化成功
extern NSString* const kSmpcQuickSDKNotiLogin;             //登录成功 切换账号成功也会回调这个
extern NSString* const kSmpcQuickSDKNotiLogout;            //用户注销
extern NSString* const kSmpcQuickSDKNotiRecharge;          //充值结果
extern NSString* const kSmpcQuickSDKNotiPauseOver;         //暂停结束 这个回调可以不用监听
extern NSString * const kSmpcQuickSDKNotiPlugin;           /*组件通知 见该插件接入文档，默认可以不用监听*/

#define QUICK_CHANNEL_TO_CP_NOTIFICATON_KEY @"quick_channel_to_cp_notification_key" //QUICK_CHANNEL_TO_CP_NOTIFICATON_KEY这个键定义了QuickSDK标准接口不能提供更多的信息给cp那边时的传输方案，这个通知带上渠道SDK需要传递到cp的信息.通常不需要，遇到了再讨论

#pragma mark - 通知userInfo中的重要key 错误和信息

extern NSString* const kSmpcQuickSDKKeyError;    /*Notification userinfo error Key */
extern NSString* const kSmpcQuickSDKKeyMsg;      /*Notification userinfo msg   Key */

// QuickSDK 的订单号
#define kSmpcQuickSDKKeyOrderId              @"orderId"
// 游戏开发商给的订单号
#define kSmpcQuickSDKKeyCpOrderId            @"cpOrderId"
// 第3方渠道sdk给的订单号
#define kSmpcQuickSDKKeySdkOrderId           @"sdkOrderId"
// 透传参数
#define kSmpcQuickSDKKeyExtraParams          @"extraParams"
// user_token
#define kSmpcQuickSDKKeyUserToken            @"user_token"

#pragma mark - 浮动条位置 Enum
typedef enum {
    SMPC_QUICK_SDK_TOOLBAR_TOP_LEFT  = 1,           /* 左上 */
    SMPC_QUICK_SDK_TOOLBAR_TOP_RIGHT = 2,           /* 右上 */
    SMPC_QUICK_SDK_TOOLBAR_MID_LEFT  = 3,           /* 左中 */
    SMPC_QUICK_SDK_TOOLBAR_MID_RIGHT = 4,           /* 右中 */
    SMPC_QUICK_SDK_TOOLBAR_BOT_LEFT  = 5,           /* 左下 */
    SMPC_QUICK_SDK_TOOLBAR_BOT_RIGHT = 6,           /* 右下 */
}SMPC_QUICK_SDK_TOOLBAR_PLACE;


#pragma mark - 错误码

typedef enum {
    SMPC_QUICK_SDK_ERROR_NONE                      = 0,    /* 没有错误 */
    SMPC_QUICK_SDK_ERROR_UNKNOWN                   = -1,    /* 未知错误 */
    SMPC_QUICK_SDK_ERROR_NETWORK                   = -2,    /* 网络连接错误 */
    SMPC_QUICK_SDK_ERROR_CHECKFAILED               = -3,    /* 登录校验失败 */
    SMPC_QUICK_SDK_ERROR_CHECKLOGINING             = -4,    /* 正在校验登录 */
    SMPC_QUICK_SDK_ERROR_PARAM                     = -10,   /* 参数错误 */
    SMPC_QUICK_SDK_ERROR_NOT_INIT                  = -20,   /* 还没有初始化 */
    SMPC_QUICK_SDK_ERROR_INIT_FAILED               = -21,   /* 初始化失败*/
    SMPC_QUICK_SDK_ERROR_UNSUPPORTED               = -100,  /* 功能不被支持 */
    
    SMPC_QUICK_SDK_ERROR_NOT_LOGIN                 = -301,  /* 没有登录用户 */
    SMPC_QUICK_SDK_ERROR_HAD_LOGIN                 = -302,  /* 已有登录用户 */
    SMPC_QUICK_SDK_ERROR_LOGOUT_FAIL               = -303,  /* 用户登出失败 */
    
    SMPC_QUICK_SDK_ERROR_RECHARGE_FAILED           = -400,  /* 充值失败 */
    SMPC_QUICK_SDK_ERROR_RECHARGE_CANCELLED        = -401,  /* 用户充值取消 */
    
    
}SMPC_QUICK_SDK_ERROR_CODE;
typedef enum {
    SMPC_QUICK_SDK_FUNC_TYPE_PAUSED_GAME       = 1, /*暂停游戏*/
    SMPC_QUICK_SDK_FUNC_TYPE_ENTER_USER_CENTER = 2, /*进入用户中心*/
    SMPC_QUICK_SDK_FUNC_TYPE_ENTER_BBS         = 3, /*进入论坛*/
//    SMPC_QUICK_SDK_FUNC_TYPE_OPEN_URL          = 4，
    SMPC_QUICK_SDK_FUNC_TYPE_SHOW_TOOLBAR      = 5, /*显示浮动工具栏*/
    SMPC_QUICK_SDK_FUNC_TYPE_HIDE_TOOLBAR      = 6, /*隐藏浮动工具栏*/
    SMPC_QUICK_SDK_FUNC_TYPE_ENTER_CUSTOMER_CENTER = 7, /*进入客服中心*/
}SMPC_QUICK_SDK_FUNC_TYPE;
#endif
