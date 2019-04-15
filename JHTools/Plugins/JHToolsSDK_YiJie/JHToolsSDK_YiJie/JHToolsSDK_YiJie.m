//
//  JHToolsSDK_YiJie.m
//  JHToolsSDK_YiJie
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_YiJie.h"
#import <OnlineAHelper/YiJieOnlineHelper.h>
#import "HNPloyProgressHUD.h"
#import "JHToolsUtils.h"

@interface JHToolsSDK_YiJie()

@property (nonatomic, copy) NSString *uid;//JHToolsid
@property (nonatomic, copy) NSString *notifyURL;

@end

@implementation JHToolsSDK_YiJie

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    self.notifyURL = params[@"notifyURL"];
    //获取info.plist文件中的配置的can'shu
    [YiJieOnlineHelper initSDKWithListener:self];
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}

// UIApplicationDelegate事件
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2){
    BOOL yjResult = [[YJAppDelegae Instance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return yjResult;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[YJAppDelegae Instance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[YJAppDelegae Instance] applicationWillEnterForeground:application];
}

-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[YJAppDelegae Instance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YJAppDelegae Instance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[YJAppDelegae Instance] application:application didReceiveRemoteNotification:userInfo];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [[YJAppDelegae Instance] application:application supportedInterfaceOrientationsForWindow:window];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [[YJAppDelegae Instance] application:application handleOpenURL:url];
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [YiJieOnlineHelper setLoginListener: self];
    [YiJieOnlineHelper login: @"login"];
}

- (void) logout{
    [YiJieOnlineHelper logout:@"logout"];
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
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", userlog.roleID], @"roleId", [NSString stringWithFormat:@"%@", userlog.roleName], @"roleName", [NSString stringWithFormat:@"%@", userlog.roleLevel], @"roleLevel", [NSString stringWithFormat:@"%d", userlog.serverID], @"zoneId", [NSString stringWithFormat:@"%@", userlog.serverName], @"zoneName", nil];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", userlog.roleID], @"roleId", [NSString stringWithFormat:@"%@", userlog.roleName], @"roleName", [NSString stringWithFormat:@"%@", userlog.roleLevel], @"roleLevel", @"", @"partyName",@"",@"balance",@"0",@"vip",[NSString stringWithFormat:@"%d", userlog.serverID],@"zoneId", [NSString stringWithFormat:@"%@", userlog.serverName], @"zoneName", [NSString stringWithFormat:@"%ld", userlog.roleCreateTime],@"roleCTime",[NSString stringWithFormat:@"%ld", userlog.roleLevelUpTime],@"roleLevelMTime",nil];
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString* roleData = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
    [YiJieOnlineHelper setRoleData:roleData];
    
   
    if (userlog.dataType == TYPE_SELECT_SERVER) {
        [YiJieOnlineHelper setData:@"enterServer" :roleData];
    }else if(userlog.dataType == TYPE_CREATE_ROLE) {
        [YiJieOnlineHelper setData:@"createrole" :roleData];
    }else if(userlog.dataType == TYPE_LEVEL_UP){
        [YiJieOnlineHelper setData:@"levelup" :roleData];
    }
}


#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
//    if (profuctInfo.extension == nil) {
//        profuctInfo.extension = @"";
//    }
//    NSDictionary *extension = @{@"extension":profuctInfo.extension,@"role_id":[NSString stringWithFormat:@"%@", profuctInfo.roleId],@"role_name":[NSString stringWithFormat:@"%@", profuctInfo.roleName],@"server_id":[NSString stringWithFormat:@"%@",profuctInfo.serverId],@"server_name":[NSString stringWithFormat:@"%@", profuctInfo.serverName],@"product_id":[NSString stringWithFormat:@"%@", profuctInfo.productId],@"product_name":[NSString stringWithFormat:@"%@", profuctInfo.productName],@"product_desc":[NSString stringWithFormat:@"%@", profuctInfo.productDesc]};
//    NSString *extensionStr = [[JHToolsUtils dictionaryToJson:extension] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    NSLog(@"%@", extensionStr);
//    [YiJieOnlineHelper pay:[profuctInfo.price intValue]*100 :profuctInfo.productName :1 :extensionStr :self.notifyURL :self];
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            [YiJieOnlineHelper pay:[profuctInfo.price intValue]*100 :profuctInfo.productName :1 :orderNo :self.notifyURL :self];
        }else{
            [HNPloyProgressHUD showFailure:@"创建聚合订单失败！"];
        }
    }];
    
}

-(void) closeIAP{
}

-(void) finishTransactionId:(NSString*)transactionId{
}

#pragma mark --易接回调
-(void) onResponse:(NSString*) tag : (NSString*) value {
    NSLog(@"初始化回调onResponse:%@,%@", tag, value);
}

-(void) onFailed : (NSString*) msg {
    NSLog(@"支付失败回调:%@", msg);
}

-(void) onSuccess : (NSString*) msg {
    NSLog(@"支付成功回调:%@", msg);
}

-(void) onOderNo : (NSString*) msg {
    NSLog(@"订单号:%@", msg);
}

-(void) onLogout : (NSString *) remain {
    NSLog(@"sfwarning  logout onLogout:%@", remain);
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}

-(void) onLoginSuccess : (YiJieOnlineUser*) user : (NSString *) remain {
    NSLog(@"登录成功:%@", remain);
    [HNPloyProgressHUD showLoading:@"登录验证..."];
    [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":user.channelUserId,@"ticket":user.token,@"channelId":user.channelId, @"appId":user.productCode} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
            self.uid = [JHToolsUtils getResponseUidWithDict:data];
            [JHToolsSDK sharedInstance].proxy.userID = self.uid;
            [JHToolsSDK sharedInstance].proxy.sdkID = user.channelId;
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


-(void) onLoginFailed : (NSString*) reason : (NSString *) remain {
    NSLog(@"登录失败:%@", remain);
    [HNPloyProgressHUD showFailure:@"登录失败！"];
}
@end
