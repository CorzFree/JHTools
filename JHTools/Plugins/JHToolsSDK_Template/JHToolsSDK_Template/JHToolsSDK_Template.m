//
//  JHToolsSDK_Template.m
//  JHToolsSDK_Template
//
//  Created by Star on 2018/3/17.
//  Copyright © 2018年 Star. All rights reserved.
//

#import "JHToolsSDK_Template.h"
#import "JHToolsUtils.h"
#import "HNPloyProgressHUD.h"


@interface JHToolsSDK_Template()

@end

@implementation JHToolsSDK_Template

#pragma mark--implement JHToolsPlugin selector,需要的则重新对应方法
-(instancetype)initWithParams:(NSDictionary *)params{
    [JHToolsSDK sharedInstance].defaultUser = self;
    [JHToolsSDK sharedInstance].defaultPay  = self;
    return self;
}
    
// UIApplicationDelegate事件

    
#pragma mark --<IJHToolsUser>
- (void) login{
    
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
    
}
    
-(void) closeIAP{
}
    
-(void) finishTransactionId:(NSString*)transactionId{
}

    
@end
