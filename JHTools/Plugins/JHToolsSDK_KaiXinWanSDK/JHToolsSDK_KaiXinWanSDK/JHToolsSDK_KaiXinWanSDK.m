//
//  JHToolsSDK_KaiXinWanSDK.m
//  JHToolsSDK_KaiXinWanSDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_KaiXinWanSDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import "LANTsdkManagererCart.h"
#import "LANTRequestModelerCart.h"
#import "LANTRoleModelerCart.h"

@interface JHToolsSDK_KaiXinWanSDK()

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *apikey;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, copy) NSString *version;

@end

@implementation JHToolsSDK_KaiXinWanSDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    
    self.gid = [params valueForKey:@"gid"];
    self.secretKey = [params valueForKey:@"secretKey"];
    self.apikey = [params valueForKey:@"apikey"];
    self.version = [params valueForKey:@"version"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetLoginData:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetPayData:) name:@"pay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetRegisterData:) name:@"register" object:nil];
    
    [LANTsdkManagererCart LANTLoginOutDidSuccess:^(BOOL isSuccess) {
        id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
        if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogout:)]) {
            [sdkDelegate OnUserLogout:nil];
        }
    }];
    
    return self;
}
    
// UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [LANTsdkManagererCart  LANTReVerifyToService];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    [LANTsdkManagererCart LANTWillEnterForeground:application];
}

//iOS9 之后使用这个回调方法。
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [LANTsdkManagererCart application:app openURL:url options:options];
}

//iOS9 之前使用这个回调方法。
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    return [LANTsdkManagererCart application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
}

#pragma mark --<IJHToolsUser>
- (void) login{
    [LANTsdkManagererCart LANTstartLoginWithGid:[JHToolsUtils stringValue:self.gid] apiKey:[JHToolsUtils stringValue:self.apikey] secretKey:[JHToolsUtils stringValue:self.secretKey] version:[JHToolsUtils stringValue:self.version]];
}
    
- (void) logout{
    [LANTsdkManagererCart LANTLoginOutDidSuccess:^(BOOL isSuccess) {
        
    }];
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
    LANTRoleModelerCart *model = [[LANTRoleModelerCart alloc]init];
    model.LANTRoleName = userlog.roleName;
    model.LANTRoleLevel = userlog.roleLevel;
    model.LANTSerVerID = [NSString stringWithFormat:@"%d", userlog.serverID];
    model.LANTServerName = userlog.serverName;
    
    [LANTsdkManagererCart LANTUpdateRoleInfoWithRoleModel:model didSuccess:^(BOOL isUpdateRoleSuccess) {
        if (isUpdateRoleSuccess) {
            NSLog(@"更新角色信息成功");
        }else{
            NSLog(@"更新角色信息失败");
        }
    }];
}
    
    
#pragma mark --<IJHToolsPay>
-(void) pay:(JHToolsProductInfo*) profuctInfo{
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            LANTRequestModelerCart *model = [[LANTRequestModelerCart alloc]init];
            model.LANTproductID = profuctInfo.productId;
            model.LANTserverID = profuctInfo.serverId;
            model.LANTroleName = profuctInfo.roleName;
            model.LANTorderOn = orderNo;
            model.LANTgameName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            model.LANTgoodsNum = @"1";
            model.LANTbody = profuctInfo.productDesc;
            model.LANTattach = orderNo;
            model.LANTamount = [profuctInfo.price stringValue];
            model.LANTRoleLevel = profuctInfo.roleLevel;
            [LANTsdkManagererCart LANTstartPayWithRequestModel:model];
        }else{
            [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"登录验证失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
        }
    }];
}
    
-(void) closeIAP{
}
    
-(void) finishTransactionId:(NSString*)transactionId{
}

#pragma mark -----SDK 通知回调
- (void)notificationGetRegisterData:(NSNotification *)notification {
    NSDictionary  *dict=[notification userInfo];
    NSLog(@"注册获取的uid值:%@",[dict objectForKey:@"uid"]);
    NSLog(@"注册获取的scode值:%@",[dict objectForKey:@"scode"]);
}

-(void)notificationGetLoginData:(NSNotification *)notification{
    NSDictionary  *dict=[notification userInfo];
    NSLog(@"获取的uid值:%@",[dict objectForKey:@"uid"]);
    NSLog(@"获取的scode值:%@",[dict objectForKey:@"scode"]);
    
    [HNPloyProgressHUD showLoading:@"登录验证..."];
    [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":[JHToolsUtils stringValue:[dict objectForKey:@"uid"]],@"ticket":[JHToolsUtils stringValue:[dict objectForKey:@"scode"]]} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
//            [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
            [LANTsdkManagererCart LANTFloatViewForContentTel];
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


-(void)notificationGetPayData:(NSNotification *)notification{

    NSDictionary  *dict=[notification userInfo];
    NSLog(@"获取的code值:%@",[dict objectForKey:@"code"]);
    NSLog(@"获取的mes值:%@",[dict objectForKey:@"mes"]);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
