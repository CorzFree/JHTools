//
//  JHToolsSDK_TQWSDK.m
//  JHToolsSDK_TQWSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_TQWSDK.h"
#import "TQWSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

@interface JHToolsSDK_TQWSDK()

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * channelUserid;
@end

@implementation JHToolsSDK_TQWSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params
{
    //获取info.plist文件中的配置的can'shu
    NSString *appID = [params valueForKey:@"appId"];
    NSString *appKey = [params valueForKey:@"appSecret"];
    NSString *channelID = [params valueForKey:@"Channel"];
    NSString *appgameCpsId= [params valueForKey:@"cpsId"];
    BOOL appRegister = [[params valueForKey:@"appRegister"] boolValue];
    
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    [TQWSDK initWithAppId:appID secret:appKey channel:channelID];
    [TQWSDK setAppgameCpsId:appgameCpsId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tqwRegisterResult:) name:tqwSDKNotiRegist object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tqwLoginResult:) name:tqwSDKNotiLogin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tqwRechargeResult:) name:tqwSDKNotiRecharge object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tqwLogoutResult:) name:tqwSDKNotiLogout object:nil];
    
    //设置是否输出日志，debug模式
    [TQWSDK setLogEnabled:YES];
    [TQWSDK setIncludeUserRegistrationEnabled:appRegister];
    return self;
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [[TQWSDK defaultInstance] login];
}

- (void) logout{
    [[TQWSDK defaultInstance] logout];
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

    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[JHToolsUtils stringValue:self.channelUserid] forKey:ACCOUNT];// 账号
    [attributes setValue:[NSString stringWithFormat:@"%@；%@",[JHToolsUtils stringValue:userlog.roleID],[JHToolsUtils stringValue:userlog.roleName]] forKey:ROLEID];//角色ID
    [attributes setValue:[NSString stringWithFormat:@"%d；%@",userlog.serverID,[JHToolsUtils stringValue:userlog.serverName]] forKey:SERVERID];//服务器id
    [attributes setValue:[JHToolsUtils stringValue:userlog.roleLevel] forKey:LEVEL_NUM];
    
    if (userlog.dataType == TYPE_CREATE_ROLE) {
        [TQWSDK collectData:REG attributes:attributes];
    }else if (userlog.dataType == TYPE_ENTER_GAME) {
        [TQWSDK collectData:LOGIN attributes:attributes];
    }else if (userlog.dataType == TYPE_LEVEL_UP) {
        [TQWSDK collectData:LEVEL attributes:attributes];
    }
}


#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            TQWSDKPayOrderInfo *orderInfo = [[TQWSDKPayOrderInfo alloc] init];
            orderInfo.trade_id= [JHToolsUtils stringValue:orderNo];
            orderInfo.provider=@"Appgame";
            orderInfo.provider_config=@"{'cps_id':'Apple'}"; //详情见 [2. 渠道配置信息 provider_config]
            orderInfo.developerurl= [JHToolsUtils stringValue:data[@"data"][@"notifyUrl"]];
            orderInfo.amount= [NSString stringWithFormat:@"%@",profuctInfo.price];
            orderInfo.currency=@"CNY";
            orderInfo.amount_in_currency= [NSString stringWithFormat:@"%@",profuctInfo.price];;
            orderInfo.product_name= [JHToolsUtils stringValue:profuctInfo.productName];
            orderInfo.game_server_id= [NSString stringWithFormat:@"%@；%@",[JHToolsUtils stringValue:profuctInfo.serverId],[JHToolsUtils stringValue:profuctInfo.serverName]];
            orderInfo.role_id= [NSString stringWithFormat:@"%@；%@",[JHToolsUtils stringValue:profuctInfo.roleId],[JHToolsUtils stringValue:profuctInfo.roleName]];
            orderInfo.private_info= [JHToolsUtils stringValue:orderNo];
            [[TQWSDK defaultInstance]  payOrderInfo:orderInfo];
            
            UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
            NSString *timestamp = [NSString stringWithFormat:@"%llu",recordTime];
            NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
            [attributes setValue:[JHToolsUtils stringValue:self.channelUserid] forKey:ACCOUNT];// 账号
            [attributes setValue:[NSString stringWithFormat:@"%@；%@",[JHToolsUtils stringValue:profuctInfo.roleId],[JHToolsUtils stringValue:profuctInfo.roleName]] forKey:ROLEID];//角色ID
            [attributes setValue:[NSString stringWithFormat:@"%@；%@",[JHToolsUtils stringValue:profuctInfo.serverId],[JHToolsUtils stringValue:profuctInfo.serverName]] forKey:SERVERID];//服务器id
            [attributes setValue:[JHToolsUtils stringValue:orderNo] forKey:TRADE_ID];//交易id
            [attributes setValue:[JHToolsUtils stringValue:orderNo] forKey:APPGAME_ORDER_ID];//订单id
            [attributes setValue:@"CNY" forKey:CURRENCY];//币种单位
            [attributes setValue:[JHToolsUtils stringValue:profuctInfo.productName] forKey:PRODUCT_NAME];//商品名称
            [attributes setValue:[NSString stringWithFormat:@"%@",profuctInfo.price] forKey:AMOUNT];//订单金额
            [attributes setValue:[NSString stringWithFormat:@"%@",profuctInfo.price] forKey:AMOUNT_IN_CURRENCY];//币种金额
            [attributes setValue:[JHToolsUtils stringValue:[self localIPAddress]] forKey:IP];
            [attributes setValue:[JHToolsUtils stringValue:timestamp]  forKey:CREATED_AT];
            [attributes setValue:[JHToolsUtils stringValue:timestamp]  forKey:COMPLETED_AT];//完成时间

            [TQWSDK collectData:ORDERS attributes:attributes];
            [TQWSDK collectData:FISISHORDERS attributes:attributes];
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

