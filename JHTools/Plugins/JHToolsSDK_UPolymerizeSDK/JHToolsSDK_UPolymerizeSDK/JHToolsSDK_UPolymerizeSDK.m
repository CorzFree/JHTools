//
//  JHToolsSDK_UPolymerizeSDK.m
//  JHToolsSDK_UPolymerizeSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_UPolymerizeSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <UPolymerizeSDK/UPolymerizeSDK.h>

@interface JHToolsSDK_UPolymerizeSDK()

@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, copy) NSString *gamekey;
@property (nonatomic, copy) NSString *channel;

@end

@implementation JHToolsSDK_UPolymerizeSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    self.gameid = [JHToolsUtils stringValue:[params valueForKey:@"gameid"]];
    self.gamekey = [JHToolsUtils stringValue:[params valueForKey:@"gamekey"]];
    self.channel = [JHToolsUtils stringValue:[params valueForKey:@"channel"]];
    return self;
}
    
#pragma mark--<UIApplicationDelegate事件>
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [PolymerizeSDK_kit commonSdk_InitWithGameID:self.gameid andGamekey:self.gamekey andChannel:self.channel];
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return  [PolymerizeSDK_kit application:application supportedInterfaceOrientationsForWindow:window];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [PolymerizeSDK_kit commonSdk_IsWillEnterForeground:YES OtherWiseEnterBackgroundOrExitApplication:application];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    [PolymerizeSDK_kit commonSdk_IsWillEnterForeground:NO OtherWiseEnterBackgroundOrExitApplication:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [PolymerizeSDK_kit application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}
//iOS10以上使用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [PolymerizeSDK_kit application:app openURL:url sourceApplication:nil annotation:(id _Nonnull)NULL];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [PolymerizeSDK_kit application:application openURL:url sourceApplication:nil annotation:(id _Nonnull)NULL];
    return YES;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [PolymerizeSDK_kit commonSdk_ShowLogin:^(NSString *paramToken) {
        NSLog(@"登录成功回调%@", paramToken);
        [PolymerizeSDK_kit showFloatView:nil];
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:paramToken],@"ticket":[JHToolsUtils stringValue:paramToken]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
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
    }];
    
    [PolymerizeSDK_kit commonSdk_OutLoginSuccess:^(BOOL boolSucceed_1) {
        [PolymerizeSDK_kit hiddenFloat];
        id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
        if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
            [sdkDelegate OnUserLogout:nil];
        }
    }];
}
    
- (void) logout{
    [PolymerizeSDK_kit commonSdk_ShowLogout];
    [PolymerizeSDK_kit hiddenFloat];
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
    if (userlog.roleID && (![@"" isEqualToString:userlog.roleID])) {
        JHRoleModel *playModel = [[JHRoleModel alloc] init];
        playModel.JH_roleID = [JHToolsUtils stringValue:userlog.roleID];
        playModel.JH_rolename = [JHToolsUtils stringValue:userlog.roleName];
        playModel.JH_serverID = [NSString stringWithFormat:@"%d", userlog.serverID];
        playModel.JH_serverName = [JHToolsUtils stringValue:userlog.serverName];
        playModel.JH_level = [JHToolsUtils stringValue:userlog.roleLevel];
        [PolymerizeSDK_kit commonSdk_SetPlayerInfo:playModel];
    }
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    JHRoleModel *playModel = [[JHRoleModel alloc] init];
    playModel.JH_roleID = [JHToolsUtils stringValue:profuctInfo.roleId];
    playModel.JH_rolename = [JHToolsUtils stringValue:profuctInfo.roleName];
    playModel.JH_serverID = [JHToolsUtils stringValue:profuctInfo.serverId];
    playModel.JH_serverName = [JHToolsUtils stringValue:profuctInfo.serverName];
    playModel.JH_level = [JHToolsUtils stringValue:profuctInfo.roleLevel];
    [PolymerizeSDK_kit commonSdk_SetPlayerInfo:playModel];
    
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            NYPayModel *model=[[NYPayModel alloc]init];
            model.orderID = orderNo;
            model.serverName = [JHToolsUtils stringValue:profuctInfo.serverName];
            model.roleName = [JHToolsUtils stringValue:profuctInfo.roleName];
            model.productName = [JHToolsUtils stringValue:profuctInfo.productName];
            model.amount = [profuctInfo.price stringValue];
            model.extra = orderNo;
            model.roleLevel = [JHToolsUtils stringValue:profuctInfo.roleLevel];
            model.gameName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            model.productId = [JHToolsUtils stringValue:profuctInfo.productId];
            model.serverID = [JHToolsUtils stringValue:profuctInfo.serverId];
            model.roleID = [JHToolsUtils stringValue:profuctInfo.roleId];
            [PolymerizeSDK_kit commonSdk_StartPay:model];
        }else{
            [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"创建聚合订单失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
        }
    }];
}
    
-(void) closeIAP{
}
    
-(void) finishTransactionId:(NSString*)transactionId{
}

    
@end
