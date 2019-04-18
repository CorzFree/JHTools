//
//  JHToolsSDK_MengWanSDK.m
//  JHToolsSDK_MengWanSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_MengWanSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <BtMobileGameSdk/BtMobileGameSdk.h>

@interface JHToolsSDK_MengWanSDK()<MWSdkDelegate>

@property (nonatomic, assign) BOOL isLogin;

@end

@implementation JHToolsSDK_MengWanSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    [MWSdk sharedInstance].assistiveDelegate = self;
    return self;
}
    
#pragma mark --UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[MWSdk sharedInstance] initApi:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    [[MWSdk sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];//URL跳转
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    [[MWSdk sharedInstance] application:app openURL:url options:options];//URL跳转
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [[MWSdk sharedInstance] application:application handleOpenURL:url];
    return YES;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [[MWSdk sharedInstance] startLogin:^(NSDictionary *resultDic) {
        self.isLogin = YES;
        if ([[JHToolsUtils stringValue:resultDic[@"loginresult"]] isEqualToString:@"1"]) {
            [HNPloyProgressHUD showLoading:@"登录验证..."];
            [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:resultDic[@"userId"]],@"ticket":[JHToolsUtils stringValue:resultDic[@"token"]]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
                NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
                if (code != nil && [code isEqualToString:@"1"]) {
                    [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                    [JHToolsSDK sharedInstance].proxy.userID = [JHToolsUtils getResponseUidWithDict:data];
                    [[MWSdk sharedInstance] showFloating];
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
    }];
}
    
- (void) logout{
    if (self.isLogin) {
        [[MWSdk sharedInstance] logout:^(NSDictionary *resultDic) {
            [[MWSdk sharedInstance] hideFloating];
        }];
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
    PlayerInfo *playInfo = [[PlayerInfo alloc] init];
    playInfo.gameService = [JHToolsUtils stringValue:userlog.serverName];//玩家区服
    playInfo.gameServiceId = [NSString stringWithFormat:@"%d", userlog.serverID];//玩家区服id
    playInfo.playerName = [JHToolsUtils stringValue:userlog.roleName];//玩家昵称
    playInfo.playerLevel = [JHToolsUtils stringValue:userlog.roleLevel];//玩家等级

    if (userlog.dataType == TYPE_ENTER_GAME) {
        [[MWSdk sharedInstance] updatePlayerInfo:playInfo completionBlock:^(NSDictionary *resultDict) {
            NSLog(@"playinfo-----------%@", resultDict);
            NSString *payRes = [NSString stringWithFormat:@"%@", [resultDict objectForKey:@"status"]];
            NSLog(@"上报角色结果:%@", payRes);
        }];
    }else if (userlog.dataType == TYPE_LEVEL_UP){
        [[MWSdk sharedInstance] updatePlayerLevel:userlog.roleLevel completionBlock:^(NSDictionary *resultDic) {
            NSLog(@"更新角色等级结果:%@", resultDic);
        }];
    }
    
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            OrderInfo *orderInfo = [[OrderInfo alloc] init];
            orderInfo.goodsPrice = [NSString stringWithFormat:@"%zd", [profuctInfo.price integerValue]*100];//商品价格
            orderInfo.goodsName = [JHToolsUtils stringValue:profuctInfo.productName];//商品名称
            orderInfo.goodsDesc = [JHToolsUtils stringValue:profuctInfo.productDesc];//商品描述
            orderInfo.productId = [JHToolsUtils stringValue:profuctInfo.productId];//内购产品id
            orderInfo.extendInfo = orderNo;//此字段会透传到游戏服务器，可拼接
            orderInfo.gameVersion = @"";//游戏版本号
            orderInfo.roleId = [JHToolsUtils stringValue:profuctInfo.roleId]; // 角色id
            orderInfo.roleName = [JHToolsUtils stringValue:profuctInfo.roleName]; // 角色名称
            orderInfo.serverId = [JHToolsUtils stringValue:profuctInfo.serverId]; // 区服id
            orderInfo.serverName = [JHToolsUtils stringValue:profuctInfo.serverName]; // 区服名称
            [[MWSdk sharedInstance] startPay:orderInfo completionBlock:^(NSDictionary *resultDic) {
                NSLog(@"支付结果：%@", resultDic);
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

- (void)clickLoginoutBtn:(NSDictionary *)exitDic{
    self.isLogin = NO;
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}
    
@end
