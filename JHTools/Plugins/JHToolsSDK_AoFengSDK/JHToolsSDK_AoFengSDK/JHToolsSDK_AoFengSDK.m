//
//  JHToolsSDK_AoFengSDK.m
//  JHToolsSDK_AoFengSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_AoFengSDK.h"
#import <AffGameSDK/AffGameSDK.h>
#import "HNPloyProgressHUD.h"
#import "JHToolsUtils.h"
#import <AffGameSDK/FloatButton.h>

@interface JHToolsSDK_AoFengSDK()
    
    @property (nonatomic, copy) NSString * uid;

@end

@implementation JHToolsSDK_AoFengSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    //获取info.plist文件中的配置的can'shu
    NSString * gameId = [params valueForKey:@"gameId"];
    NSString * clientKey = [params valueForKey:@"clientKey"];
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    [AffGameSDK init:[UIApplication sharedApplication].keyWindow.rootViewController gameId:gameId clientKey:clientKey initFinish:^{
        NSLog(@"init finsh");
    }];
    return self;
}


#pragma mark---<UIApplicationDelegate>
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        [[AffGameSDK defaultService] processOrderWithPaymentResult:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        return YES;
}
    
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[AffGameSDK defaultService] applicationWillEnterForeground:application];
}


#pragma mark --<IJHToolsUser>
- (void) login{
    [[AffGameSDK defaultService] login:^(NSString * userId, NSString * token) {
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":userId,@"ticket":token} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                self.uid = [JHToolsUtils getResponseUidWithDict:data];
                [JHToolsSDK sharedInstance].proxy.userID = self.uid;
                id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
                [[FloatButton sharedButton] show];
                
                if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
                    [sdkDelegate OnUserLogin:data];
                }
            }else{
                [HNPloyProgressHUD showFailure:@"登录验证失败！"];
            }
        }];
    } loginFail:^{
        NSLog(@"login loginFail");
    }];
}

- (void) logout{
    [[FloatButton sharedButton] hide];
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
    if (userlog.dataType == TYPE_CREATE_ROLE || userlog.dataType == TYPE_ENTER_GAME || userlog.dataType == TYPE_LEVEL_UP) {
        RoleData *role = [[RoleData alloc] init];
        role.serverId = [NSString stringWithFormat:@"%ld",(long)userlog.serverID];
        role.serverName = [JHToolsUtils stringValue:userlog.serverName];
        role.roleID = [JHToolsUtils stringValue:userlog.roleID];
        role.roleName = [JHToolsUtils stringValue:userlog.roleName];
        role.roleLevel = [JHToolsUtils stringValue:userlog.roleLevel];
        role.roleCreateTime = [NSString stringWithFormat:@"%ld", userlog.roleCreateTime];
        role.roleLevelUpTime = [NSString stringWithFormat:@"%ld", userlog.roleLevelUpTime];
        [[AffGameSDK defaultService] updateRoleData:role];
    }
}


#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            PayParams *payParams = [[PayParams alloc] init];
            payParams.productName = [JHToolsUtils stringValue:profuctInfo.productName];
            payParams.productDesc = [JHToolsUtils stringValue:profuctInfo.productDesc];
            payParams.serverId = [JHToolsUtils stringValue:profuctInfo.serverId];
            payParams.serverName = [JHToolsUtils stringValue:profuctInfo.serverName];
            payParams.price = [profuctInfo.price intValue] * 100;
            payParams.roleId = [JHToolsUtils stringValue:profuctInfo.roleId];
            payParams.roleName = [JHToolsUtils stringValue:profuctInfo.roleName];
            payParams.roleLevel = [JHToolsUtils stringValue:profuctInfo.roleLevel];
            payParams.extension = [JHToolsUtils stringValue:orderNo];
            [[AffGameSDK defaultService] pay:payParams paySuccess:^(){
                NSLog(@"pay success.");
            } payFail:^(){
                NSLog(@"pay fail.");
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
