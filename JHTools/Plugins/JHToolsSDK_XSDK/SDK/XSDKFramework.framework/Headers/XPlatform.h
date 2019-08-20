//
//  XPlatform.h
//  XSDK
//
//  Created by user on 2017/11/8.
//  Copyright © 2017年 xsdk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XGameExtraData.h"
#import "XPayData.h"
#import "XLoginResult.h"
#import "GamePay.h"
#import "ShareInstallSDK.h"


//XSDK相关回调接口， 游戏层在初始化的时候， 传入该delegate
@protocol XPlatformDelegate<NSObject>

-(void) OnInitSuccess;
-(void) OnInitFailed:(NSString*)msg;
-(void) OnLoginSuccess:(XLoginResult*)result;
-(void) OnLoginFailed:(NSString*)msg;
-(void) OnLogoutSuccess;
-(void) OnLogoutFailed:(NSString*)msg;
-(void) OnPaySuccess:(NSString*)msg;
-(void) OnPayFailed:(NSString*)msg;

- (void)wechatoralipay:(NSString *)dic;
@end

typedef NS_ENUM(NSInteger, XSDKStateCode)
{
    XS_NONE = 1,
    XS_INITING,
    XS_INITED,
    XS_LOGINING,
    XS_LOGINED
};

@interface XPlatform : NSObject

@property id<XPlatformDelegate> delegate;

+(XPlatform*) sharedInstance;

-(void)initWithAppId:(NSString*)appId appKey:(NSString*)appKey shareInstallAppkey:(NSString*)shareInstallAppkey delegate:(id<XPlatformDelegate>)delegate;

-(void)login:(UIViewController*)viewController;

-(void)logout;

-(void)submitGameData:(XGameExtraData*)data;

-(void)pay:(XPayData*)data can:(NSString *)can viewController:(UIViewController*)viewController;

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(ShareInstallSDK*)getShareSdkInstance;

@end
