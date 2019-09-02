//
//  LTManager.h
//  LTSDK
//
//  Created by F on 2018/11/10.
//  Copyright © 2018年 LT. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LTOrder;
@class LTRequestImp;
@class LTRoleModel;


@protocol LTLoginDelegate <NSObject>
@optional

/**
 登录成功
 */
- (void)loginSuccess;

/**
 登录失败
 */
- (void)loginFail;
@end

@protocol LTManagerDelegate <LTLoginDelegate>

@end
@interface LTManager : NSObject

@property (nonatomic, weak) id<LTManagerDelegate> delegate;

@property (nonatomic, copy, readonly) NSDictionary * userInfo;
/**
 用户id(分享时使用)
 */
@property (nonatomic, copy, readonly) NSString * uid;

/**
 用户token
 */
@property (nonatomic, copy, readonly) NSString * uToken;
/**
 分享人用户id
 */
@property (nonatomic, copy) NSString * from_uid;

/**
 游戏id
 */
@property (nonatomic, copy) NSString * gameId;
/**
 是否手机注册，默认YES
 */
@property (nonatomic, assign) BOOL isPhoneRegister;
/**
 创建单例
 */
+ (instancetype)shareManager;

/**
 处理微信、QQ、微博通过URL启动App时传递的数据

 @param url 启动第三方应用时传递过来的URL
 */
- (void)handleOpenURL:(NSURL *)url;
/**
 用户登录
 */
- (void)userLogin;

/**
 用户注册
 */
- (void)userRegister;

/**
 充值

 @param order 创建订单所需参数
 @param rechargeMoney 充值元宝数
 @param appScheme 支付宝支付时使用，应用注册scheme,在Info.plist定义URL types
 */
- (void)payWithOrder:(LTOrder *)order rechargeMoney:(NSString *)rechargeMoney appScheme:(NSString *)appScheme;
/**
 分享
 */
- (void)share;

/**
 上传角色信息

 @param role 角色模型
 @param isCreateRole 仅创建角色时传true,更新信息时传false
 */
- (void)uploadGameRoleInfoWithRole:(LTRoleModel *)role isCreateRole:(NSString *)isCreateRole;

/**
 显示悬浮窗
 */
- (void)showSuspensionView;

/**
 删除悬浮窗
 */
- (void)removeSuspensionView;
@end
