//
//  JHToolsSDK_CMKingiOSSDK.m
//  JHToolsSDK_CMKingiOSSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_CMKingiOSSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <CMKingiOSSDK/CMKingiOSSDK.h>

@interface JHToolsSDK_CMKingiOSSDK()<XiaomoToolsApiDelegate>

@property (nonatomic, assign) BOOL isLogin;

@end

@implementation JHToolsSDK_CMKingiOSSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    [XiaomoToolsApi sharedInstance].assistiveDelegate = self;
    return self;
}
    

#pragma mark --<UIApplicationDelegate事件>
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[XiaomoToolsApi sharedInstance] initApi:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[XiaomoToolsApi sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];//URL跳转
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [[XiaomoToolsApi sharedInstance] application:app openURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[XiaomoToolsApi sharedInstance] application:application handleOpenURL:url];
    return YES;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [[XiaomoToolsApi sharedInstance] showLoginView:^(NSDictionary *resultDic) {
        //根据登录返回信息，进行相关操作
        NSLog(@"[showLogin] resultDic = %@", resultDic);
        NSString *loginRes = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"loginresult"]];
        if([@"1" isEqualToString:loginRes]){
            NSString *userId = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"userId"]];
            NSString *token = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"token"]];
            NSString *account = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"account"]];
            NSLog(@"登录成功,userId=%@,token=%@", userId, token);
            _isLogin = YES;
            [HNPloyProgressHUD showLoading:@"登录验证..."];
            [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:userId],@"ticket":[JHToolsUtils stringValue:token], @"account":[JHToolsUtils stringValue:account]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
                NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
                if (code != nil && [code isEqualToString:@"1"]) {
                    [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                    [[XiaomoToolsApi sharedInstance] moAddFloatingView];
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
        }else if ([@"0" isEqualToString:loginRes]){
            NSLog(@"登录失败");
        }else{
            NSLog(@"返回主页");
        }
    }];
}
    
- (void) logout{
    if (_isLogin) {
        [[XiaomoToolsApi sharedInstance] moExitLogin:^(NSDictionary *resultDic){
            //在这里写退出登录界面要执行的操作
            [[XiaomoToolsApi sharedInstance] removeFloatingView];
            NSLog(@"[exitLogin] resultDic = %@", resultDic);
            _isLogin = NO;
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
    if (userlog.dataType == TYPE_ENTER_GAME) {
        PlayerInfo *playInfo = [[PlayerInfo alloc]init];
        playInfo.gameService = [JHToolsUtils stringValue:userlog.serverName];
        playInfo.gameServiceId = [NSString stringWithFormat:@"%d", userlog.serverID];
        playInfo.playerName = [JHToolsUtils stringValue:userlog.roleName];
        playInfo.playerLevel = [JHToolsUtils stringValue:userlog.roleLevel];
        
        [[XiaomoToolsApi sharedInstance] moAddPlayerInfo:playInfo completionBlock:^(NSDictionary *resultDict) {
            NSLog(@"playinfo-----------%@",resultDict);
            NSString *payRes = [NSString stringWithFormat:@"%@", [resultDict objectForKey:@"status"]];
            if([@"200" isEqualToString:payRes]){
                NSLog(@"上传成功");
            }else{
                NSLog(@"上传失败");
            }
        }];
    }else if (userlog.dataType == TYPE_LEVEL_UP){
        [[XiaomoToolsApi sharedInstance] changePlayerLevel:[JHToolsUtils stringValue:userlog.roleLevel] completionBlock:^(NSDictionary *resultDic) {
            
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
            orderInfo.goodsName = [JHToolsUtils stringValue:profuctInfo.productName];
            orderInfo.goodsPrice = [NSString stringWithFormat:@"%d", [profuctInfo.price integerValue]*100]; //单位为分
            orderInfo.goodsDesc = [JHToolsUtils stringValue:profuctInfo.productDesc];
            orderInfo.extendInfo = orderNo;
            orderInfo.productId = [JHToolsUtils stringValue:profuctInfo.productId];//虚拟商品在APP Store中的ID
            orderInfo.gameVersion = @"1.0.0";//游戏版本号
            [[XiaomoToolsApi sharedInstance] moPushExchange:orderInfo completionBlock:^(NSDictionary *resultDic) {
                NSLog(@"[pay] resultDic = %@", resultDic);
                NSString *payRes = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"result"]];
                if([@"1" isEqualToString:payRes]){
                    NSLog(@"支付成功");
                }
                if([@"0" isEqualToString:payRes]){
                    NSLog(@"支付失败");
                }
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
    _isLogin = NO;
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
    }
}

@end
