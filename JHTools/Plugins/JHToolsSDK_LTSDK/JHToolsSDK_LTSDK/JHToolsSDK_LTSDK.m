//
//  JHToolsSDK_LTSDK.m
//  JHToolsSDK_LTSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_LTSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <LTUser/LTUser.h>

@interface JHToolsSDK_LTSDK()<LTManagerDelegate>

@property (nonatomic, copy) NSString *channelGameid;
@property (nonatomic, copy) NSString *channelUserName;
@property (nonatomic, copy) NSString *loginKey;
@property (nonatomic, copy) NSString *payKey;
@property (nonatomic, copy) NSString *submitUserInfoKey;

@end

@implementation JHToolsSDK_LTSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    self.channelGameid = [params objectForKey:@"gameid"];
    self.loginKey = [params objectForKey:@"loginKey"];
    self.payKey = [params objectForKey:@"payKey"];
    self.submitUserInfoKey = [params objectForKey:@"submitUserInfoKey"];
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    [LTManager shareManager].delegate = self;
    return self;
}
    
#pragma mark ----UIApplicationDelegate事件
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    [[LTManager shareManager] handleOpenURL:url];
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    [[LTManager shareManager] handleOpenURL:url];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[LTManager shareManager] handleOpenURL:url];
    return YES;
}
    
#pragma mark --<IJHToolsUser>
- (void) login{
    [[LTManager shareManager] userLogin];
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
    LTRoleModel *role = [[LTRoleModel alloc]init];
    role.gameId = self.channelGameid;
    role.roleCreateTime = [NSString stringWithFormat:@"%ld", userlog.roleCreateTime];
    role.uid = [LTManager shareManager].uid;
    role.username = self.channelUserName;
    role.serverId = [NSString stringWithFormat:@"%d", userlog.serverID];
    role.serverName = [JHToolsUtils stringValue:userlog.serverName];
    role.userRoleId = [JHToolsUtils stringValue:userlog.roleID];
    role.userRoleName = [JHToolsUtils stringValue:userlog.roleName];;
    role.userRoleBalance = @"0";
    role.vipLevel = @"无";
    role.userRoleLevel = [JHToolsUtils stringValue:userlog.roleLevel];;
    role.gameRoleMoney = @"0";
    role.partyId = @"0";
    role.partyName = @"无";
    role.gameRoleGender = @"no";
    role.gameRolePower = @"0";
    role.key = self.submitUserInfoKey;
    //前面是需要参与签名的参数
    role.sign = [NSString md5_32bit:[role description]];
    
    role.partyRoleId = @"0";
    role.partyRoleName = @"无";
    role.professionId = @"0";
    role.profession = @"0";
    if(userlog.dataType == TYPE_CREATE_ROLE){
        [[LTManager shareManager] uploadGameRoleInfoWithRole:role isCreateRole:@"true"];
    }else{
        [[LTManager shareManager] uploadGameRoleInfoWithRole:role isCreateRole:@"false"];
    }
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            LTOrder *order = [[LTOrder alloc] init];
            order.gameId = self.channelGameid;
            order.uid = [LTManager shareManager].uid;
            order.time = [[NSDate date]timeIntervalSince1970];
            order.server = [JHToolsUtils stringValue:profuctInfo.serverName];
            order.role = [JHToolsUtils stringValue:profuctInfo.roleName];
            order.goodsId = [JHToolsUtils stringValue:profuctInfo.productId];
            order.goodsName = [JHToolsUtils stringValue:profuctInfo.productName];
            order.money = [profuctInfo.price stringValue];
            order.cpOrderId = orderNo;
            order.ext = nil;
            order.key = self.payKey;
            order.signType = @"md5";
            //前面是需要参与签名的参数
            order.sign =  [NSString md5_32bit:[order description]];;
            [[LTManager shareManager] payWithOrder:order rechargeMoney:[NSString stringWithFormat:@"%zd", profuctInfo.coinNum] appScheme:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]];
        }else{
            [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"创建聚合订单失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
        }
    }];
}
    
-(void) closeIAP{
}
    
-(void) finishTransactionId:(NSString*)transactionId{
}

#pragma mark - LTLoginDelegate
- (void)loginSuccess {
    [HNPloyProgressHUD showLoading:@"登录验证..."];
    NSDictionary *userinfo = [LTManager shareManager].userInfo;
    self.channelUserName = [userinfo objectForKey:@"userName"];
    [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[userinfo objectForKey:@"uid"],@"ticket":[userinfo objectForKey:@"uToken"]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
            [[LTManager shareManager] showSuspensionView];
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
- (void)loginFail {
    NSLog(@"登录失败");
}
    
@end
