//
//  JHToolsSDK_GoHuoPaySDK.m
//  JHToolsSDK_GoHuoPaySDK
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_GoHuoPaySDK.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"
#import "PayTypeView.h"
#import "LoginView.h"
#import "SwiftFintechClient.h"
#import "SwiftFintechClientType1ConfigModel.h"
#import "SwiftFintechClientType2ConfigModel.h"
#import "SwiftFintechClientType3ConfigModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "NSString+SPUtilsExtras.h"
#import "NSDictionary+SPUtilsExtras.h"
#import "SPRequestForm.h"
#import "SPHTTPManager.h"
#import "SPConst.h"
#import "GohuoClient.h"
#import "SwiftFintechClientConstEnum.h"
#import "SwiftFintechClientConstAppFintechConfig.h"

@interface JHToolsSDK_GoHuoPaySDK()

@property (nonatomic, copy) NSString *notify_url;
@property (nonatomic, copy) NSString *wxappid;
@property (nonatomic, copy) NSString *appid;

@end

@implementation JHToolsSDK_GoHuoPaySDK

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    self.notify_url = [params valueForKey:@"notify_url"];
    self.wxappid = [params valueForKey:@"wxappid"];
    self.appid = [params valueForKey:@"appid"];
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"weixin"]) {
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else{
        return  [[SwiftFintechClient sharedInstance] application:application handleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    [[SwiftFintechClient sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0){
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
    }else if([url.host isEqualToString:@"weixin"]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else{
        return [[SwiftFintechClient sharedInstance] application:app openURL:url options:options];
    }
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[SwiftFintechClient sharedInstance] applicationWillEnterForeground:application];
}
#pragma mark --UIApplicationDelegate事件
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    SwiftFintechClientType1ConfigModel *wecatConfigModel = [[SwiftFintechClientType1ConfigModel alloc] init];
    wecatConfigModel.appScheme =  self.wxappid;
    wecatConfigModel.type1Appid = self.wxappid;
    [[SwiftFintechClient sharedInstance] type1FintechConfig:wecatConfigModel];
    [[SwiftFintechClient sharedInstance] application:application
                       didFinishLaunchingWithOptions:launchOptions];
}
    
#pragma mark --<IJHToolsUser>
- (void) login{
    //调用登录
    LoginView *loginAlertView  = [LoginView actionAlertViewWithAnimationStyle:TSActionAlertViewTransitionStyleFade];
    loginAlertView.backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
    loginAlertView.isAutoHidden = NO;
    [loginAlertView setLoginHandler:^(TSActionAlertView *alertView,NSInteger status,NSString * openid){
        if(status == 200){
            //用户唯一编号（支付用）
            NSLog(@"openid: %@",openid);
        }
    }];
    [loginAlertView show];
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
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
        NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
        if (code != nil && [code isEqualToString:@"1"]) {
            NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
            //选择支付渠道
            PayTypeView * payAlertView  = [PayTypeView actionAlertViewWithAnimationStyle:TSActionAlertViewTransitionStyleBounce];
            payAlertView.backgroundStyle = TSActionAlertViewBackgroundStyleSolid;
            payAlertView.isAutoHidden = NO;
            [payAlertView setStringHandler:^(TSActionAlertView *alertView,NSInteger status,NSString * trade_type){
                if(status == 200){
                    NSDictionary *postInfo = [[SPRequestForm sharedInstance] sp_pay_gateway:@"iOS_PAY" appid:[JHToolsUtils stringValue:self.appid] openid:@"" out_trade_no:orderNo device_info:@"" body:[JHToolsUtils stringValue:profuctInfo.productDesc] total_fee:[profuctInfo.price integerValue] trade_type:trade_type server_name:[JHToolsUtils stringValue:profuctInfo.serverName] remark:@"" notify_url:[JHToolsUtils stringValue:profuctInfo.serverName]];
                    NSLog(@"预下单接口请求数据-->>\n%@",postInfo);
                    NSString *posturl = [NSString stringWithFormat:kSPconstWebApiInterface_pay_gateway,trade_type];
                    NSLog(@"posturl-->>\n%@",posturl);
                    //调用支付预下单接口
                    [[SPHTTPManager sharedInstance] post:posturl paramter:postInfo success:^(id operation, id responseObject) {
                        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        NSLog(@"预下单接口返回数据-->>\n%@",info);
                        //判断解析是否成功
                        if (info && [info isKindOfClass:[NSDictionary class]]) {
                            NSInteger status = [[info objectForKey:@"status"] integerValue];
                            //判断返回的状态值是否是成功,如果成功则调起SDK
                            if (status == 0) {
                                if ([trade_type isEqualToString:@"wechat"]){
                                    NSLog(@"微信支付-->>\n");
                                    if([info objectForKey:@"token_id"] == nil){
                                        NSLog(@"info-->>%@",info);
                                        //调起微信支付
                                        PayReq *req = [[PayReq alloc] init];
                                        req.partnerId = [info objectForKey:@"partnerid"];
                                        req.prepayId = [info objectForKey:@"prepayid"];
                                        req.nonceStr = [info objectForKey:@"noncestr"];
                                        req.timeStamp = [[info objectForKey:@"timeStamp"] intValue];
                                        req.package = [info objectForKey:@"package"];
                                        req.sign = [info objectForKey:@"sign"];
                                        [WXApi sendReq:req];
                                    }else{
                                        NSLog(@"token_id-->>\n%@",[info objectForKey:@"token_id"]);
                                        //获取SDK需要的token_id
                                        NSString *token_id = [info objectForKey:@"token_id"];
                                        //调起SDK支付
                                        [[SwiftFintechClient sharedInstance] fintech:token_id fintechServicesString:[SwiftFintechClientConstAppFintechConfig getType1appKey] finish:^(NSDictionary *payStateDic) {
                                            NSNumber *payState = [payStateDic objectForKey:@"pState"];
                                            NSString *messageStr = [payStateDic objectForKey:@"messageString"];
                                            if (payState.integerValue == SPClientConstEnumFintechSuccess) {
                                                NSLog(@"支付成功");
                                            }else{
                                                NSLog(@"支付失败，错误号:%ld,错误原因:%@",(long)payState.integerValue,messageStr);
                                            }
                                        }];
                                    }
                                }else{
                                    NSLog(@"支付宝-->>\n");
                                    //支付宝
                                    NSString *orderString = [info objectForKey:@"bodyData"];
                                    NSString *appScheme = @"GohuoSDKDemo";
                                    // NOTE: 调用支付结果开始支付
                                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                        NSLog(@"reslut = %@",resultDic);
                                    }];
                                }
                            }else{
                                [HNPloyProgressHUD showInfoMsg:[info objectForKey:@"msg"][@"text"]];
                            }
                        }else{
                            [HNPloyProgressHUD showInfoMsg:@"预下单接口，解析数据失败"];
                        }
                    } failure:^(id operation, NSError *error) {
                        [HNPloyProgressHUD showInfoMsg:@"调用预下单接口失败"];
                        
                        NSLog(@"调用预下单接口失败-->>\n%@",error);
                    }];
                }
            }];
            [payAlertView show];
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
