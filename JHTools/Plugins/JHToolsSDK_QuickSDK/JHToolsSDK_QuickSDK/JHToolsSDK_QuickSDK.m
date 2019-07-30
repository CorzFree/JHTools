//
//  JHToolsSDK_QuickSDK.m
//  JHToolsSDK_QuickSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_QuickSDK.h"
#import <SMPCQuickSDK/SMPCQuickSDK.h>
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"

@interface JHToolsSDK_QuickSDK()

@property (nonatomic, copy) NSString *uid;//JHToolsid
@property (nonatomic, copy) NSString * productCode;
@property (nonatomic, copy) NSString * subChannel;
@property (nonatomic, copy) NSString * productKey;

@end

@implementation JHToolsSDK_QuickSDK


#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    //获取info.plist文件中的配置的can'shu
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    self.subChannel = [params valueForKey:@"subChannel"];
    self.productCode = [params valueForKey:@"productCode"];
    self.productKey = [params valueForKey:@"productKey"];
    return self;
}

#pragma mark --- UIApplicationDelegate事件
- (void)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self addNotification];
    //初始化
    SMPCQuickSDKInitConfigure *cfg = [[SMPCQuickSDKInitConfigure alloc] init];
    cfg.productKey = self.productKey;
    cfg.productCode = self.productCode;
    int errorcode = [[SMPCQuickSDK defaultInstance] initWithConfig:cfg application:application didFinishLaunchingWithOptions:launchOptions];
    if (errorcode != 0) {
        NSLog(@"QuickSDK初始化失败");
    }
}

-(void)addNotification{
    //监听初始化完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpInitResult:) name:kSmpcQuickSDKNotiInitDidFinished object:nil];
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpLoginResult:) name:kSmpcQuickSDKNotiLogin object:nil];
    //注销
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpLogoutResult:) name:kSmpcQuickSDKNotiLogout object:nil];
    //充值结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpRechargeResult:) name:kSmpcQuickSDKNotiRecharge object:nil];
    //暂停结束 这个回调可以不用添加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpPauseOver:) name:kSmpcQuickSDKNotiPauseOver object:nil];
}

