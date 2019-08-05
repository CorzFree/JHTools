//
//  JHToolsSDK_SQSDK.m
//  JHToolsSDK_SQSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_SQSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <SQSDK/SQSDK.h>

@interface JHToolsSDK_SQSDK(){
    BOOL _islogin;
}

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productKey;
@property (nonatomic, copy) NSString *gameKey;

@end

@implementation JHToolsSDK_SQSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    self.productCode = [params valueForKey:@"productCode"];
    self.productKey = [params valueForKey:@"productKey"];
    self.gameKey = [params valueForKey:@"gameKey"];
    
    return self;
}
    
#pragma mark ---UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [SQSDK setScreenOrientation:SQSDKScreenOrientationLandscape];
    
    SQSDKConfig *config = [[SQSDKConfig alloc] init];
    config.productCode = self.productCode;
    config.productKey = self.productKey;
    config.gameKey = self.gameKey;
    config.autoOpenLoginPage = NO;
    [SQSDK setScreenOrientation:SQSDKScreenOrientationLandscape];
    [SQSDK initWithConfig:config application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initNotification:)
                                                 name:SQSDKInitCompletedNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginNotification:)
                                                 name:SQSDKUserLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutNotification:)
                                                 name:SQSDKUserLogoutNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchNotification:)
                                                 name:SQSDKSwitchAccountNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reportNotification:)
                                                 name:SQSDKReportNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(payNotification:)
                                                 name:SQSDKPayCompletedNotification
                                               object:nil];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [SQSDK application:app openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [SQSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [SQSDK application:application handleOpenURL:url];
}
    
#pragma mark --<IJHToolsUser>
- (void) login{
    [SQSDK login];
}
    
- (void) logout{
    if (_islogin) {
        [SQSDK logout];
    }
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
    if (userlog.dataType == TYPE_CREATE_ROLE || userlog.dataType == TYPE_LEVEL_UP || userlog.dataType == TYPE_ENTER_GAME) {
        SQSDKRoleInfo *roleInfo = [SQSDKRoleInfo roleInfoWithAreaCode:[NSString stringWithFormat:@"%d", userlog.serverID] areaName:[JHToolsUtils stringValue:userlog.serverName] roleCode:[JHToolsUtils stringValue:userlog.roleID] roleName:[JHToolsUtils stringValue:userlog.roleName] roleLevel:[JHToolsUtils stringValue:userlog.roleLevel] roleCreateDate:[NSString stringWithFormat:@"%ld", userlog.roleCreateTime] roleSex:@"0" proCode:@"0" proName:@"0" partyCode:@"0" partyName:@"0" partyLevel:@"0" partyChairman:@"0" vipLevel:@"0" goldValue:0 expandInfo:nil];
        [SQSDK report:roleInfo];
    }
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];

            //角色信息
            NSMutableDictionary *expandInfo = [NSMutableDictionary dictionary];
            expandInfo[@"AreaName"] = [JHToolsUtils stringValue:profuctInfo.serverName];
            expandInfo[@"AreaCode"] = [JHToolsUtils stringValue:profuctInfo.serverId];
            expandInfo[@"RoleCode"] = [JHToolsUtils stringValue:profuctInfo.roleId];
            expandInfo[@"RoleName"] = [JHToolsUtils stringValue:profuctInfo.roleName];
            SQSDKPayInfo *payInfo = [SQSDKPayInfo payInfoWithCpOrderNo:orderNo
                                                            orderTitle:[JHToolsUtils stringValue:profuctInfo.productName]
                                                              itemCode:[JHToolsUtils stringValue:profuctInfo.productId]
                                                              itemName:[JHToolsUtils stringValue:profuctInfo.productName]
                                                             unitPrice:[profuctInfo.price longValue]*100
                                                                amount:1
                                                            totalPrice:[profuctInfo.price longValue]*100
                                                              AreaName:[JHToolsUtils stringValue:profuctInfo.serverName]
                                                              AreaCode:[JHToolsUtils stringValue:profuctInfo.serverId]
                                                              RoleCode:[JHToolsUtils stringValue:profuctInfo.roleId]
                                                              RoleName:[JHToolsUtils stringValue:profuctInfo.roleName]
                                                          callBackData:orderNo
                                                            expandInfo:expandInfo
                                     ];
            [SQSDK pay:payInfo];
        }else{
            [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"创建聚合订单失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
        }
    }];
}
    
-(void) closeIAP{
}
    
-(void) finishTransactionId:(NSString*)transactionId{
}

#pragma mark - Notification
- (void)initNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)loginNotification:(NSNotification *)notification {
    // 登录成功之后清除角色信息
    NSLog(@"%s", __FUNCTION__);
    
    // 获取用户信息
    SQSDKUserInfo *userInfo = notification.object;
    NSLog(@"userCode:%@", userInfo.userCode);
    NSLog(@"userToken:%@", userInfo.userToken);
    [HNPloyProgressHUD showLoading:@"登录验证..."];
    [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:userInfo.userCode],@"ticket":[JHToolsUtils stringValue:userInfo.userToken]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
            _islogin = YES;
            [JHToolsSDK sharedInstance].proxy.userID = [JHToolsUtils getResponseUidWithDict:data];
            //回调返回参数
            id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
            if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
                [sdkDelegate OnUserLogin:data];
            }
        }else{
            [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"登录验证失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
        }
    }];
}

- (void)logoutNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
    _islogin = NO;
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}

- (void)switchNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)reportNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)payNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}


@end
