//
//  JHToolsSDK_CommonSDK.m
//  JHToolsSDK_CommonSDK
//
//  Created by star on 2018/12/19.
//  Copyright © 2018年 star. All rights reserved.
//

#import "JHToolsSDK_CommonSDK.h"
#import "WanAppStroeSDK/WanManager.h"
#import <UIKit/UIKit.h>
#import "HNPloyProgressHUD.h"
#import "JHToolsUtils.h"

@interface JHToolsSDK_CommonSDK()

@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, copy) NSString *channelUid;//渠道返回的id
@property (nonatomic, copy) NSString *uid;//JHToolsid

@end

@implementation JHToolsSDK_CommonSDK

#pragma mark -- <IJHToolsUser>
- (void) login{
    [[WanManager shareInstance] showLoginViewInView:[UIApplication sharedApplication].keyWindow withGameID:self.gameid loginSuccessBlock:^(NSString *uid, NSString *ticket) {
        self.channelUid = uid;
        if (uid == nil || ticket == nil) {
            return ;
        }
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:uid],@"ticket":[JHToolsUtils stringValue:ticket]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                self.uid = [JHToolsUtils getResponseUidWithDict:data];
                [JHToolsSDK sharedInstance].proxy.userID = self.uid;
                //显示悬浮窗
                [[WanManager shareInstance] showTipWithGameid:self.gameid uid:uid];
                //回调返回参数
                id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
                if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
                    [sdkDelegate OnUserLogin:data];
                }
            }else{
                [HNPloyProgressHUD showFailure:@"登录验证失败！"];
            }
        }];
    }];
}

- (void) logout{
    [[WanManager shareInstance] hidenTip];
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [sdkDelegate OnUserLogout:nil];
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

#pragma mark -- <IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    
    NSDictionary *params = @{
                             @"money":[profuctInfo.price stringValue],
                             @"balance":@"0",
                             @"goodsName":[JHToolsUtils stringValue:profuctInfo.productName],
                             @"cpData":profuctInfo.extension,
                             @"gameid":[JHToolsUtils stringValue:self.gameid],
                             @"gain":@"0",
                             @"uid":[JHToolsUtils stringValue:self.channelUid],
                             @"serverid":[JHToolsUtils stringValue:profuctInfo.serverId],
                             @"roleName":[JHToolsUtils stringValue:profuctInfo.roleName],
                             @"desc":[JHToolsUtils stringValue:profuctInfo.productDesc],
                             @"productID":[JHToolsUtils stringValue:profuctInfo.productId]
                             };
    
    [[WanManager shareInstance] showPayViewInView:[UIApplication sharedApplication].keyWindow withParamters:params withPaySuccessBlock:^{
        id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
        if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnPayPaid:)]) {
            [sdkDelegate OnPayPaid:nil];
        }
    }];
}

-(void) closeIAP{
}

-(void) finishTransactionId:(NSString*)transactionId{
}

#pragma mark --parent selector
-(instancetype)initWithParams:(NSDictionary *)params
{
    self.gameid = [params valueForKey:@"gameid"];
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}

-(void)submitUserInfo:(JHToolsUserExtraData *)data{
    [[WanManager shareInstance] uploadUid:[JHToolsUtils stringValue:self.channelUid] gameID:[JHToolsUtils stringValue:self.gameid] serverID:[NSString stringWithFormat:@"%d", data.serverID] serverName:[JHToolsUtils stringValue:data.serverName] roleName:[JHToolsUtils stringValue:data.roleName] roleLevel:[JHToolsUtils stringValue:data.roleLevel] failde:nil];
}

@end
