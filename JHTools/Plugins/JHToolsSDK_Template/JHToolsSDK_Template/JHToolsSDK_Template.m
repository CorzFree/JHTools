//
//  JHToolsSDK_Template.m
//  JHToolsSDK_Template
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_Template.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <HuoSDK/HuoSDK.h>

@interface JHToolsSDK_Template()

@end

@implementation JHToolsSDK_Template

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}
    
    // UIApplicationDelegate事件
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [HuoSDKApi application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}
    
    //iOS10以上使用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [HuoSDKApi application:app openURL:url sourceApplication:nil annotation:nil];
    return YES;
}
    
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [HuoSDKApi application:application openURL:url sourceApplication:nil annotation:nil];
    return YES;
}
    
#pragma mark --<IJHToolsUser>
- (void) login{
    [HuoSDKApi showLoginWithCallBack:^(NSDictionary *responseDic) {
        NSString *sdk_userid = responseDic[@"userid"];//sdk的用户id
        NSString *sdk_sessionid = responseDic[@"token"];//sdk的sessionid，用于验证登录是否成功
        NSLog(@"SDK登录返回数据:userid = %@,token = %@", sdk_userid, sdk_sessionid);
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":sdk_userid,@"ticket":sdk_sessionid} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                
                [JHToolsSDK sharedInstance].proxy.userID = [JHToolsUtils getResponseUidWithDict:data];
                //回调返回参数
                //登录成功之后调用浮点按钮
                [HuoSDKApi showFloatView:nil];
                id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
                if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
                    [sdkDelegate OnUserLogin:data];
                }
            }else{
                [HNPloyProgressHUD showFailure:@"登录验证失败！"];
            }
        }];
    }];
    
    [HuoSDKApi addLogoutCallBack:^(NSDictionary *responseDic) {
        id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
        if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
            [HuoSDKApi hiddenFloat];
            [sdkDelegate OnUserLogout:nil];
        }
    }];
}
    
- (void) logout{
    [HuoSDKApi logout];
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
    NSString *type;
    if (userlog.dataType == OP_CREATE_ROLE) {
        type = @"2";
    }else if (userlog.dataType == OP_ENTER_GAME){
        type = @"1";
    }else if (userlog.dataType == OP_EXIT){
        type = @"4";
    }else{
        type = @"3";
    }
    [HuoSDKApi setRoleInfo:@{key_dataType :type,
                             key_serverID : [NSString stringWithFormat:@"%d", userlog.serverID],
                             key_serverName : [JHToolsUtils stringValue:userlog.serverName],
                             key_roleID : [JHToolsUtils stringValue:userlog.roleID],
                             key_roleName :[JHToolsUtils stringValue:userlog.roleName],
                             key_roleLevel : [JHToolsUtils stringValue:userlog.roleLevel],
                             key_roleVip : [JHToolsUtils stringValue:userlog.vip],
                             key_roleBalence : @"0",
                             key_partyName : @"null",
                             key_rolelevelCtime :[NSString stringWithFormat:@"%ld", userlog.roleCreateTime],
                             key_rolelevelMtime : [NSString stringWithFormat:@"%ld", userlog.roleLevelUpTime]
                             }];
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            NSDictionary *orderInfo = @{
                                        key_cpOrderid:orderNo,
                                        key_serverID:[JHToolsUtils stringValue:profuctInfo.serverId],
                                        key_serverName:[JHToolsUtils stringValue:profuctInfo.serverName],
                                        key_productID:[JHToolsUtils stringValue:profuctInfo.productId],
                                        key_productName:[JHToolsUtils stringValue:profuctInfo.productName],
                                        key_productdesc:[JHToolsUtils stringValue:profuctInfo.productDesc],
                                        key_ext:orderNo,
                                        key_productPrice:[profuctInfo.price stringValue],
                                        key_roleID:[JHToolsUtils stringValue:profuctInfo.roleId],
                                        key_roleName:[JHToolsUtils stringValue:profuctInfo.roleName]
                                        };
            [HuoSDKApi addPaySuccessedCallback:^(NSDictionary *responseDic) {
                NSLog(@"支付成功：response=%@", responseDic);
            }];
            [HuoSDKApi buy:orderInfo failedBlock:^{
                NSLog(@"payfailed");//支付失败
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