- (void)tqwRegisterResult:(NSNotification *)notify{
    
    NSLog(@"注册成功:%@",notify);
}

- (void)tqwLoginResult:(NSNotification *)notify{
    
    NSLog(@"登录成功:%@",notify);
    dispatch_async(dispatch_get_main_queue(), ^{
        [HNPloyProgressHUD showLoading:@"登录验证..."];
        NSString * token = [[TQWSDK defaultInstance] accessToken];
        [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"ticket":[JHToolsUtils stringValue:token]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
            NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
            if (code != nil && [code isEqualToString:@"1"]) {
                [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
                self.uid = [JHToolsUtils getResponseUidWithDict:data];
                [JHToolsSDK sharedInstance].proxy.userID = self.uid;
                self.channelUserid = [JHToolsUtils getResponseChannelUseridWithDict:data];
                //回调返回参数
                [[TQWSDK defaultInstance] showFloatingButton:[UIApplication sharedApplication].keyWindow place:TQW_SDK_TOOLBAR_BOT_LEFT];
                
                id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
                if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
                    [sdkDelegate OnUserLogin:data];
                }
            }else{
                [HNPloyProgressHUD showFailure:@"登录验证失败！"];
            }
        }];
    });

}

- (void)tqwRechargeResult:(NSNotification *)notify{
    NSLog(@"充值结果%@",notify);
    NSDictionary *userInfo = notify.userInfo;
//    int code = [[userInfo objectForKey:tqwSDKKeyCode] intValue];
//    NSString *msg = [userInfo objectForKey:tqwSDKKeyCode] ;
    NSString *trade_id = [userInfo objectForKey:tqwSDKKeyTradeId] ;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%llu",recordTime];
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[JHToolsUtils stringValue:trade_id] forKey:APPGAME_ORDER_ID];//订单id
    [attributes setValue:@"complete" forKey:STATUS];//订单状态
    [attributes setValue:[NSNumber numberWithBool:false]  forKey:SANDBOX];
    [attributes setValue:[JHToolsUtils stringValue:timestamp]  forKey:COMPLETED_AT];
    [attributes setValue:[JHToolsUtils stringValue:timestamp]  forKey:CANCELED_AT];
    [TQWSDK collectData:UPORDERS attributes:attributes];
}

- (void)tqwLogoutResult:(NSNotification *)notify {
    id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
    if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
        [[TQWSDK defaultInstance] hideFloatingButton];
        [sdkDelegate OnUserLogout:nil];
    }
}


- (NSString *)localIPAddress
{
    
    NSError *error;
    
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    //判断返回字符串是否为所需数据
    
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        
        //对字符串进行处理，然后进行json解析
        
        //删除字符串多余字符串
        
        NSRange range = NSMakeRange(0, 19);
        
        [ip deleteCharactersInRange:range];
        
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        
        //将字符串转换成二进制进行Json解析
        
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dict);
        
        return dict[@"cip"] ? dict[@"cip"] : @"";
        
    }
    
    return @"";
    
}


@end
