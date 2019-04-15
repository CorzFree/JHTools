//
//  JHToolsSDK_BeiMei.m
//  JHToolsSDK_BeiMei
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_BeiMei.h"
#import "YYSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"

@interface JHToolsSDK_BeiMei()<YYSDKDelegate>

@property (nonatomic, copy) NSString * uid;

@end

@implementation JHToolsSDK_BeiMei

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    //获取info.plist文件中的配置的can'shu
    //NSString *appID = [params valueForKey:@"qiqu_appid"];
    //NSString *appKey = [params valueForKey:@"qiqu_appkey"];
    //NSString *channelID = [params valueForKey:@"qiqu_channel"];
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}

//-(BOOL) getBoolForParam:(NSString*)key default:(BOOL)defaultValue;
//-(UIView*) view;
//-(UIViewController*) viewController;
//-(id) getInterface:(Protocol *)aProtocol;
//-(void) eventPlatformInit:(NSDictionary*) params;
//-(void) eventUserLogin:(NSDictionary*) params;
//-(void) eventUserLogout:(NSDictionary*) params;
//-(void) eventPayPaid:(NSDictionary*) params;
//-(void) eventCustom:(NSString*)name params:(NSDictionary*)params;

//-(BOOL) isInitCompleted;
//-(void) setupWithParams:(NSDictionary*)params;
//-(void) submitExtraData:(JHToolsUserExtraData*)data;

// UIApplicationDelegate事件
//- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation;

//- (BOOL)application:(UIApplication *)application openURL:(NSURL*)url options:(NSDictionary *)options;

//- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url;
//- (void)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
//
//- (void)applicationWillResignActive:(UIApplication *)application;
//- (void)applicationDidEnterBackground:(UIApplication *)application;
//- (void)applicationWillEnterForeground:(UIApplication *)application;
//- (void)applicationDidBecomeActive:(UIApplication *)application;
//- (void)applicationWillTerminate:(UIApplication *)application;
//
//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
//- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
//
//- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification;
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;


- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    NSLog(@"func:%s,line:%d",__func__,__LINE__);
    return [YYSDK application:application openURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL*)url options:(NSDictionary *)options {
    NSLog(@"func:%s,line:%d",__func__,__LINE__);
    return [YYSDK application:application openURL:url];
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url {
    NSLog(@"func:%s,line:%d",__func__,__LINE__);
    return [YYSDK application:application openURL:url];
}

- (void)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //YYSDK初始化
    [[YYSDK sharedInstance] initYYSDK];
    //设置代理
    [YYSDK sharedInstance].delegate = self;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    //测试：弹出自动登录界面
    [[YYSDK sharedInstance] loginMarkOrAccountlogin];
}

- (void) logout{
    [[YYSDK sharedInstance] dissYYRobotMainView];
}

- (void) switchAccount{
}

- (BOOL) hasAccountCenter{
    return NO;
}

- (void) loginCustom:(NSString*)customData{
}

- (void) showAccountCenter{
}

- (void)submitUserInfo:(JHToolsUserExtraData *)userlog {
    //测试：上传角色（需登录成功后测试）
    [[YYSDK  sharedInstance] uploadRoleServer:[NSString stringWithFormat:@"%d",userlog.serverID] andRole:[JHToolsUtils stringValue:userlog.roleName] andLevel:[JHToolsUtils stringValue:userlog.roleLevel] andGid:[JHToolsUtils stringValue:userlog.roleID] andArea:[JHToolsUtils stringValue:userlog.serverName]];
}


#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            [[YYSDK sharedInstance] showPayControllerViewWithOrder:[JHToolsUtils stringValue:orderNo] info:[JHToolsUtils stringValue:profuctInfo.productDesc] money:[NSString stringWithFormat:@"%@",profuctInfo.price] server:[JHToolsUtils stringValue:profuctInfo.serverId] ext:[JHToolsUtils stringValue:orderNo]];
        }else{
            [HNPloyProgressHUD showFailure:@"创建聚合订单失败！"];
        }
    }];
    
}

-(void) closeIAP{
}

-(void) finishTransactionId:(NSString*)transactionId{
}


//登录完成回调
- (void)loginSuccessCallBack:(NSDictionary *)resultDic {
    NSLog(@"登录完成：Result = %@",resultDic);
    if (resultDic) {
        NSString * userid = @"";
        NSString * sign = @"";
        NSString * time = @"";
        NSString * msg = @"";
        if ([resultDic objectForKey:@"userid"]) {
            userid = resultDic[@"userid"];
        }
        if ([resultDic objectForKey:@"sign"]) {
            sign = resultDic[@"sign"];
        }
        if ([resultDic objectForKey:@"time"]) {
            time = resultDic[@"time"];
        }
        if ([resultDic objectForKey:@"msg"]) {
            msg = resultDic[@"msg"];
        }
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:userid],@"ticket":[JHToolsUtils stringValue:sign],@"time":[JHToolsUtils stringValue:time],@"msg":[JHToolsUtils stringValue:msg]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                self.uid = [JHToolsUtils getResponseUidWithDict:data];
                [JHToolsSDK sharedInstance].proxy.userID = self.uid;
                //回调返回参数
                id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
                if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
                    [sdkDelegate OnUserLogin:data];
                }
            }else{
                [HNPloyProgressHUD showFailure:@"登录验证失败！"];
            }
        }];
    }
    
}
//支付完成回调
- (void)paySuccessCallBack:(NSString *)resultStr withPaytype:(NSString *)payType {
    //payType：（1：余额  51：支付宝  52：微信） resultStr:（成功：success 失败：其他信息）
    NSString *result = @"支付失败";
    if ([resultStr isEqualToString:@"success"]) {
        result = @"支付成功";
    }
    NSLog(@"支付完成：payResult = %@ payType = %@",resultStr,payType);
}
//登出完成回调
- (void)loginOutSuccessCallBack:(NSDictionary *)resultDic {
    //回调返回参数
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}

//手机绑定成功回调
- (void)bindPhoneSuccess {
    NSLog(@"绑定手机成功");
}
//实名绑定成功回调
- (void)bindIdentityCardSuccess {
    NSLog(@"绑定身份成功");
}

@end
