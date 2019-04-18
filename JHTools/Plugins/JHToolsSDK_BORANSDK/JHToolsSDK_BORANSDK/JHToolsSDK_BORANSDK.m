//
//  JHToolsSDK_BORANSDK.m
//  JHToolsSDK_BORANSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_BORANSDK.h"
#import <boRanSDK/BoRanSDKManager.h>
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"

@interface JHToolsSDK_BORANSDK()

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *uid;//JHToolsUID

@end

@implementation JHToolsSDK_BORANSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    //获取info.plist文件中的配置的can'shu
    NSString *appID = [params valueForKey:@"app_id"];
    NSString *appKey = [params valueForKey:@"app_key"];
    NSString *appScheme = [params valueForKey:@"app_scheme"];
    int appDirection = [[params valueForKey:@"app_direction"] intValue];
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    //diriction为屏幕方向  [1 = 竖屏，2 = 左横屏，3 = 右横屏]
    [BoRanSDKManager initializeBoRanSDKWithAppId:appID appKey:appKey appScheme:appScheme direction:appDirection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initNotice:) name:@"boRanSDKInit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotice:) name:@"boRanSDKLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotice:) name:@"boRanSDKPaySucc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRoleNotice:) name:@"boRanSDKSendRole" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theLoginOut) name:@"boRanSDKLoginOut" object:nil];
    
    return self;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [BoRanSDKManager addLoginView:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void) logout{
    [BoRanSDKManager logout];
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
    [BoRanSDKManager sendFforRoleWithServerId:[NSString stringWithFormat:@"%d", userlog.serverID] ServerName:[JHToolsUtils stringValue:userlog.serverName] wRoleId:[JHToolsUtils stringValue:userlog.roleID] roleName:[JHToolsUtils stringValue:userlog.roleName] roleLevel:[JHToolsUtils stringValue:userlog.roleLevel]];
}


#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            [BoRanSDKManager PayWithMoney:[profuctInfo.price stringValue] RoleId:[JHToolsUtils stringValue:profuctInfo.roleId] RoleName:[JHToolsUtils stringValue:profuctInfo.roleName] ExtInfo:[JHToolsUtils stringValue:data[@"data"][@"order_no"]] ServerId:[JHToolsUtils stringValue:profuctInfo.serverId] Product:[JHToolsUtils stringValue:profuctInfo.productDesc]];
        }else{
            [HNPloyProgressHUD showFailure:@"创建聚合订单失败！"];
        }
    }];
}

-(void) closeIAP{
}

-(void) finishTransactionId:(NSString*)transactionId{
}



-(void) initNotice:(NSNotification *)notification{
    NSString *code = [notification.userInfo objectForKey:@"code"];
    NSLog(@"初始化结果----code=%@",code);
    /**
     code返回
     101  初始化成功
     102  初始化失败
     103  网络错误
     **/
}

- (void) loginNotice:(NSNotification *)notification{
    NSString*sign = [notification.userInfo objectForKey:@"sign"];
    NSString *code = [notification.userInfo objectForKey:@"code"];
    NSLog(@"登录结果-----sign=%@  code = %@",sign,code);
    if ([@"201" isEqualToString:code]) {
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"ticket":[JHToolsUtils stringValue:sign]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                self.uid = [JHToolsUtils getResponseUidWithDict:data];
                [JHToolsSDK sharedInstance].proxy.userID = self.uid;
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

-(void)theLoginOut{
    NSLog(@"注销登录成功");
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}


-(void)payNotice:(NSNotification *)notification{
    NSString*code = [notification.userInfo objectForKey:@"code"];
    NSLog(@"支付结果-----code=%@",code);
}

-(void) sendRoleNotice:(NSNotification *)notifacation{
    NSString *code = [notifacation.userInfo objectForKey:@"code"];
    NSLog(@"上传角色结果----code=%@",code);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
