//
//  JHToolsSDK_GameEverestSDK.m
//  JHToolsSDK_GameEverestSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_GameEverestSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import <GameEverestSDK/GameEverestSDK-Swift.h>

@interface JHToolsSDK_GameEverestSDK()

@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, copy) NSString *gameKey;

@end

@implementation JHToolsSDK_GameEverestSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    self.gameid = [JHToolsUtils stringValue:[params valueForKey:@"gameid"]];
    self.gameKey = [JHToolsUtils stringValue:[params valueForKey:@"gameKey"]];
    return self;
}
    
// UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [GameEverestSDK loadWithGameID:self.gameid gameKey:self.gameKey success:^(NSString * message) {
        NSLog(@"%@", message);
    } failute:^(NSString * message) {
        NSLog(@"%@", message);
    }];
}
    
#pragma mark --<IJHToolsUser>
- (void) login{
    [GameEverestSDK loadViewWithCallBack:^(NSString * gid, NSString * pid, NSString * token) {
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:pid],@"ticket":[JHToolsUtils stringValue:token], @"gid":[JHToolsUtils stringValue:gid]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
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
    
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    switch ([profuctInfo.price integerValue]) {
        case 6:
            profuctInfo.productId = @"1560";
            break;
        case 30:
            profuctInfo.productId = @"1561";
            break;
        case 68:
            profuctInfo.productId = @"1562";
            break;
        case 98:
            profuctInfo.productId = @"1563";
            break;
        case 128:
            profuctInfo.productId = @"1564";
            break;
        case 198:
            profuctInfo.productId = @"1565";
            break;
        case 328:
            profuctInfo.productId = @"1566";
            break;
        case 648:
            profuctInfo.productId = @"1567";
            break;
        default:
            break;
    }
    
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            // 扩展游戏参数(以字典形式传入)
            NSDictionary *dict = @{
                    GameKey.Server_Name:[JHToolsUtils stringValue:profuctInfo.serverName],
                    GameKey.Role_ID:[JHToolsUtils stringValue:profuctInfo.roleId],
                    GameKey.Role_Name:[JHToolsUtils stringValue:profuctInfo.roleName],
                    GameKey.Role_Level:[JHToolsUtils stringValue:profuctInfo.roleLevel],
                    GameKey.Exchange_Rate:@"10",
                    GameKey.Goods_Name:[JHToolsUtils stringValue:profuctInfo.productName],
                    GameKey.Currency_Name:@"",
                    GameKey.Game_Name:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                    GameKey.Extend_Param:orderNo};
            [GameEverestSDK productAutoWithProductID:profuctInfo.productId serverID:[JHToolsUtils stringValue:profuctInfo.serverId] priceTag:[profuctInfo.price stringValue] uuid: [[NSUUID UUID] UUIDString] exParame: dict success:^(NSString * msg) {
                NSLog(@"%@", msg);
            } failure:^{
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
