//
//  JHToolsSDK_XSDK.m
//  JHToolsSDK_XSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_XSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import <XSDKFramework/XSDKFramework.h>

@interface JHToolsSDK_XSDK()<XPlatformDelegate, GamepayDelegate>{
    BOOL _isLogin;
}

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *shareInstallKey;
@property (nonatomic, copy) NSString *payNotifyURL;
@property (nonatomic, copy) NSString *channelUid;

@end

@implementation JHToolsSDK_XSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    self.appID = [params valueForKey:@"appID"];
    self.appKey = [params valueForKey:@"appKey"];
    self.shareInstallKey = [params valueForKey:@"shareInstallKey"];
    self.payNotifyURL = [params valueForKey:@"payNotifyURL"];
    
    return self;
}
    
#pragma mark-- UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[XPlatform sharedInstance] initWithAppId:self.appID appKey:self.appKey shareInstallAppkey:self.shareInstallKey delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result.safepay = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {
        return [[GamePay defaultSDK] handleOpenURL:url delegate:self];
    }
    return [[GamePay defaultSDK] handleOpenURL:url delegate:self];;
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result.safepay = %@....memo:%@",resultDic,resultDic[@"memo"]);
            //9000 ：支付成功//  8000 ：订单处理中//  4000 ：订单支付失败//  6001 ：用户中途取消//  6002 ：网络连接出错
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                [[GamePay defaultSDK] PaySuccess];
            }else
            {
                [[GamePay defaultSDK] PayFailure];
            }
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {
        return [[GamePay defaultSDK] handleOpenURL:url delegate:self];
    }
    return [[GamePay defaultSDK] handleOpenURL:url delegate:self];
}

    
#pragma mark --<IJHToolsUser>
- (void) login{
    [[XPlatform sharedInstance] login:[UIApplication sharedApplication].keyWindow.rootViewController];
}
    
- (void) logout{
    if (_isLogin) {
        [[XPlatform sharedInstance] logout];
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
    XGameExtraData *data = [[XGameExtraData alloc] init];
    data.serverID = [NSString stringWithFormat:@"%d", userlog.serverID];
    data.serverName = [JHToolsUtils stringValue:userlog.serverName];
    data.roleID = [JHToolsUtils stringValue:userlog.roleID];
    data.roleName = [JHToolsUtils stringValue:userlog.roleName];
    data.roleLevel = [JHToolsUtils stringValue:userlog.roleLevel];
    data.vip = @"";

    if (userlog.dataType == TYPE_CREATE_ROLE) {
        data.opType = OP_CREATE_ROLE;
    }else if (userlog.dataType == TYPE_ENTER_GAME){
        data.opType = OP_ENTER_GAME;
    }else if (userlog.dataType == TYPE_LEVEL_UP){
        data.opType = OP_LEVEL_UP;
    }else if (userlog.dataType == TYPE_EXIT_GAME){
        data.opType = OP_EXIT;
    }else{
        return;
    }
    [[XPlatform sharedInstance] submitGameData:data];
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            XPayData* model = [XPayData alloc];
            model.price = [NSString stringWithFormat:@"%ld", [profuctInfo.price integerValue]*100];
            model.productID = [JHToolsUtils stringValue:profuctInfo.productId];
            model.productName = [JHToolsUtils stringValue:profuctInfo.productName];;
            model.productDesc = [JHToolsUtils stringValue:profuctInfo.productDesc];;
            model.roleID = [JHToolsUtils stringValue:profuctInfo.roleId];
            model.roleName = [JHToolsUtils stringValue:profuctInfo.roleName];;
            model.roleLevel = [JHToolsUtils stringValue:profuctInfo.roleLevel];;
            model.serverID = [JHToolsUtils stringValue:profuctInfo.serverId];
            model.serverName = [JHToolsUtils stringValue:profuctInfo.serverName];;
            model.vip = @"0";
            model.extra = orderNo;
            model.payNotifyUrl = self.payNotifyURL;
            model.userid = self.channelUid;
            [[GamePay defaultSDK] pay:model price:[profuctInfo.price stringValue]];
        }else{
            [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"创建聚合订单失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
        }
    }];
}
    
-(void) closeIAP{
}
    
-(void) finishTransactionId:(NSString*)transactionId{
}


#pragma mark --<XPlatformDelegate, GamepayDelegate>
-(void) OnInitSuccess{
}

-(void) OnInitFailed:(NSString*)msg{
    
}

-(void) OnLoginSuccess:(XLoginResult*)result{
    [HNPloyProgressHUD showLoading:@"登录验证..."];
    self.channelUid = result.userId;
    _isLogin = YES;
    [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":result.userId,@"ticket":result.accessToken, @"username": result.username} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
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
}

-(void) OnLoginFailed:(NSString*)msg{
    
}

-(void) OnLogoutSuccess{
    _isLogin = NO;
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}

-(void) OnLogoutFailed:(NSString*)msg{
    
}

-(void) OnPaySuccess:(NSString*)msg{
    
}

-(void) OnPayFailed:(NSString*)msg{
    
}

- (void)wechatoralipay:(NSString *)dic{
    
}

- (void)WeChatWithback:(GamePay *)wechat WitherrCode:(int)errCode{
    
}

@end
