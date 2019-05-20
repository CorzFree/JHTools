//
//  JHToolsSDK_PTSDK.m
//  JHToolsSDK_PTSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_PTSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import "ReYouGameSDK.h"

@interface JHToolsSDK_PTSDK()

@property (nonatomic, copy) NSString *pID;
@property (nonatomic, copy) NSString *cpId;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *privateKey;
    
@end

@implementation JHToolsSDK_PTSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    self.pID = [JHToolsUtils stringValue:[params valueForKey:@"pID"]];
    self.cpId = [JHToolsUtils stringValue:[params valueForKey:@"cpId"]];
    self.gameId = [JHToolsUtils stringValue:[params valueForKey:@"gameId"]];
    self.privateKey = [JHToolsUtils stringValue:[params valueForKey:@"privateKey"]];
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}
    
#pragma mark --UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [ReYouGameSDK initSDKWithPID:self.pID withCPID:self.cpId withGID:self.gameId withMd5Key:self.privateKey];
}
    
-(void)applicationWillEnterForeground:(UIApplication *)application{
    [ReYouGameSDK willEnterForeground];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[ReYouGameSDK defaultService] processOrderWithPaymentResult:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}
    

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscape;
}
    
#pragma mark --<IJHToolsUser>
- (void) login{
    [ReYouGameSDK asLoginWithLoginSuccess:^(NSString *token, NSString *SID) {
        NSLog(@"token = %@, SID = %@", token , SID);
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:SID],@"ticket":[JHToolsUtils stringValue:token]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
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
    } loginFailure:^(ASLoginFailureType loginFailureType,NSString *loginFailureInfo){
        if (loginFailureType == ASLoginFailureCloseAllWindow) {
            //用户主动关闭登陆窗口时，需要让玩家可以主动打开登陆页，或者CP在此处主动调用登陆方法。
            //建议采用玩家主动打开登陆页的方式
            //如果关闭后玩家可以点击登陆进行登陆，就不用主动调用登陆方法。
            //            [weakSelf loginBtnClick];   //注意，玩家不可以主动打开登陆页时采用。
        }else{
            //其他状态，一般情况都不用做任何处理
        }
    } logoutSuccess:^{
        // 注销后返回登录界面，让玩家重新登录即可。
        id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
        if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
            [sdkDelegate OnUserLogout:nil];
        }
    }];
}
    
- (void) logout{
    
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
    ASRoleInfo *aRoleInfo = [ASRoleInfo roleInfoWithRoleID:[JHToolsUtils stringValue:userlog.roleID]
                                                  roleName:[JHToolsUtils stringValue:userlog.roleName]
                                                 roleLevel:[JHToolsUtils stringValue:userlog.roleLevel]
                                                  serverId:[NSString stringWithFormat:@"%d", userlog.serverID]
                                                serverName:[JHToolsUtils stringValue:userlog.serverName]
                                                  moneyNum:@"0"
                                            roleCreateTime:[NSString stringWithFormat:@"%ld", userlog.roleCreateTime]
                                           roleLevelUpTime:[NSString stringWithFormat:@"%ld", userlog.roleLevelUpTime]
                                                       vip:@"0"
                                                roleGender:@"0"
                                              professionID:@"0"
                                            professionName:@"无"
                                                     power:@"0"
                                                   partyID:@"0"
                                                 partyName:@"无"
                                             partyMasterID:@"0"
                                           partyMasterName:@"无"];
    // 2.角色上传
    [ReYouGameSDK submitRoleInfo:aRoleInfo];
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            
            ASPayOrderInfo *aPayOrderInfo = [ASPayOrderInfo
                                             payOrderInfoWithUserId:nil
                                             username:nil
                                             payMoney:[profuctInfo.price stringValue]
                                             goodsName:[JHToolsUtils stringValue:profuctInfo.productName]
                                             goodsBody:[JHToolsUtils stringValue:profuctInfo.productDesc]
                                             productId:[JHToolsUtils stringValue:profuctInfo.productId]
                                             gameName:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                             gameArea:[JHToolsUtils stringValue:profuctInfo.serverName]
                                             memo:orderNo
                                             roleID:[JHToolsUtils stringValue:profuctInfo.roleId]
                                             roleName:[JHToolsUtils stringValue:profuctInfo.roleName]
                                             serverId:[JHToolsUtils stringValue:profuctInfo.serverId]
                                             serverName:[JHToolsUtils stringValue:profuctInfo.serverName]
                                             extension:orderNo
                                             gameCallbackUrl:@""];
            [ReYouGameSDK asPayWith:aPayOrderInfo fromScheme:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] paySuccess:^{
                NSLog(@"demo支付成功！");
            } payFailure:^{
                NSLog(@"demo支付失败");
            }];
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
