//
//  JHToolsSDK_LEJUSDK.m
//  JHToolsSDK_LEJUSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_LEJUSDK.h"
#import <GameFramework/GameFramework.h>
#import "HNPloyProgressHUD.h"
#import "JHToolsUtils.h"

@interface JHToolsSDK_LEJUSDK()

@property (nonatomic, copy) NSString *uid;

@end

@implementation JHToolsSDK_LEJUSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    [Game_Api Game_addLogoutCallBlock:^(NSDictionary *responseDic) {
        id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
        if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
            [sdkDelegate OnUserLogout:nil];
        }
    }];
    
    [Game_Api Game_sendInfoSuccessedCallBlock:^(NSDictionary *responseDic) {
        NSString *orderid = responseDic[@"orderid"];//火速订单号
        NSString *cporderid = responseDic[@"cpid"]; //cp订单号
        NSLog( @"orderid:---%@,cpid---%@",orderid,cporderid);
    }];
    
    return self;
}


// UIApplicationDelegate事件
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    [Game_Api Game_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL*)url options:(NSDictionary *)options {
    [Game_Api Game_application:application openURL:url sourceApplication:nil annotation:nil];
    return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url {
    [Game_Api Game_application:application openURL:url sourceApplication:nil annotation:nil];
    return YES;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [Game_Api Game_showLoginWithCallBack:^(NSDictionary *responseDic) {
        NSString *sdk_userid = responseDic[@"userid"];//sdk的用户id
        NSString *sdk_sessionid = responseDic[@"token"];//sdk的sessionid，用于验证登录是否成功
        NSLog(@"userid = %@,token = %@", sdk_userid, sdk_sessionid);
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:sdk_userid],@"ticket":[JHToolsUtils stringValue:sdk_sessionid]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
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
    }];
}

- (void) logout{
    [Game_Api Game_Logout];
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
    //1为进入游戏，2为创建角色，3为角色升级，4为退出
    NSString *dataType;
    if (userlog.dataType == TYPE_ENTER_GAME) {
        dataType = @"1";
    }else if (userlog.dataType == TYPE_CREATE_ROLE){
        dataType = @"2";
    }
    else if (userlog.dataType == TYPE_LEVEL_UP){
        dataType = @"3";
    }
    else if (userlog.dataType == TYPE_EXIT_GAME){
        dataType = @"4";
    }else{
        return;
    }
    [Game_Api Game_setRoleInfo:@{element_dataType : dataType,
                                 element_serverID : [NSString stringWithFormat:@"%d", userlog.serverID],
                                 element_serverName : [JHToolsUtils stringValue:userlog.serverName],
                                 element_roleID : [JHToolsUtils stringValue:userlog.roleID],
                                 element_roleName : [JHToolsUtils stringValue:userlog.roleName],
                                 element_roleLevel : [JHToolsUtils stringValue:userlog.roleLevel],
                                 element_roleVip : [JHToolsUtils stringValue:userlog.vip],
                                 element_partyName : @"",
                                 element_rolelevelCtime : [NSString stringWithFormat:@"%ld", userlog.roleCreateTime],
                                 element_rolelevelMtime : [NSString stringWithFormat:@"%ld", userlog.roleLevelUpTime]
                                 }];
}


#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            
            NSDictionary *orderInfo = @{
                                        element_cpOrderid:[JHToolsUtils stringValue:profuctInfo.orderID],
                                        element_serverID:[JHToolsUtils stringValue:profuctInfo.serverId],
                                        element_serverName:[JHToolsUtils stringValue:profuctInfo.serverName],
                                        element_productID:[JHToolsUtils stringValue:profuctInfo.productId],
                                        element_productName:[JHToolsUtils stringValue:profuctInfo.productName],
                                        element_productdesc:[JHToolsUtils stringValue:profuctInfo.productDesc],
                                        element_ext: [JHToolsUtils stringValue:data[@"data"][@"order_no"]],
                                        element_productPrice:[profuctInfo.price stringValue],
                                        element_roleID:[JHToolsUtils stringValue:profuctInfo.roleId],
                                        element_roleName:[JHToolsUtils stringValue:profuctInfo.roleName],
                                        element_currencyName : @"元宝",
                                        };

            [Game_Api Game_sendOrderInfo:orderInfo failedBlock:^{
                NSLog(@"支付失败");
            }];
            
        }else{
            [HNPloyProgressHUD showFailure:@"创建聚合订单失败！"];
        }
    }];
}

-(void) closeIAP{
}

-(void) finishTransactionId:(NSString*)transactionId{
}


@end