- (void)smpcQpInitResult:(NSNotification *)notify {
    NSLog(@"init result:%@",notify);
    NSDictionary *userInfo = notify.userInfo;
    int errorCode = [userInfo[kSmpcQuickSDKKeyError] intValue];
    switch (errorCode) {
        case SMPC_QUICK_SDK_ERROR_NONE:{
            NSLog(@"初始化成功");
        }
            break;
        case SMPC_QUICK_SDK_ERROR_INIT_FAILED:
        default:
        {
            //初始化失败
            NSLog(@"渠道初始化失败");
        }
            break;
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [[SMPCQuickSDK defaultInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[SMPCQuickSDK defaultInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[SMPCQuickSDK defaultInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[SMPCQuickSDK defaultInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SMPCQuickSDK defaultInstance] applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[SMPCQuickSDK defaultInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[SMPCQuickSDK defaultInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    [[SMPCQuickSDK defaultInstance] application:application supportedInterfaceOrientationsForWindow:window];
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [[SMPCQuickSDK defaultInstance] openURL:url application:application];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[SMPCQuickSDK defaultInstance] openURL:url sourceApplication:sourceApplication application:application annotation:annotation];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    [[SMPCQuickSDK defaultInstance] openURL:url application:app options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * restorableObjects))restorationHandler{
    [[SMPCQuickSDK defaultInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    int error = [[SMPCQuickSDK defaultInstance] login];
    if (error != 0) {
        NSLog(@"%d",error);
    }
}

- (void) logout{
    [[SMPCQuickSDK defaultInstance] logout];
}

- (void) switchAccount{
}

- (BOOL) hasAccountCenter{
    return YES;
}

- (void) loginCustom:(NSString*)customData{
}

- (void) showAccountCenter{
    int error = [[SMPCQuickSDK defaultInstance] enterUserCenter];
    if (error != 0) {
        NSLog(@"%d",error);
    }
}

- (void)submitUserInfo:(JHToolsUserExtraData *)userlog {
    SMPCQuickSDKGameRoleInfo *gameRoleInfo = [SMPCQuickSDKGameRoleInfo new];
    gameRoleInfo.serverName = userlog.serverName;
    gameRoleInfo.gameRoleName = userlog.roleName;
    gameRoleInfo.serverId = [NSString stringWithFormat:@"%d", userlog.serverID];
    gameRoleInfo.gameRoleID = userlog.roleID;
    gameRoleInfo.gameUserBalance = @"0";
    gameRoleInfo.vipLevel = @"0";
    gameRoleInfo.gameUserLevel = userlog.roleLevel;
    gameRoleInfo.partyName = @"0";
    [[SMPCQuickSDK defaultInstance] updateRoleInfoWith:gameRoleInfo isCreate:[@"1" isEqualToString:userlog.roleLevel]];
}



#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    //针对乐聚Quick设置的子渠道信息
    if (self.subChannel && ![@"" isEqualToString:self.subChannel]) {
        profuctInfo.extension = [NSString stringWithFormat:@"%@|%@", profuctInfo.extension, self.subChannel];
    }
    
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            SMPCQuickSDKGameRoleInfo *role = [[SMPCQuickSDKGameRoleInfo alloc] init];
            role.serverName = profuctInfo.serverName; //必填
            role.gameRoleName = profuctInfo.roleName;//@""
            role.serverId = profuctInfo.serverId; //需要是数字字符串
            role.gameRoleID = profuctInfo.roleId;//
            role.gameUserBalance = @"0";//
            role.vipLevel = profuctInfo.vip;//
            role.gameUserLevel = profuctInfo.roleLevel;
            role.partyName = @"ios";//
            
            SMPCQuickSDKPayOrderInfo *order = [[SMPCQuickSDKPayOrderInfo alloc] init];
            order.goodsID = [NSString stringWithFormat:@"%@", profuctInfo.productId];
            order.productName = profuctInfo.productName;
            order.cpOrderID = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            order.count = 1;
            order.amount = [profuctInfo.price floatValue];
            order.callbackUrl = profuctInfo.notifyUrl;
            order.extrasParams = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            int error = [[SMPCQuickSDK defaultInstance] payOrderInfo:order roleInfo:role];
            if (error!=0)
                NSLog(@"%d", error);
        }else{
            [HNPloyProgressHUD showFailure:@"创建聚合订单失败！"];
        }
    }];
}

-(void) closeIAP{
    
}

-(void) finishTransactionId:(NSString*)transactionId{
}

#pragma mark - Notifications
- (void)smpcQpLoginResult:(NSNotification *)notify {
    NSLog(@"登录成功通知%@",notify);
    int error = [[[notify userInfo] objectForKey:kSmpcQuickSDKKeyError] intValue];
    NSDictionary *userInfo = [notify userInfo];
    if (error == 0) {
        NSString *uid = [[SMPCQuickSDK defaultInstance] userId];
        NSString *user_token = userInfo[kSmpcQuickSDKKeyUserToken];
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":uid,@"ticket":user_token,@"product_code":[JHToolsUtils stringValue:self.productCode]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                self.uid = [JHToolsUtils getResponseUidWithDict:data];
                [JHToolsSDK sharedInstance].proxy.userID = self.uid;
                //显示悬浮窗
                [[SMPCQuickSDK defaultInstance] showToolBar:SMPC_QUICK_SDK_TOOLBAR_TOP_LEFT];
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
}

- (void)smpcQpLogoutResult:(NSNotification *)notify {
    NSLog(@"%s",__func__);
    NSDictionary *userInfo = notify.userInfo;
    int errorCode = [userInfo[kSmpcQuickSDKKeyError] intValue];
    switch (errorCode) {
        case SMPC_QUICK_SDK_ERROR_NONE:{
            NSLog(@"注销成功");
            [[SMPCQuickSDK defaultInstance] hideToolBar];
            id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
            if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
                [sdkDelegate OnUserLogout:nil];
            }
        }
            break;
        default:{
            NSLog(@"注销失败");
        }
            break;
    }
}
- (void)smpcQpRechargeResult:(NSNotification *)notify{
    NSLog(@"充值结果%@",notify);
    NSDictionary *userInfo = notify.userInfo;
    int error = [[userInfo objectForKey:kSmpcQuickSDKKeyError] intValue];
    switch (error) {
        case SMPC_QUICK_SDK_ERROR_NONE:
        {
            //充值成功
            //QuickSDK订单号,cp下单时传入的订单号，渠道sdk的订单号，cp下单时传入的扩展参数
            NSString *orderID = userInfo[kSmpcQuickSDKKeyOrderId];
            NSString *cpOrderID = userInfo[kSmpcQuickSDKKeyCpOrderId];
            NSLog(@"充值成功数据：%@,%@",orderID,cpOrderID);
        }
            break;
        case SMPC_QUICK_SDK_ERROR_RECHARGE_CANCELLED:
        case SMPC_QUICK_SDK_ERROR_RECHARGE_FAILED:
        {
            //充值失败
            NSString *orderID = userInfo[kSmpcQuickSDKKeyOrderId];
            NSString *cpOrderID = userInfo[kSmpcQuickSDKKeyCpOrderId];
            NSLog(@"充值失败数据%@,%@",orderID,cpOrderID);
        }
            break;
        default:
            break;
    }
}

- (void)smpcQpPauseOver:(NSNotification *)notify{
    NSLog(@"收到QuickSDK暂停结束通知");
}

@end
