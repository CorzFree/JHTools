//
//  AffGameSDK.h
//  傲风游戏SDK
//
//  Created by aofeng on 2018/7/23.
//  Copyright © 2018年 aofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RoleData.h"
#import "PayParams.h"

//初始化回调
typedef void (^InitResultListener)(void);

//登录成功回调函数类型
typedef void (^LoginSuccess)(NSString *, NSString *);

//登录失败回调函数类型
typedef void (^LoginFailure)(void);

//支付结果回调函数类型
typedef void (^PayResult)(void);

@interface AffGameSDK : NSObject

@property (nonatomic, strong)UIViewController *viewController;
@property (nonatomic, strong)NSString *gameId;
@property (nonatomic, strong)NSString *clientKey;

+ (AffGameSDK *)defaultService;

//初始化
+ (void)init:(UIViewController *) viewController gameId:(NSString *) gameId clientKey:(NSString *) clientKey initFinish:(InitResultListener) listener;

//登录
- (void)login:(LoginSuccess) success loginFail:(LoginFailure) fail;

//提交角色信息
- (void)updateRoleData:(RoleData *) role;

//支付
- (void)pay:(PayParams *) payParams paySuccess:(PayResult) paySuccess payFail:(PayResult) payFail;

//处理支付结果
- (void)processOrderWithPaymentResult:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

//监听返回游戏事件，处理支付回调
- (void)applicationWillEnterForeground:(UIApplication *)application;
@end
